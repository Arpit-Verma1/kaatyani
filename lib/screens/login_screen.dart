import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/shared_pref_service.dart';
import 'dashboard_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (formKey.currentState!.validate()) {
      try {
        final userId = await AuthService().login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (userId != null) {
          await SharedPrefService.saveUser(userId);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
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
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "LogIn",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    !value.trim().contains('@'))
                  return "Email field cannot be empty";
                return null;
              },
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    value.trim().length <= 6)
                  return "Password  field cannot be empty";
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text(
                'Login',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: RichText(
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                        text: 'Sign In',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    )

        // Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: Column(
        //     children: [
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
        //         onPressed: _login,
        //         child: const Text('Login'),
        //       ),
        //       const SizedBox(height: 20),
        //       RichText(
        //         text: TextSpan(
        //           text: 'Don’t have an account? ',
        //           style: const TextStyle(color: Colors.black),
        //           children: [
        //             TextSpan(
        //               text: 'Sign Up',
        //               style: const TextStyle(color: Colors.blue),
        //               recognizer: TapGestureRecognizer()
        //                 ..onTap = () {
        //                   Navigator.pushReplacement(
        //                     context,
        //                     MaterialPageRoute(builder: (context) => SignUpScreen()),
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
