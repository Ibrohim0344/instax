import 'package:user_repository/user_repository.dart';

import '../../post_repository.dart';

class Post {
  String postId;
  String post;
  DateTime createdAt;
  MyUser myUser;

  Post({
    required this.postId,
    required this.post,
    required this.createdAt,
    required this.myUser,
  });

  /// Empty user which represents an unauthenticated user.
  static final empty = Post(
    postId: "",
    post: "",
    createdAt: DateTime.now(),
    myUser: MyUser.empty,
  );

  /// Modify Post parameters
  Post copyWith({
    String? postId,
    String? post,
    DateTime? createdAt,
    MyUser? myUser,
  }) =>
      Post(
        postId: postId ?? this.postId,
        post: post ?? this.post,
        createdAt: createdAt ?? this.createdAt,
        myUser: myUser ?? this.myUser,
      );

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == Post.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != Post.empty;

  PostEntity toEntity() => PostEntity(
        postId: postId,
        post: post,
        createdAt: createdAt,
        myUser: myUser,
      );

  static Post fromEntity(PostEntity entity) => Post(
        postId: entity.postId,
        post: entity.post,
        createdAt: entity.createdAt,
        myUser: entity.myUser,
      );

  @override
  String toString() => """Post(
    postId: $postId,
    post: $post,
    createdAt: $createdAt,
    myUser: $myUser,
  );""";
}
