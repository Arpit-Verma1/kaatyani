import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> _signUp() async {
    if (formKey.currentState!.validate()) {
      try {
        final user = await AuthService().signUp(_emailController.text.trim(),
            _passwordController.text.trim(), _nameController.text.trim());
        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created successfully!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sign Up.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Name'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Name field cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          !value.trim().contains('@')) {
                        return "Email field cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(hintText: 'Password'),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.trim().length <= 6) {
                        return "Password field cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signUp,
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: const [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
        //
        // Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: Column(
        //     children: [
        //       TextField(
        //         controller: _nameController,
        //         decoration: const InputDecoration(labelText: 'Name'),
        //         obscureText: false,
        //       ),
        //       TextField(
        //         controller: _emailController,
        //         decoration: const InputDecoration(labelText: 'Email'),
        //       ),
        //       TextField(
        //         controller: _passwordController,
        //         decoration: const InputDecoration(labelText: 'Password'),
        //         obscureText: true,
        //       ),
        //       const SizedBox(height: 20),
        //       ElevatedButton(
        //         onPressed: _signUp,
        //         child: const Text('Sign Up'),
        //       ),
        //       const SizedBox(height: 20),
        //       RichText(
        //         text: TextSpan(
        //           text: 'Already have an account? ',
        //           style: const TextStyle(color: Colors.black),
        //           children: [
        //             TextSpan(
        //               text: 'Login',
        //               style: const TextStyle(color: Colors.blue),
        //               recognizer: TapGestureRecognizer()
        //                 ..onTap = () {
        //                   Navigator.pushReplacement(
        //                     context,
        //                     MaterialPageRoute(builder: (context) => LoginScreen()),
        //                   );
        //                 },
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        );
  }
}
