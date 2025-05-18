import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  HomePage({super.key});

  // --- Sign Out ---
  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Bucket Lists',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
              onPressed: signUserOut,
              icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text('Logged in ${user?.email}'),
          ],
        ),
      ),
    );
  }
}
