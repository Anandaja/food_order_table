// ignore_for_file: non_constant_identifier_names

class LoginCredentials {
  String Username = '';
  String Password = '';

  LoginCredentials({required this.Username, required this.Password});

  LoginCredentials.fromJson(dynamic json) {
    Username = json['Username'] ?? '';
    Password = json['Password'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Username'] = Username;
    map['Password'] = Password;

    return map;
  }

  LoginCredentials copyWith(
          {required String Username,
          required String Password,
          required int age}) =>
      LoginCredentials(Username: Username, Password: Password);
}
