import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String email;
  final String name;
  final bool isLoggedIn;

  const UserModel({
    required this.email,
    this.name = '',
    this.isLoggedIn = false,
  });

  UserModel copyWith({
    String? email,
    String? name,
    bool? isLoggedIn,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'isLoggedIn': isLoggedIn,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json['email'] as String? ?? '',
        name: json['name'] as String? ?? '',
        isLoggedIn: json['isLoggedIn'] as bool? ?? false,
      );

  @override
  List<Object?> get props => [email, name, isLoggedIn];
}
