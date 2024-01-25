import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import '../../blocs/sign_up/sign_up_bloc.dart';
import '../../components/check_text_style.dart';
import '../../components/my_textfield.dart';
import '../../components/strings.dart';

part 'sign_up_mixin/sign_up_mixin.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SignUpMixin {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final colorScheme = Theme
        .of(context)
        .colorScheme;

    return BlocListener<SignUpBloc, SignUpState>(
      listener: signUpListener,
      child: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: size.width * 0.9,
                child: MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(CupertinoIcons.mail_solid),
                  validator: _emailValidator,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width * 0.9,
                child: MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: const Icon(CupertinoIcons.lock_fill),
                  onChanged: _onChanged,
                  suffixIcon: IconButton(
                    onPressed: makeObscure,
                    icon: Icon(iconPassword),
                  ),
                  validator: _passwordValidator,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckText(
                        text: "⚈  1 uppercase",
                        contains: containsUpperCase,
                      ),
                      CheckText(
                        text: "⚈  1 lowercase",
                        contains: containsLowerCase,
                      ),
                      CheckText(
                        text: "⚈  1 number",
                        contains: containsNumber,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckText(
                        text: "⚈  1 special character",
                        contains: containsSpecialChar,
                      ),
                      CheckText(
                        text: "⚈  8 minimum character",
                        contains: contains8Length,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width * 0.9,
                child: MyTextField(
                  controller: nameController,
                  hintText: 'Name',
                  obscureText: false,
                  keyboardType: TextInputType.name,
                  prefixIcon: const Icon(CupertinoIcons.person_fill),
                  validator: _nameValidator,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              !signUpRequired
                  ? SizedBox(
                width: size.width * 0.5,
                child: TextButton(
                  onPressed: checkValidate,
                  style: TextButton.styleFrom(
                    elevation: 3.0,
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 5,
                    ),
                    child: Text(
                      'Sign Up',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
                  : const CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
