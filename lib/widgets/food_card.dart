import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/models/food_entry.dart';
import 'package:proyek_akhir_semester/screens/food_detail.dart';
import 'package:proyek_akhir_semester/widgets/bookmark_provider.dart';
import 'package:provider/provider.dart';

class FoodCard extends StatelessWidget {
  final Food food;

  const FoodCard({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailPage(foodId: food.pk),
          ),
        );
      },
      child: Card(
        color: const Color(0xFFFBFCF8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                food.fields.image.isNotEmpty
                    ? Image.network(
                        food.fields.image,
                        width: double.infinity,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: double.infinity,
                        height: 100,
                        color: Colors.grey,
                        child: const Icon(Icons.image_not_supported),
                      ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<BookmarkProvider>(
                    builder: (context, bookmarkProvider, _) {
                      final isBookmarked = bookmarkProvider.isBookmarked(food);
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: isBookmarked ? Colors.yellow : Colors.white,
                          ),
                          onPressed: () =>
                              bookmarkProvider.toggleBookmark(food),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  food.fields.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Price: Rp ${food.fields.price}',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
