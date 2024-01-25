import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';

import '../../blocs/create_post/create_post_bloc.dart';
import '../../blocs/get_post/get_post_bloc.dart';

class PostScreen extends StatefulWidget {
  final MyUser myUser;

  const PostScreen(this.myUser, {super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Post post;
  late final TextEditingController _controller;

  void createdPost(BuildContext context) {
    if (_controller.text.isNotEmpty) {
      setState(() {
        post.post = _controller.text;
      });
      context.read<CreatePostBloc>().add(CreatePost(post));
      log(post.toString());
    }
    context.read<GetPostBloc>().add(GetPosts());
  }

  @override
  void initState() {
    post = Post.empty;
    post.myUser = widget.myUser;
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state is CreatePostSuccess) {
          Navigator.pop(context);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: colorScheme.background,
          appBar: AppBar(
            elevation: 0,
            foregroundColor: colorScheme.background,
            backgroundColor: colorScheme.secondary,
            title: const Text("Create a Post !"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => createdPost(context),
            backgroundColor: colorScheme.secondary,
            foregroundColor: colorScheme.background,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: const CircleBorder(),
            child: const Icon(CupertinoIcons.checkmark),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _controller,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: "Enter your post here ...",
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
