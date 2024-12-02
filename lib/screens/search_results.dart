import 'package:flutter/material.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;
  final bool sortByPriceDescending;
  final List<Map<String, String>> foodItems;

  const SearchResultsPage({
    super.key,
    required this.query,
    required this.sortByPriceDescending,
    required this.foodItems,
  });

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late bool sortByPriceDescending;

  @override
  void initState() {
    super.initState();
    sortByPriceDescending = widget.sortByPriceDescending;
  }

  List<Map<String, String>> get filteredAndSortedItems {
    List<Map<String, String>> filteredItems = widget.foodItems
        .where((item) =>
            item['name']!.toLowerCase().contains(widget.query.toLowerCase()))
        .toList();

    if (sortByPriceDescending) {
      filteredItems.sort((a, b) =>
          _parsePrice(b['price']!).compareTo(_parsePrice(a['price']!)));
    } else {
      filteredItems.sort((a, b) =>
          _parsePrice(a['price']!).compareTo(_parsePrice(b['price']!)));
    }

    return filteredItems;
  }

  int _parsePrice(String price) {
    return int.parse(price.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    int crossAxisCount = orientation == Orientation.portrait ? 2 : 4;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        backgroundColor: const Color(0xFF592634),
      ),
      body: Container(
        color:
            const Color(0xFFFBFCF8), // Set your desired background color here
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      sortByPriceDescending
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                    ),
                    onPressed: () {
                      setState(() {
                        sortByPriceDescending = !sortByPriceDescending;
                      });
                    },
                  ),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: filteredAndSortedItems.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemBuilder: (context, index) {
                    final item = filteredAndSortedItems[index];
                    return Card(
                      child: Column(
                        children: [
                          Image.asset(
                            item['image']!,
                            width: double.infinity,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(item['name']!),
                                Text('Rp ${item['price']}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
