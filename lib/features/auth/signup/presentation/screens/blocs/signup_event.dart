import 'package:ticketing_app/features/auth/signup/data/models/signUp.dart';

abstract class SignupEvent {}

class SignupAttendee extends SignupEvent {
  final SignUp signup;
  SignupAttendee(this.signup);
}
