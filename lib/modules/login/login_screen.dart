import 'package:flutter/material.dart';
import 'package:udemy_flutter/shared/components/components.dart';

// reusable components

// 1 . timing
// 2 . refactor
// 3 . quality
// 4 . clean code

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  bool isPasswordShow = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  defaultFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty || value == null) {
                          return 'email must not be empty';
                        }
                      },
                      labelText: "Email Address",
                      prefixIcon: Icons.email),
                  const SizedBox(
                    height: 15.0,
                  ),
                  defaultFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value!.isEmpty || value == null) {
                          return 'password is too short';
                        }
                      },
                      labelText: 'Password',
                      prefixIcon: Icons.lock,
                      suffixIcon: isPasswordShow
                          ? Icons.visibility_off
                          : Icons.visibility,
                      isPassword: isPasswordShow,
                      suffixPressed: () {
                        setState(() {
                          isPasswordShow = !isPasswordShow;
                        });
                      }),
                  const SizedBox(
                    height: 20.0,
                  ),
                  defaultButton(
                    function: () {
                      if (formKey.currentState!.validate()) {
                        print(emailController.text);
                        print(passwordController.text);
                      }
                    },
                    text: 'login',
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  defaultButton(
                    function: () {
                      print(emailController.text);
                      print(passwordController.text);
                    },
                    text: 'register',
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Register Now',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
