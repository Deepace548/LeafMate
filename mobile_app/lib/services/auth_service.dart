import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _usersKey = 'registered_users';
  static const String _currentUserKey = 'current_user';

  // ==================== REGISTER ====================
  /// Returns null on success, or an error message string on failure.
  Future<String?> register({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Load existing users
    final Map<String, String> users = _loadUsers(prefs);

    // Check if email already exists
    if (users.containsKey(email.toLowerCase())) {
      return 'This email is already registered. Please log in.';
    }

    // Save the new user (email → password)
    users[email.toLowerCase()] = password;
    await prefs.setString(_usersKey, jsonEncode(users));

    return null; // success
  }

  // ==================== LOGIN ====================
  /// Returns null on success, or an error message string on failure.
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, String> users = _loadUsers(prefs);

    final key = email.toLowerCase();

    if (!users.containsKey(key)) {
      return 'No account found for this email. Please register first.';
    }

    if (users[key] != password) {
      return 'Incorrect password. Please try again.';
    }

    // Mark as logged in
    await prefs.setString(_currentUserKey, key);

    return null; // success
  }

  // ==================== LOGOUT ====================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  // ==================== HELPERS ====================
  Map<String, String> _loadUsers(SharedPreferences prefs) {
    final raw = prefs.getString(_usersKey);
    if (raw == null) return {};
    final Map<String, dynamic> decoded = jsonDecode(raw);
    return decoded.map((k, v) => MapEntry(k, v.toString()));
  }
}