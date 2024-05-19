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
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  bool _validateEmail(String email) {
    return isEmail(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<LoginBloc, LoginState>(
            listenWhen: (_, state) => state is LoginError,
            listener: (context, state) {
              if (state is LoginError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            buildWhen: (_, state) => state is! LoginError,
            builder: (context, state) {
              if (state is LoginLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LoginSuccess) {
                return const Center(child: Text('Success'));
              } else if (state is LoginForm) {
                return Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),
                    Row(children: [
                      Checkbox(
                        value: state.rememberMe,
                        onChanged: (bool? value) {
                          setState(() {
                            context
                                .read<LoginBloc>()
                                .add(ChangeRememberMeEvent(value ?? false));
                          });
                        },
                      ),
                      const Text('Remember me')
                    ]),
                    ElevatedButton(
                      onPressed: () {
                        context.read<LoginBloc>().add(
                              LoginSubmitEvent(
                                _emailController.text,
                                _passwordController.text,
                                state.rememberMe,
                              ),
                            );
                      },
                      child: const Text('Login'),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        )
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
