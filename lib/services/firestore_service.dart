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

  Future<void> deleteBucketList(String bucketListId) async {
    await deleteAllItemsInBucketList(bucketListId);
    await _firestore.collection('bucketlists').doc(bucketListId).delete();
  }

  Future<void> deleteAllItemsInBucketList(String bucketListId) async {
    final querySnapshot = await _firestore
        .collection('bucketlist_items')
        .where('bucketListId', isEqualTo: bucketListId)
        .get();

    final batch = _firestore.batch();
    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<void> deleteBucketListItem(String itemId) async {
    await _firestore.collection('bucketlist_items').doc(itemId).delete();
  }
}