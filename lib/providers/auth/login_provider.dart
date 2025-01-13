import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/states/login_state.dart';
import '../../domain/usecases/auth/get_auth_status_usecase.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import 'auth_usecase_provider.dart'; // Assuming you have a LoginState similar to SignUpState

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetAuthStatusUseCase _getAuthStatusUseCase;

  LoginNotifier(
      this._loginUseCase, this._logoutUseCase, this._getAuthStatusUseCase)
      : super(LoginState());

  Future<void> login() async {
    // resetState();
    try {
      state = state.copyWith(isLoading: true, error: '', isSignedIn: false);

      await _loginUseCase.execute(
        state.email,
        state.password,
      );

      state = state.copyWith(
        isLoading: false,
        isSignedIn: true,
        error: '',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isSignedIn: false,
      );
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _logoutUseCase.execute();

      state = LoginState(); // Reset to initial state
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  bool isUserLoggedIn() {
    return _getAuthStatusUseCase.execute();
  }

  void updateEmail(
    String value,
  ) {
    value = value.trim();
    if (value.isEmpty) {
      state = state.copyWith(
          email: value, emailError: "Email field can't be empty");
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      state = state.copyWith(
          email: value, emailError: "Please enter a valid email");
    } else {
      state =
          state.copyWith(email: value, emailError: ""); // Clear error if valid
    }
  }

  // Method to update and validate the Password
  void updatePassword(String value) {
    value = value.trim();
    if (value.isEmpty) {
      state = state.copyWith(passwordError: 'Password cannot be empty');
    } else if (value.length < 6) {
      state = state.copyWith(
          passwordError: 'Password must be at least 6 characters long');
    } else {
      state = state.copyWith(password: value, passwordError: "");
    }
  }

  // Reset the state to initial values
  void resetState() {
    state = LoginState();
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final logoutUseCase = ref.watch(logoutUseCaseProvider);
  final getAuthStatusUseCase = ref.watch(getAuthStatusUseCaseProvider);
  return LoginNotifier(loginUseCase, logoutUseCase, getAuthStatusUseCase);
});
