class SignUp {
  final String first_name;
  final String last_name;
  final String phone_number;
  final String date_of_birth;
  final String password;
  final String password_confirm;

  SignUp(
      {required this.first_name,
      required this.last_name,
      required this.phone_number,
      required this.date_of_birth,
      required this.password,
      required this.password_confirm});
}
