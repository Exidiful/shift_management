import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/employee.dart';
import '../utils/error_handler.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _checkAndCreateEmployeeDocument();
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw ErrorHandler.handleAuthError(e);
    }
  }

  Future<void> createUserWithEmailAndPassword(String email, String password, String name, String position) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _createEmployeeDocument(userCredential.user!.uid, email, name, position);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw ErrorHandler.handleAuthError(e);
    }
  }

  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          await _checkAndCreateEmployeeDocument();
          notifyListeners();
        },
        verificationFailed: (FirebaseAuthException e) {
          throw ErrorHandler.handleAuthError(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          // TODO: Implement code sent handling
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // TODO: Implement timeout handling
        },
      );
    } catch (e) {
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  Future<void> _checkAndCreateEmployeeDocument() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final docSnapshot = await _firestore.collection('employees').doc(user.uid).get();
      if (!docSnapshot.exists) {
        await _createEmployeeDocument(user.uid, user.email ?? '', 'New Employee', 'Unassigned');
      }
    }
  }

  Future<void> _createEmployeeDocument(String uid, String email, String name, String position) async {
    final employee = Employee(
      id: uid,
      name: name,
      position: position,
      email: email,
      phoneNumber: _auth.currentUser?.phoneNumber ?? '',
    );
    await _firestore.collection('employees').doc(uid).set(employee.toJson());
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}