import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUserBucketLists(String userId){
    return _firestore.collection('bucketlists').where('createdBy', isEqualTo: userId).snapshots();
  }

  Stream<DocumentSnapshot> getBucketList(String bucketListId){
    return _firestore.collection('bucketlists').doc(bucketListId).snapshots();
  }

  Stream<QuerySnapshot> getBucketListItems(String bucketListId){
    return _firestore.collection('bucketlist_items').where('bucketListId', isEqualTo: bucketListId).snapshots();
  }
}