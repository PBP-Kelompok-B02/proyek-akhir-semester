import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyek_akhir_semester/internal/auth.dart';
import 'package:proyek_akhir_semester/models/food_entry.dart';
import 'package:proyek_akhir_semester/dashboard/widgets/user_food_card.dart';

class FoodListPage extends StatefulWidget {
  const FoodListPage({super.key});

  @override
  State<FoodListPage> createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  Future<List<Food>> fetchFood(CookieRequest request) async {
    final response = await request.get('https://b02.up.railway.app/profile/json/');

    var foodsData = response;
    List<Food> listFood = [];
    for (var d in foodsData) {
      if (d != null) {
        listFood.add(Food.fromJson(d));
      }
    }
    return listFood;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    var orientation = MediaQuery.of(context).orientation;
    int crossAxisCount = orientation == Orientation.portrait ? 2 : 4;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFCF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF602231),
        elevation: 0,
        title: const Text(
          'Daftar Makanan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xFF602231),
        onRefresh: () async {
          setState(() {});
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF602231),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.fastfood,
                                  color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                  'Daftar Makanan Anda',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 8),
                          Text(
                            'Kelola makanan Anda di sini!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFBFCF8),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: FutureBuilder<List<Food>>(
                future: fetchFood(request),
                builder: (context, AsyncSnapshot<List<Food>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF602231),
                        ),
                      ),
                    );
                  }
                  
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.no_food,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Belum ada makanan yang ditambahkan",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = snapshot.data![index];
                        return UserFoodCard(
                          food: item,
                          onDelete: () {
                            setState(() {
                              snapshot.data!.removeAt(index);
                            });
                          },
                        );
                      },
                      childCount: snapshot.data!.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.8,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}