import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireb/models/brew.dart';

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

  // brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      print(doc.data());
      return Brew(
        name: doc.get('name') ?? '',
        strength: doc.get('strength') ?? 0,
        sugars: doc.get('sugar') ?? '0',
      );
    }).toList();
  }
  //   get user doc stream
  Stream<List<Brew>> get users {
    return usersCollection.snapshots().map(_brewListFromSnapshot);
  }

}
