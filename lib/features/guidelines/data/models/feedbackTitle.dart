class FeedbackTitle {
  final String id;
  final String title;
  FeedbackTitle({required this.id, required this.title});

  factory FeedbackTitle.fromJson(Map<String, dynamic> json) {
    return FeedbackTitle(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '');
  }
}
