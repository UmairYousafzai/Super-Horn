class SignUpState {
  final String name;
  final String email;
  final String password; // New field for password
  final String country; // New field for country
  final String city; // New field for city
  final String? nameError;
  final String? emailError;
  final String? passwordError; // Optional field for password error
  final String? countryError; // Optional field for country error
  final String? cityError; // Optional field for city error

  SignUpState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.country = '',
    this.city = '',
    this.nameError = '',
    this.emailError = '',
    this.passwordError = '',
    this.countryError = '',
    this.cityError = '',
  });

  SignUpState copyWith({
    String? name,
    String? email,
    String? password,
    String? country,
    String? city,
    String? nameError,
    String? emailError,
    String? passwordError,
    String? countryError,
    String? cityError,
  }) {
    return SignUpState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      country: country ?? this.country,
      city: city ?? this.city,
      nameError: nameError ?? this.nameError,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      countryError: countryError ?? this.countryError,
      cityError: cityError ?? this.cityError,
    );
  }
}
