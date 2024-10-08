import 'package:ticketing_app/features/auth/signin/data/models/login.dart';

abstract class LoginEvent {}

class LoginAttendee extends LoginEvent {
  final Login login;
  LoginAttendee(this.login);
}
