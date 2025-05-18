import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/my_btn.dart';
import 'package:flutter_app/components/my_textfield.dart';
import 'package:flutter_app/components/square_tile.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    // show loading circle
    showDialog(context: context, builder: (context){
      return const Center(
        child: CircularProgressIndicator(),
        );
      },
    );

    // sign in
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      debugPrint('FULL AUTH ERROR: ${e.code} - ${e.message}');
      if (e.code == 'invalid-credential') {
        wrongCredentialMessage();
      }else if (e.code == 'invalid-email') {
        wrongEmailMessage();
      }
    }
  }

  void wrongCredentialMessage(){
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Wrong email/password"),
        );
      },
    );
  }

  void wrongEmailMessage(){
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Please enter an email"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- Logo / Header ---
              const SizedBox(height: 50),
              const Icon(
                Icons.lock,
                size: 100,
              ),
              const SizedBox(height: 50),
              Text(
                'Welcome back',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Sign in to continue',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 25),

              // --- Email Field ---
              MyTextfield(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 10),

              // --- Password Field ---
              MyTextfield(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Text('Forgot Password?'),
              const SizedBox(height: 25),

              // --- Sign in Btn ---
              MyBtn(
                onTap: signUserIn,
              ),
              const SizedBox(height: 50),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // --- Alternative Sign In ---
              SquareTile(imagePath: 'lib/images/google.png'),
              const SizedBox(height: 50),

              // --- Register Account ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
              ),),
                  const SizedBox(width: 5),
                  Text(
                    'Register now!',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
