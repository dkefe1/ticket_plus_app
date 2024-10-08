import 'package:ticketing_app/features/auth/signup/data/dataSources/remoteDatasource/signupDatasource.dart';
import 'package:ticketing_app/features/auth/signup/data/models/signUp.dart';

class SignUpRepository {
  SignupRemoteDatasource signUpRemoteDataSource;
  SignUpRepository(this.signUpRemoteDataSource);

  Future signupAttendee(SignUp signup) async {
    try {
      bool agreeTerms = await signUpRemoteDataSource.signupAttendee(signup);
      return agreeTerms;
    } catch (e) {
      throw e;
    }
  }
}
