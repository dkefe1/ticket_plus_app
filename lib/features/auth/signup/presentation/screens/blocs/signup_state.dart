abstract class SignupState {}

class SignupInitialState extends SignupState {}

class SignupLoadingState extends SignupState {}

class SignupSuccessfulState extends SignupState {
  final bool agreeTerms;
  SignupSuccessfulState(this.agreeTerms);
}

class SignupFailureState extends SignupState {
  final String error;
  SignupFailureState(this.error);
}
