import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

}