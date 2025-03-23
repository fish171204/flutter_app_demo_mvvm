class Validation {
  static String? validatePass(String? pass) {
    if (pass == null || pass.isEmpty) {
      return "Password invalid";
    }

    if (pass.length < 6) {
      return "Password requires a minimum of 6 characters";
    }

    return null; // Nếu không có lỗi -> null
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Email invalid";
    }

    var isValid = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email);

    if (!isValid) {
      return "Email invalid";
    }

    return null; // Nếu không có lỗi -> null
  }
}
