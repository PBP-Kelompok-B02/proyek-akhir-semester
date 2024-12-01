import 'package:flutter/material.dart';

class ReviewList extends StatelessWidget {
  final List<Map<String, String>> reviews;

  const ReviewList({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: reviews.map((review) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.person),
            title: Text(review['author'] ?? 'Anonymous'),
            subtitle: Text(review['comment'] ?? 'No comment provided'),
          ),
        );
      }).toList(),
    );
  }
}
