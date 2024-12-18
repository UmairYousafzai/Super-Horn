class LoginState {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;

  LoginState({
    this.email = '',
    this.password = '',
    this.emailError = '',
    this.passwordError = '',
  });

  LoginState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
    );
  }
}
