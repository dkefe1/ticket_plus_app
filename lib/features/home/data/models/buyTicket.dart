import 'package:ticketing_app/features/home/data/models/ticketInputs.dart';

class BuyTicket {
  final int total_price;
  final String phone_number;
  final TicketInputs inputs;
  final String event_id;

  BuyTicket({
    required this.total_price,
    required this.phone_number,
    required this.inputs,
    required this.event_id,
  });
}
