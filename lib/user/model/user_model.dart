class UserData {
  final String? name;
  final int? age;
  final String? email;

  UserData({required this.name, required this.age, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'email': email,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'],
      age: map['age'],
      email: map['email'],
    );
  }
}
