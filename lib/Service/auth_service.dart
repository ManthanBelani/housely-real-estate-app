import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/user.birthday.read'
        ]
      ).signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      User? user = userCredential.user;

      if (user == null) return null;

      DocumentReference userDocRef = _firestore
          .collection('users')
          .doc(user.uid);

      DocumentSnapshot userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        // Create a new user document in Firestore
        await userDocRef.set({
          'name': user.displayName ?? googleUser.displayName,
          'email': user.email ?? googleUser.email,
          'photoURL': user.photoURL ?? googleUser.photoUrl?.toString(),
          'DOB': '',  // Initialize DOB as empty string
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        print('New user document created for ${user.displayName ?? googleUser.displayName}');
      } else {
        await userDocRef.update({'updatedAt': FieldValue.serverTimestamp()});
        print('Returning user: ${user.displayName ?? googleUser.displayName}');
      }

      return user;
    } catch (e) {
      print('Google Sign-In Error: $e');
      rethrow;
    }
  }

  Future<User?> signInWithFacebook() async {
    print('Facebook sign-in not yet implemented');
    return null;
  }

  Future<User?> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user == null) return null;
      await user.updateDisplayName(name);
      await createOrUpdateUserDoc(user, nameOverrides: name);
      await user.reload();
      user = _auth.currentUser;
      return user;
    } catch (e) {
      print('Email Sign-Up Error: $e');
      rethrow;
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user == null) return null;
      await user.reload();
      user = _auth.currentUser;
      await createOrUpdateUserDoc(user);
      print('Returning user: ${user?.displayName ?? user?.email}');
      return user;
    } catch (e) {
      print('Email Sign-In Error: $e');
      rethrow;
    }
  }

  Future sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Show a success message to the user, e.g., a SnackBar or AlertDialog
      print('Password reset email sent to $email');
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'invalid-email') {
        print('The email address is not valid.');
      } else {
        print('Error sending password reset email: ${e.message}');
      }
      // Show an error message to the user
    } catch (e) {
      print('An unexpected error occurred: $e');
      // Show a generic error message
    }
  }
  Future<User?> createOrUpdateUserDoc(user, {String? nameOverrides}) async {
    try {
      DocumentReference userDocRef = _firestore
          .collection('users')
          .doc(user.uid);
      DocumentSnapshot userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        await userDocRef.set({
          'name': user.displayName ?? nameOverrides,
          'email': user.email,
          'DOB': '',  // Initialize DOB as empty string
          'photoURL': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        print(
          'New user document created for ${user.displayName ?? user.email}',
        );
      }
    } catch (e) {
      print('User Document Error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
      print('User signed out');
    } catch (e) {
      print('Sign-Out Error: $e');
      rethrow;
    }
  }
}
