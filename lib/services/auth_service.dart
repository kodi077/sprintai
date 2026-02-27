import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  Future<void> sendOtp(String email) async {
    await Supabase.instance.client.auth.signInWithOtp(email: email);
  }

  Future<void> verifyOtp(String email, String token) async {
    await Supabase.instance.client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.email,
    );
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }

  User? get currentUser => Supabase.instance.client.auth.currentUser;

  Stream<AuthState> get authStateStream =>
      Supabase.instance.client.auth.onAuthStateChange;
}
