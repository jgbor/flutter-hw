import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/ui/bloc/login/login_bloc.dart';
import 'package:validators/validators.dart';

class LoginPageBloc extends StatefulWidget {
  const LoginPageBloc({super.key});

  @override
  State<LoginPageBloc> createState() => _LoginPageBlocState();
}

class _LoginPageBlocState extends State<LoginPageBloc> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var _rememberMe = false;
  static const int _minPasswordLength = 6;

  @override
  void initState() {
    context.read<LoginBloc>().add(LoginAutoLoginEvent());
    super.initState();
  }

  String? _validateEmail(String? email) {
    if (isEmail(email!)) {
      return null;
    }
    return "Invalid email";
  }

  String? _validatePassword(String? password) {
    if (isLength(password!, _minPasswordLength)) {
      return null;
    }
    return "Password must be at least $_minPasswordLength characters";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<LoginBloc, LoginState>(
            listenWhen: (_, state) =>
                state is LoginError || state is LoginSuccess,
            listener: (context, state) {
              if (state is LoginError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              } else {
                Navigator.pushReplacementNamed(context, '/list');
              }
            },
            buildWhen: (_, state) =>
                state is! LoginError || state is! LoginSuccess,
            builder: (context, state) {
              return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        validator: _validateEmail,
                        enabled: state is! LoginLoading,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      TextFormField(
                          controller: _passwordController,
                          validator: _validatePassword,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          enabled: state is! LoginLoading,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          )),
                      Row(children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (state is! LoginLoading)
                              ? (bool? value) {
                                  setState(() {
                                    _rememberMe = value!;
                                  });
                                }
                              : null,
                        ),
                        const Text('Remember me')
                      ]),
                      ElevatedButton(
                        onPressed: state is! LoginLoading
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<LoginBloc>().add(
                                        LoginSubmitEvent(
                                          _emailController.text,
                                          _passwordController.text,
                                          _rememberMe,
                                        ),
                                      );
                                }
                              }
                            : null,
                        child: const Text('Login'),
                      ),
                    ],
                  ));
            },
          ),
        ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
