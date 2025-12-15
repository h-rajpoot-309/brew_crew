import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brew_crew/models/user.dart';


class AuthService {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create a user object for fireabase user
  UserId? _userfromFirebaseUser(User? user){
    return user !=null ? UserId(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<UserId?> get user {
    return _auth.authStateChanges().map(_userfromFirebaseUser);
    //.map((User? user) => _userfromFirebaseUser(user!))   ------ this logic applies to the above map function
  }

  //sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userfromFirebaseUser(user!);
    } catch (e){
      print(e.toString());
      return null;
    } 
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userfromFirebaseUser(user);
    } catch (e){
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      //create a new documnet for newly registered user in database
      await DatabaseService(uid: user!.uid).updateUserData('0','new member', 100);

      return _userfromFirebaseUser(user);
    } catch (e){
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}