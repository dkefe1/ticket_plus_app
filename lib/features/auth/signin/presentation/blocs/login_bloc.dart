import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_app/features/auth/signin/data/repositories/loginRepository.dart';
import 'package:ticketing_app/features/auth/signin/presentation/blocs/login_event.dart';
import 'package:ticketing_app/features/auth/signin/presentation/blocs/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginRepository loginRepository;
  LoginBloc(this.loginRepository) : super(LoginInitialState()) {
    on<LoginAttendee>(_onLoginAttendee);
  }

  void _onLoginAttendee(LoginAttendee event, Emitter emit) async {
    emit(LoginLoadingState());
    try {
      await loginRepository.loginAttendee(event.login);
      emit(LoginSuccessfulState());
    } catch (e) {
      emit(LoginFailureState(e.toString()));
    }
  }
}
