import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireCollection{

  String userId = FirebaseAuth.instance.currentUser.uid;

  DocumentReference userDoc(){
    return FirebaseFirestore.instance.collection("users").doc(userId);
  }
  static DocumentReference timelineCollectionDoc(){
    return FirebaseFirestore.instance.collection("timeline").doc();
  }
  static CollectionReference timelineCollection(){
    return FirebaseFirestore.instance.collection("timeline");
  }
  static CollectionReference userCollection(){
    return FirebaseFirestore.instance.collection("users");
  }

}