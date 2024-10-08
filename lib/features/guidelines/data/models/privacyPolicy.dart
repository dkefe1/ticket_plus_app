class PrivacyPolicy {
  final String id;
  final String title;
  final String content;

  PrivacyPolicy({required this.id, required this.title, required this.content});

  factory PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicy(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        content: json['content']?.toString() ?? '');
  }
}
