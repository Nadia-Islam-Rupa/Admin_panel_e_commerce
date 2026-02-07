import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// STATE
class AuthState {
  final bool isLoading;
  final String? error;

  AuthState({this.isLoading = false, this.error});

  AuthState copyWith({bool? isLoading, String? error}) {
    return AuthState(isLoading: isLoading ?? this.isLoading, error: error);
  }
}

/// PROVIDER
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(),
);

/// CONTROLLER
class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState());

  final _supabase = Supabase.instance.client;

  /// SIGN UP
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
