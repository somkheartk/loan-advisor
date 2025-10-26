import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'currentUser';
  static const String _isLoggedInKey = 'isLoggedIn';

  Future<bool> saveUser(String email, String password, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList(_usersKey) ?? [];
    
    // Check if user already exists
    for (var user in users) {
      if (user.split('|')[0] == email) {
        return false;
      }
    }
    
    // Add new user (format: email|password|name)
    users.add('$email|$password|$name');
    await prefs.setStringList(_usersKey, users);
    return true;
  }

  Future<bool> authenticateUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList(_usersKey) ?? [];
    
    for (var user in users) {
      final parts = user.split('|');
      if (parts[0] == email && parts[1] == password) {
        await prefs.setString(_currentUserKey, user);
        await prefs.setBool(_isLoggedInKey, true);
        return true;
      }
    }
    return false;
  }

  Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  Future<Map<String, String>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString(_currentUserKey);
    if (user == null) return null;
    
    final parts = user.split('|');
    return {
      'email': parts[0],
      'name': parts.length > 2 ? parts[2] : parts[0],
    };
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
}
