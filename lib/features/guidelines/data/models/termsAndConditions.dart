class TermsAndConditions {
  final String id;
  final String title;
  final String content;

  TermsAndConditions(
      {required this.id, required this.title, required this.content});

  factory TermsAndConditions.fromJson(Map<String, dynamic> json) {
    return TermsAndConditions(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        content: json['content']?.toString() ?? '');
  }
}
