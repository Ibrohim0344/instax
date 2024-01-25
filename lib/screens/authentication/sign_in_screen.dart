import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/sign_in/sign_in_bloc.dart';
import '../../components/my_textfield.dart';
import '../../components/strings.dart';

part 'sign_in_mixin/sign_in_mixin.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SignInMixin {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocListener<SignInBloc, SignInState>(
      listener: signInListener,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: size.width * .9,
              child: MyTextField(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(CupertinoIcons.mail_solid),
                errorMsg: _errorMsg,
                validator: _emailValidator,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: size.width * .9,
              child: MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: const Icon(CupertinoIcons.lock_fill),
                errorMsg: _errorMsg,
                validator: _passwordValidator,
                suffixIcon: IconButton(
                  onPressed: makeObscure,
                  icon: Icon(iconPassword),
                ),
              ),
            ),
            const SizedBox(height: 20),
            signInRequired
                ? const CircularProgressIndicator()
                : SizedBox(
              width: size.width * .5,
              child: TextButton(
                onPressed: checkValidate,
                style: TextButton.styleFrom(
                  elevation: 5.0,
                  backgroundColor: Theme
                      .of(context)
                      .colorScheme
                      .primary,
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
                    'Sign In',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
