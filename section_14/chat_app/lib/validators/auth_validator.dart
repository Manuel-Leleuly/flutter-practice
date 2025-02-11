final class AuthValidator {
  const AuthValidator();

  String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty || !email.contains('@')) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  String? validateUsername(String? username) {
    if (username == null || username.isEmpty || username.trim().length < 4) {
      return 'Please enter at least 4 characters';
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.trim().length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    return null;
  }
}
