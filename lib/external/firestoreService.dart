import 'package:Bit.Me/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDB{

  /*FirestoreDB(String userId,Function(UserData userData) onLoad){
    _getDocumentData(userId);
  }*/
  static Future<UserData> getUserData(String uid) async {
    DocumentSnapshot documentSnapshot = await Firestore.instance
        .collection("users")
        .document(uid)
        .get();
    //print("uid:${uid}");
    //print("document${documentSnapshot.data}");
    if (documentSnapshot.exists) {
      //print("exist");
      return UserData.fromJson(documentSnapshot.data);
    } else {
      return null;
    }
  }


}