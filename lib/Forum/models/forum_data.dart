class Reply {
  final int id;
  final String content, createdAt, createdBy;

  Reply({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.createdBy,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
    id: json['id'],
    content: json['content'],
    createdAt: json['created_at'],
    createdBy: json['created_by'],
  );
}

class ForumDatum {
  final int id;
  final String title, description, createdAt, createdBy;
  final List<Reply> replies;

  ForumDatum({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.createdBy,
    required this.replies,
  });

  factory ForumDatum.fromJson(Map<String, dynamic> json) => ForumDatum(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    createdAt: json['created_at'],
    createdBy: json['created_by'],
    replies: List<Reply>.from(
      (json['replies'] as List).map((x) => Reply.fromJson(x))
    ),
  );
}

