part of 'get_post_bloc.dart';

sealed class GetPostState extends Equatable {
  const GetPostState();

  @override
  List<Object?> get props => [];
}

class GetPostInitial extends GetPostState {}

class GetPostFailure extends GetPostState {}

class GetPostLoading extends GetPostState {}

class GetPostSuccess extends GetPostState {
  final List<Post> posts;

  const GetPostSuccess(this.posts);
}
