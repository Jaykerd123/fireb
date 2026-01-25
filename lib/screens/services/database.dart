import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireb/models/brew.dart';

import '../../models/user.dart';

class DatabaseService{

  final String? uid;
  DatabaseService({this.uid});

  // collection reference

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData (String sugar, String name, int strength) async {
    return await usersCollection.doc(uid).set({
      'sugar': sugar,
      'name': name,
      'strength': strength,
    });

  }

  Future updateOnboardingData(String avatarUrl, String name, bool isDarkMode) async {
    return await usersCollection.doc(uid).set({
      'avatarUrl': avatarUrl,
      'name': name,
      'isDarkMode': isDarkMode,
      'onboardingCompleted': true,
    });
  }

  // brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      return Brew(
        name: data?['name'] ?? '',
        sugars: data?['sugar'] ?? '0',
        strength: data?['strength'] ?? 0,
      );
    }).toList();
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;
    return UserData(
      uid: uid!,
      name: data?['name'] ?? 'new crew member',
      sugar: data?['sugar'] ?? '0',
      strength: data?['strength'] ?? 100,
      avatarUrl: data?['avatarUrl'] ?? '',
      isDarkMode: data?['isDarkMode'] ?? false,
      onboardingCompleted: data?['onboardingCompleted'] ?? false,
    );
  }


  //   get brew stream
  Stream<List<Brew>> get users {
    return usersCollection.snapshots().map(_brewListFromSnapshot);
  }

//   get user doc stream
  Stream<UserData> get userData {
    return usersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

}
