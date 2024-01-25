import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instax/blocs/update_user_info/update_user_info_bloc.dart';
import 'package:instax/screens/home/post_screen.dart';
import 'package:intl/intl.dart';
import 'package:post_repository/post_repository.dart';

import '../../blocs/create_post/create_post_bloc.dart';
import '../../blocs/get_post/get_post_bloc.dart';
import '../../blocs/my_user/my_user_bloc.dart';
import '../../blocs/sign_in/sign_in_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void pickImage(BuildContext context) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 500,
      maxWidth: 500,
      imageQuality: 40,
    );

    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.square],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Cropper",
            toolbarColor: Theme.of(context).colorScheme.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: "Cropper"),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          context.read<UpdateUserInfoBloc>().add(UploadPicture(
                file: croppedFile.path,
                userId: context.read<MyUserBloc>().state.user!.id,
              ));
        });
      }
    }
  }

  void updateListener(BuildContext context, UpdateUserInfoState state) {
    if (state is UploadPictureSuccess) {
      context.read<MyUserBloc>().state.user!.picture = state.userImage;
      setState(() {});
    }
  }

  void createPost(MyUserState state) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider<CreatePostBloc>(
          create: (context) => CreatePostBloc(
            postRepository: FirebasePostRepository(),
          ),
          child: PostScreen(state.user!),
        ),
      ),
    );
  }

  Future<void> onRefresh() async {
    context.read<GetPostBloc>().add(GetPosts());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
      listener: updateListener,
      child: Scaffold(
        backgroundColor: colorScheme.background,
        floatingActionButton: BlocBuilder<MyUserBloc, MyUserState>(
          builder: (context, state) {
            return state.status == MyUserStatus.success
                ? FloatingActionButton(
                    onPressed: () => createPost(state),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: const CircleBorder(),
                    child: Icon(
                      CupertinoIcons.add,
                      color: colorScheme.background,
                    ),
                  )
                : FloatingActionButton(
                    onPressed: null,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: const CircleBorder(),
                    child: Icon(
                      CupertinoIcons.clear,
                      color: colorScheme.background,
                    ),
                  );
          },
        ),
        appBar: AppBar(
          backgroundColor: colorScheme.background,
          centerTitle: false,
          title: BlocBuilder<MyUserBloc, MyUserState>(
            builder: (context, state) {
              if (state.status == MyUserStatus.success) {
                return Row(
                  children: [
                    state.user!.picture == ""
                        ? GestureDetector(
                            onTap: () => pickImage(context),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade300,
                              ),
                              child: Icon(
                                CupertinoIcons.person,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () => pickImage(context),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                                image: DecorationImage(
                                  image: NetworkImage(state.user!.picture!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(width: 10),
                    Text("Welcome ${state.user!.name}"),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.read<SignInBloc>().add(const SignOutRequired());
              },
              icon: Icon(
                CupertinoIcons.square_arrow_right,
                color: colorScheme.error,
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await onRefresh();
          },
          child: BlocBuilder<GetPostBloc, GetPostState>(
            builder: (context, state) {
              if (state is GetPostSuccess) {
                return ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, int i) {
                    final eachPost = state.posts[i];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          eachPost.myUser.picture!,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        eachPost.myUser.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(DateFormat("EEE, M/d/y")
                                          .format(state.posts[i].createdAt)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 15),
                              Padding(
                                padding: const EdgeInsets.only(left: 7, top: 8),
                                child: Text(eachPost.post),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (state is GetPostLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: LinearProgressIndicator(),
                  ),
                );
              } else {
                return const Center(
                  child: Text("An error has occurred"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
