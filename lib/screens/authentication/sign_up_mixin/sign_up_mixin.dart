part of '../sign_up_screen.dart';

mixin SignUpMixin on State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_fill;
  final nameController = TextEditingController();
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  void signUpListener(BuildContext context, SignUpState state) {
    if (state is SignUpSuccess) {
      setState(() => signUpRequired = false);
    } else if (state is SignUpProcess) {
      setState(() => signUpRequired = true);
    } else if (state is SignUpFailure) {
      return;
    }
  }

  String? _emailValidator(String? value) {
    if (value!.isEmpty) {
      return "Please fill in this field";
    } else if (!emailRegExp.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? _onChanged(String? value) {
    if (value!.contains(RegExp(r'[A-Z]'))) {
      setState(() => containsUpperCase = true);
    } else {
      setState(() => containsUpperCase = false);
    }

    if (value.contains(RegExp(r'[a-z]'))) {
      setState(() => containsLowerCase = true);
    } else {
      setState(() => containsLowerCase = false);
    }

    if (value.contains(RegExp(r'[0-9]'))) {
      setState(() => containsNumber = true);
    } else {
      setState(() => containsNumber = false);
    }

    if (value.contains(specialCharRegExp)) {
      setState(() => containsSpecialChar = true);
    } else {
      setState(() => containsSpecialChar = false);
    }

    if (value.length >= 8) {
      setState(() => contains8Length = true);
    } else {
      setState(() => contains8Length = false);
    }

    return null;
  }

  void makeObscure() => setState(() {
        obscurePassword = !obscurePassword;
        if (obscurePassword) {
          iconPassword = CupertinoIcons.eye_fill;
        } else {
          iconPassword = CupertinoIcons.eye_slash_fill;
        }
      });

  String? _passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please fill in this field';
    } else if (!passwordRegExp.hasMatch(value)) {
      return 'Please enter a valid password';
    }
    return null;
  }

  String? _nameValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please fill in this field';
    } else if (value.length > 30) {
      return 'Name too long';
    }
    return null;
  }

  void checkValidate() {
    if (_formKey.currentState!.validate()) {
      MyUser myUser = MyUser.empty;
      myUser = myUser.copyWith(
        email: emailController.text,
        name: nameController.text,
      );

      setState(() {
        context.read<SignUpBloc>().add(SignUpRequired(
              myUser,
              passwordController.text,
            ));
      });
    }
  }

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }
}
