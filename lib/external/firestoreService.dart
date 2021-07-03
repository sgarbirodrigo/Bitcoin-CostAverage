import 'package:Bit.Me/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDB{
  FirestoreDB(String userId,Function(UserData userData) onLoad){

  }
  static Future<UserData> getUserData(String uid) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();
    if (documentSnapshot.exists) {
      //print("exist");
      return UserData.fromJson(documentSnapshot.data());
    } else {
      return null;
    }
  }
}