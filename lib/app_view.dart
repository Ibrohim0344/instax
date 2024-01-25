import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/blocs/get_post/get_post_bloc.dart';
import 'package:post_repository/post_repository.dart';

import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/my_user/my_user_bloc.dart';
import 'blocs/sign_in/sign_in_bloc.dart';
import 'blocs/update_user_info/update_user_info_bloc.dart';
import 'screens/home/home_screen.dart';
import 'screens/authentication/welcome_screen.dart';

  class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insta X',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
            background: Colors.white,
            onBackground: Colors.black,
            primary: Color.fromRGBO(206, 147, 216, 1),
            onPrimary: Colors.black,
            secondary: Color.fromRGBO(244, 143, 177, 1),
            onSecondary: Colors.white,
            tertiary: Color.fromRGBO(255, 204, 128, 1),
            error: Colors.red,
            outline: Color(0xFF424242)),
        useMaterial3: true,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => SignInBloc(
                    userRepository:
                        context.read<AuthenticationBloc>().userRepository,
                  ),
                ),
                BlocProvider(
                  create: (context) => UpdateUserInfoBloc(
                    userRepository:
                        context.read<AuthenticationBloc>().userRepository,
                  ),
                ),
                BlocProvider(
                  create: (context) => MyUserBloc(
                    userRepository:
                        context.read<AuthenticationBloc>().userRepository,
                  )..add(GetMyUser(
                      myUserId:
                          context.read<AuthenticationBloc>().state.user!.uid,
                    )),
                ),
                BlocProvider(
                  create: (context) => GetPostBloc(
                    postRepository: FirebasePostRepository(),
                  )..add(GetPosts()),
                ),
              ],
              child: const HomeScreen(),
            );
          } else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
