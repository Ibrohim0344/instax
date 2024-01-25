part of '../sign_in_screen.dart';

mixin SignInMixin on State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  String? _errorMsg;
  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool signInRequired = false;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  String? _emailValidator(String? value) {
    if (value!.isEmpty) {
      return "Please fill in this field";
    } else if (!emailRegExp.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please fill in this field';
    } else if (!passwordRegExp.hasMatch(value)) {
      return 'Please enter a valid password';
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

  void checkValidate() {
    if (_formKey.currentState!.validate()) {
      context.read<SignInBloc>().add(SignInRequired(
        email: emailController.text,
        password: passwordController.text,
      ));
    }
  }

  void signInListener(BuildContext context, SignInState state) {
    if(state is SignInSuccess) {
      setState(() {
        signInRequired = false;
      });
    } else if(state is SignInProcess) {
      setState(() {
        signInRequired = true;
      });
    } else if(state is SignInFailure) {
      setState(() {
        signInRequired = false;
        _errorMsg = 'Invalid email or password';
      });
    }
  }
}