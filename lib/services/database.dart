import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference colRef = FirebaseFirestore.instance.collection(
    'brews',
  );

  Future updateUserData(String sugar, String name, int strength) async {
    print('In update user data');
    return await colRef.doc(uid).set({
      'sugars': sugar,
      'name': name,
      'strength': strength,
    });
  }

  // brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final _data = doc.data() as Map<String, dynamic>;
      return Brew(
        name: _data['name'] ?? '',
        sugars: _data['sugars'] ?? '0',
        strength: _data['strength'] ?? 0,
      );
    }).toList();
  }

  //get brews stream
  Stream<List<Brew>> get brews {
    return colRef.snapshots().map(_brewListFromSnapshot);
  }

  // user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    final _data = snapshot.data() as Map<String, dynamic>;
    print(snapshot.data());
    return UserData(
      uid: uid!,
      name: _data['name'] ?? '',
      sugars: _data['sugars'] ?? '0',
      strength: _data['strength'] ?? 100,
    );
  }

  //get user doc
  Stream<UserData> get userData {
    return colRef.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
