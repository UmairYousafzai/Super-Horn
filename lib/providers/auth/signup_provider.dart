import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/states/signup_state.dart';
import '../../domain/usecases/auth/signup_usecase.dart';
import 'auth_usecase_provider.dart';

class SignUpNotifier extends StateNotifier<SignUpState> {
  final SignUpUseCase _signUpUseCase;

  SignUpNotifier(this._signUpUseCase) : super(SignUpState());

  Future<void> signUp() async {
    try {
      state = state.copyWith(isLoading: true, error: '');

      await _signUpUseCase.execute(
        state.email,
        state.password,
      );

      state = state.copyWith(
        isLoading: false,
        isSignedUp: true,
        error: '',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isSignedUp: false,
      );
    }
  }

  // Method to update and validate the First Name
  void updateName(String value) {
    value = value.trim();
    if (value.isEmpty) {
      state = state.copyWith(name: "", nameError: 'Name cannot be empty');
    } else if (value.length < 2 || value.length > 50) {
      state = state.copyWith(
          name: value,
          nameError: 'First Name must be between 2 and 50 characters long');
    } else if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(value)) {
      state = state.copyWith(
          name: value,
          nameError:
              'First Name can only contain letters, spaces, apostrophes, and hyphens');
    } else {
      state = state.copyWith(name: value, nameError: "");
    }
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

  // Method to update and validate the Country
  void updateCountry(String value) {
    value = value.trim();
    if (value.isEmpty) {
      state = state.copyWith(countryError: 'Country cannot be empty');
    } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
      state = state.copyWith(
          countryError: 'Country can only contain letters and spaces');
    } else {
      state = state.copyWith(country: value, countryError: "");
    }
  }

  // Method to update and validate the City
  void updateCity(String value) {
    value = value.trim();
    if (value.isEmpty) {
      state = state.copyWith(cityError: 'City cannot be empty');
    } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
      state =
          state.copyWith(cityError: 'City can only contain letters and spaces');
    } else {
      state = state.copyWith(city: value, cityError: "");
    }
  }

  // Reset the state to initial values
  void resetState() {
    state = SignUpState();
  }
}

// Provider to manage the SignUpNotifier
final signUpProvider =
    StateNotifierProvider<SignUpNotifier, SignUpState>((ref) {
  final signoutUseCase = ref.watch(signUpUseCaseProvider);
  return SignUpNotifier(signoutUseCase);
});
