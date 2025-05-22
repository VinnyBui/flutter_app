import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_app/components/my_btn.dart';
import 'package:flutter_app/components/my_textfield.dart';
import 'package:flutter_app/components/square_tile.dart';

import 'home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // --- Sign User Up Method ---
  void signUserUp() async {
    if (!_formKey.currentState!.validate()) return;

    // show loading circle
    showDialog(context: context, builder: (context){
      return const Center(
        child: CircularProgressIndicator(),
      );
    });

    // Sign up
    try{
      if (passwordController.text != confirmPasswordController.text) {
        Navigator.pop(context);
        showErrorMsg("Password does not match");
        return; // Exit function early
      }
      // If passwords match, try registration
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) Navigator.pop(context);
      showErrorMsg(e.code);
    }
  }

  void showErrorMsg(String message){
    showDialog(
      context: context,
      builder: (context) {
        return  AlertDialog(
          backgroundColor: Colors.red,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // --- Sign In w/ Google ---
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- Logo / Header ---
                const SizedBox(height: 50),
                const FaIcon(
                  FontAwesomeIcons.bucket, size: 120, color: Colors.black87
                ),
                const SizedBox(height: 50),
                Text(
                  'Welcome! let\'s create an account! ',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),

                // --- Email Field ---
                MyTextfield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter an Email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // --- Password Field ---
                MyTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter a Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // --- Confirm Password Field ---
                MyTextfield(
                  controller: confirmPasswordController,
                  hintText: 'Confirm password',
                  obscureText: true,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter the a Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),

                // --- Sign Up Btn ---
                MyBtn(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {  // This triggers validation
                      signUserUp();
                    }
                  },
                  text: 'Sign Up',
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
                SquareTile(
                  imagePath: 'lib/images/google.png',
                  onTap: signInWithGoogle,
                ),
                const SizedBox(height: 50),

                // --- Sign In to Account ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),),
                    const SizedBox(width: 5),
                    // use widget because your accessing a parent properties
                    TextButton(
                      child: Text(
                        'Sign In!',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}
