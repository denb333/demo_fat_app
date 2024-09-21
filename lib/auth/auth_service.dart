import 'package:fat_app/auth/auth_provider.dart';
import 'package:fat_app/auth/auth_user.dart';
import 'package:fat_app/auth/firebase_auth_provider.dart';

class AuthServices implements AuthProvider {
  final AuthProvider provider;
  const AuthServices(this.provider);

  @override
  Future<void> LogOut() => provider.LogOut();
  // TODO: implement LogOut
  factory AuthServices.firebase() => AuthServices(FirebaseAuthProvider());
  @override
  Future<AuthUser> createUser(
          {required String email, required String password}) =>
      provider.createUser(email: email, password: password);
  // TODO: implement createUser

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> sendEmailVertification() => provider.sendEmailVertification();

  @override
  Future<void> initialize() => provider.initialize();
  @override
  Future<void> sendPasswordReset({required String toEmail}) =>
      provider.sendPasswordReset(toEmail: toEmail);
}
