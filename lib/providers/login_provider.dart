import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/states/login_state.dart'; // Assuming you have a LoginState similar to SignUpState

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(LoginState());

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

// Provider to manage the LoginNotifier
final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier();
});
