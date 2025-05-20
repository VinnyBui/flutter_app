import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/createBucketList.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth.dart';

class HomePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  HomePage({super.key});

  // --- Sign Out ---
  void signUserOut(context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthPage()),
        (route) => false, // Removes all previous routes
    );
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
              onPressed: () => signUserOut(context),
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateBucketList()),
          );
        },
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
