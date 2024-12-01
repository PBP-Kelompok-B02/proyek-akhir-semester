import 'package:flutter/material.dart';

class AddReviewPage extends StatelessWidget {
  const AddReviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController authorController = TextEditingController();
    final TextEditingController commentController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Review"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Author",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Your name",
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Comment",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Your review",
              ),
            ),
            const SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Lakukan penyimpanan review
                  final author = authorController.text;
                  final comment = commentController.text;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Review added by $author"),
                    ),
                  );

                  Navigator.pop(context);
                },
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
