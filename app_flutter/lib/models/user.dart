class UserProfile {
  String name;
  final String email;
  String password;
  bool verified;

  UserProfile({
    required this.name,
    required this.email,
    required this.password,
    this.verified = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'verified': verified,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      password: map['password'] as String? ?? '',
      verified: map['verified'] as bool? ?? false,
    );
  }
}
