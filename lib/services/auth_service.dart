import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService(this._auth);
  final FirebaseAuth _auth;

  Stream<User?> get authChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> register(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<void> resetPassword(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  Future<void> signOut() => _auth.signOut();
}