import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_repository/user_repository.dart';

class PostEntity {
  String postId;
  String post;
  DateTime createdAt;
  MyUser myUser;

  PostEntity({
    required this.postId,
    required this.post,
    required this.createdAt,
    required this.myUser,
  });

  Map<String, Object?> toDocument() => {
        "postId": postId,
        "post": post,
        "createdAt": createdAt,
        "myUser": myUser.toEntity().toDocument(),
      };

  static PostEntity fromDocument(Map<String, Object?> doc) => PostEntity(
      postId: doc["postId"] as String,
      post: doc["post"] as String,
      createdAt: (doc["createdAt"] as Timestamp).toDate(),
      myUser: MyUser.fromEntity(
        MyUserEntity.fromDocument(doc["myUser"] as Map<String, Object?>),
      ));

  @override
  String toString() => """PostEntity(
    postId: $postId,
    post: $post,
    createdAt: $createdAt,
    myUser: $myUser,
  );""";
}
