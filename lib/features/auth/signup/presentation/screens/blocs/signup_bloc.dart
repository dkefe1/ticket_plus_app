import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_app/features/auth/signup/data/repositories/signupRepository.dart';
import 'package:ticketing_app/features/auth/signup/presentation/screens/blocs/signup_event.dart';
import 'package:ticketing_app/features/auth/signup/presentation/screens/blocs/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignUpRepository signUpRepository;
  SignupBloc(this.signUpRepository) : super(SignupInitialState()) {
    on<SignupAttendee>(_onSignupAttendee);
  }

  void _onSignupAttendee(SignupAttendee event, Emitter emit) async {
    emit(SignupLoadingState());
    try {
      final agreeTerms = await signUpRepository.signupAttendee(event.signup);
      emit(SignupSuccessfulState(agreeTerms));
    } catch (e) {
      emit(SignupFailureState(e.toString()));
    }
  }
}
