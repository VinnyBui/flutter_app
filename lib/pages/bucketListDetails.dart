import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/createBucketListItem.dart';
import '../services/firestore_service.dart';

class BucketListDetails extends StatefulWidget {
  final String bucketListId;
  const BucketListDetails({
    super.key,
    required this.bucketListId
  });

  @override
  State<BucketListDetails> createState() => _BucketListDetailsState();
}

class _BucketListDetailsState extends State<BucketListDetails> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestoreService.getBucketList(widget.bucketListId),
          builder: (context, snapshot) {
            final data = snapshot.data?.data() as Map<String, dynamic>?;
            return Text(
              data?['title'],
            );
          }
        ),
      ),

      // --- Display Bucket Lists ---
      // Listen to stream and rebuild UI when data changes
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getBucketListItems(widget.bucketListId),
        builder: (context, snapshot) {
          // Handle empty state FIRST
          if (snapshot.data?.docs.isEmpty ?? true) {
            return Center(child: Text("No items yet"));
          }

          // Then handle loading/error states
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Create scrollable list that only renders visible items
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              // Turns document from Objects to key, value pairs (temp)
              final data = doc.data() as Map<String, dynamic>;
              return Dismissible(
                key: Key(doc.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  await _firestoreService.deleteBucketListItem(doc.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${data['title']} deleted"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                background: Container(color: Colors.red),
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  // Handles card being clicked
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black87,
                    ),
                    child: Center(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
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

      // --- Add Bucket List Item Btn ---
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateBucketListItem(
              bucketListId: widget.bucketListId,
            )),
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
