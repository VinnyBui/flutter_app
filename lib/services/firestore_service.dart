import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUserBucketLists(String userId){
    return _firestore.collection('bucketlists').where('createdBy', isEqualTo: userId).snapshots();
  }
}