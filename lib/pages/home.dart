import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/createBucketList.dart';
import 'package:flutter_app/services/firestore_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth.dart';
import 'bucketListDetails.dart';

class HomePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  final FirestoreService _firestoreService = FirestoreService();

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

      // --- Display Bucket Lists ---
      // Listen to stream and rebuild UI when data changes
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getUserBucketLists(user.uid),
        builder: (context, snapshot) {
          // Create scrollable list that only renders visible items
          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              // Turns document from Objects to key, value pairs (temp)
              final data = doc.data() as Map<String, dynamic>;
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                // Handles card being clicked
                child: InkWell(
                  onDoubleTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BucketListDetails(bucketListId: doc.id)));
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black87,
                    ),
                    child: Center(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: FaIcon(FontAwesomeIcons.bucket, size: 24, color: Colors.white70),
                        title: Text(
                          data['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

      // --- Add Bucket List Btn ---
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateBucketList()),
          );
        },
        backgroundColor: Colors.black87,
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
