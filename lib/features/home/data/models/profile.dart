class Profile {
  final String id;
  final String first_name;
  final String last_name;
  final String phone_number;
  final String role;
  final String password;
  final String date_of_birth;
  final String full_name;

  Profile(
      {required this.id,
      required this.first_name,
      required this.last_name,
      required this.phone_number,
      required this.role,
      required this.password,
      required this.date_of_birth,
      required this.full_name});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
        id: json['id']?.toString() ?? '',
        first_name: json['first_name']?.toString() ?? '',
        last_name: json['last_name']?.toString() ?? '',
        phone_number: json['phone_number']?.toString() ?? '',
        role: json['role']?.toString() ?? '',
        password: json['password']?.toString() ?? '',
        date_of_birth: json['date_of_birth']?.toString() ?? '',
        full_name: json['full_name']?.toString() ?? '');
  }
}
