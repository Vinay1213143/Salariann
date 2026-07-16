import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/api_config.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseClient _supabase;
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._supabase) {
    _initializeAuth();
  }

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  void _initializeAuth() {
    _user = _supabase.auth.currentUser;
    if (_user != null) {
      _token = _supabase.auth.currentSession?.accessToken;
    }
    _supabase.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      _token = data.session?.accessToken;
      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password, String displayName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Step 1: Create user via backend (uses admin API, bypasses email rate limit)
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'displayName': displayName,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode != 201) {
        _error = body['error'] ?? 'Failed to create account';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Step 2: Sign in with the newly created account to get session
      final authResponse = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      _user = authResponse.user;
      _token = authResponse.session?.accessToken;
      _error = null;
    } catch (e) {
      _error = 'Could not create account. Please try again.';
      print('Signup error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      _user = response.user;
      _token = response.session?.accessToken;
      _error = null;
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('Invalid login')) {
        _error = 'Invalid email or password.';
      } else {
        _error = 'Login failed. Please try again.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _supabase.auth.signOut();
      _user = null;
      _token = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _supabase.auth.resetPasswordForEmail(email);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
