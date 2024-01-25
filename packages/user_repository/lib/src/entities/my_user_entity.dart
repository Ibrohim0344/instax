import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? picture;

  const MyUserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.picture,
  });

  Map<String, Object?> toDocument() => {
        "id": id,
        "email": email,
        "name": name,
        "picture": picture,
      };

  static MyUserEntity fromDocument(Map<String, Object?> doc) => MyUserEntity(
        id: doc["id"] as String,
        email: doc["email"] as String,
        name: doc["name"] as String,
        picture: doc["picture"] as String?,
      );

  @override
  String toString() => """UserEntity(
    id: $id,
    email: $email,
    name: $name,
    picture: $picture,
  );""";

  @override
  List<Object?> get props => [id, email, name, picture];
}
