import 'package:firebase_core/firebase_core.dart';
import 'package:fat_app/firebase_options.dart';
import 'package:fat_app/auth/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, FirebaseException;
import 'package:fat_app/auth/auth_exceptions.dart';
import 'package:fat_app/auth/auth_user.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> LogOut() async {
    // TODO: implement LogOut
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLogInAuthException();
    }
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    // TODO: implement createUser
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLogInAuthException();
      }
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    }
    throw UnimplementedError();
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLogInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> sendEmailVertification() async {
    // TODO: implement sendEmailVertification
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> initialize() async {
    // TODO: implement initialize
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'firebase_auth/invalid-email':
          throw InvalidEmailAuthException();
        case 'firebase_auth/user-not-found':
          throw UserNotFoundAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
}
