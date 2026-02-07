import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthhState {
  final bool isLoading;
  final String? error;

  AuthhState({this.isLoading = false, this.error});

  AuthhState copyWith({bool? isLoading, String? error}) {
    return AuthhState(isLoading: isLoading ?? this.isLoading, error: error);
  }
}

final authhControllerProvider =
    StateNotifierProvider<AuthController, AuthhState>(
      (ref) => AuthController(),
    );

class AuthController extends StateNotifier<AuthhState> {
  AuthController() : super(AuthhState());

  final _supabase = Supabase.instance.client;

  /// EMAIL + PASSWORD LOGIN
  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _supabase.auth.signInWithPassword(email: email, password: password);

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// GOOGLE LOGIN
  Future<void> loginWithGoogle() async {
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.flutter://login-callback',
    );
  }

  /// SIGN UP (optional)
  Future<void> signup(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _supabase.auth.signUp(email: email, password: password);

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
