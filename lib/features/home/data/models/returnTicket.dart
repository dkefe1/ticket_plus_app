class ReturnTicket {
  final String id;
  final ReturnEventTicket event;

  ReturnTicket({required this.id, required this.event});

  factory ReturnTicket.fromJson(Map<String, dynamic> json) {
    return ReturnTicket(
      id: json['_id'],
      event: ReturnEventTicket.fromJson(json['event_id']),
    );
  }
}

class ReturnEventTicket {
  final String eventId;
  final String eventName;
  final String eventDate;
  final String coverImageUrl;

  ReturnEventTicket({
    required this.eventId,
    required this.eventName,
    required this.eventDate,
    required this.coverImageUrl,
  });

  factory ReturnEventTicket.fromJson(Map<String, dynamic> json) {
    return ReturnEventTicket(
      eventId: json['_id'],
      eventName: json['event_name'],
      eventDate: json['event_date'],
      coverImageUrl: json['cover_image_url'],
    );
  }
}
