abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessfulState extends LoginState {}

class LoginFailureState extends LoginState {
  final String error;
  LoginFailureState(this.error);
}
