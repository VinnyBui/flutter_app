import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/my_btn.dart';
import '../components/my_textfield.dart';

class CreateBucketList extends StatefulWidget {
  const CreateBucketList({super.key});

  @override
  State<CreateBucketList> createState() => _CreateBucketListState();
}

class _CreateBucketListState extends State<CreateBucketList> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  // -- Create Bucket List Method --
  Future<void> createBucketList() async {
    try{
      await FirebaseFirestore.instance.collection('bucketlists').add({
        'title': titleController.text,
        'createdBy': user?.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'isShared': false,
        'members': [user?.uid],
      });
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
        title: const Text('Create New Bucket List'),
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
                hintText: 'Name Your Bucket List',
                obscureText: false,
              ),

              // --- Submit Button ---
              const SizedBox(height: 25),
              MyBtn(
                onTap: createBucketList,
                text: 'Create Bucket List',
              ),
            ],
          )
        ),
      ),
    );
  }
}
