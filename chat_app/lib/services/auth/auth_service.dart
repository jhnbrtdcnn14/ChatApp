import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // sign in

  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      // create user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // save user info if it doesnt exist
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // sign up
  Future<UserCredential> signUpWithEmailPassword(
    String email,
    String password,
    String firstname,
    String middleName,
    String lastname,
    String phoneNumber,
  ) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create user info
      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'firstname': firstname,
        'middlename': middleName,
        'lastname': lastname,
        'phoneNumber': phoneNumber,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // sign out

  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // get user data
  Future<Map<String, dynamic>> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      return doc.data() as Map<String, dynamic>;
    } else {
      throw Exception("User not logged in");
    }
  }

  //  update user data
  Future<void> updateUserData(Map<String, dynamic> userData) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('Users').doc(user.uid).update(userData);
    } else {
      throw Exception("User not logged in");
    }
  }
}
