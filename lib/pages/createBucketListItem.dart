import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/my_btn.dart';
import '../components/my_textfield.dart';

class CreateBucketListItem extends StatefulWidget {
  final String bucketListId;
  const CreateBucketListItem({
    super.key,
    required this.bucketListId
  });

  @override
  State<CreateBucketListItem> createState() => _CreateBucketListItemState();
}

class _CreateBucketListItemState extends State<CreateBucketListItem> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  // -- Create Bucket List Item Method --
  Future<void> createBucketListItem() async {
    try{
      await FirebaseFirestore.instance.collection('bucketlist_items').add({
        'title': titleController.text,
        'createdBy': user?.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'completed': false,
        'bucketListId': widget.bucketListId,
      });
      titleController.clear();
      // return to home screen
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Bucket List Item'),
      ),
      body: Center(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                // --- Bucket List Title ---
                const SizedBox(height: 50),
                MyTextfield(
                    controller: titleController,
                    hintText: 'Bucket List item',
                    obscureText: false,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter a title';
                      }
                      return null;
                    }
                ),

                // --- Submit Button ---
                const SizedBox(height: 25),
                MyBtn(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {  // This triggers validation
                      createBucketListItem();
                    }
                  },
                  text: 'Add Bucket List Item',
                ),
              ],
            )
        ),
      ),
    );
  }
}
