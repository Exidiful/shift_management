import 'package:firebase_auth/firebase_auth.dart';

class ErrorHandler {
  static String handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      // Add more cases as needed
      default:
        return 'An error occurred: ${e.message}';
    }
  }

  static String handleFirestoreError(dynamic e) {
    // Add specific Firestore error handling if needed
    return 'A database error occurred: $e';
  }

  static String handleGeneralError(dynamic e) {
    return 'An unexpected error occurred: $e';
  }
}