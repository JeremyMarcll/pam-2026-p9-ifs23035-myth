import 'package:flutter/material.dart';
import '../data/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isLoggedIn = false;

  String? token;

  Future<void> login(String username, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await AuthService.login(username, password);

      token = result["token"]; // asumsi backend kirim token
      isLoggedIn = true;

    } catch (e) {
      isLoggedIn = false;
      rethrow; // biar bisa ditangkap di UI
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    token = null;
    isLoggedIn = false;
    notifyListeners();
  }
}