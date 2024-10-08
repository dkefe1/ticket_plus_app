import 'package:ticketing_app/features/auth/signin/data/dataSources/remoteDatasource/loginDatasource.dart';
import 'package:ticketing_app/features/auth/signin/data/models/login.dart';

class LoginRepository {
  LoginRemoteDataSource loginRemoteDataSource;
  LoginRepository(this.loginRemoteDataSource);

  Future loginAttendee(Login login) async {
    try {
      await loginRemoteDataSource.loginAttendee(login);
    } catch (e) {
      throw e;
    }
  }
}
