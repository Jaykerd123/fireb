import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String? uid;
  DatabaseService({this.uid});

  // collection reference

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future userUserData (String sugar, String name, int strength) async {
    return await usersCollection.doc(uid).set({
      'sugar': sugar,
      'name': name,
      'strength': strength,
    });

  }

  //   get user doc stream
  Stream<QuerySnapshot> get users {
    return usersCollection.snapshots();
  }

}