import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfile {
  final String id;
  final String? displayName;
  final String lifestyle;
  final String? avatarUrl;
  final String? bio;

  UserProfile({
    required this.id,
    this.displayName,
    this.lifestyle = 'single',
    this.avatarUrl,
    this.bio,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      displayName: json['display_name'],
      lifestyle: json['lifestyle'] ?? 'single',
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'lifestyle': lifestyle,
      'avatar_url': avatarUrl,
      'bio': bio,
    };
  }
}

class UserProvider extends ChangeNotifier {
  final SupabaseClient _supabase;
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _error;

  UserProvider(this._supabase);

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchUserProfile(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _supabase.from('users').select().eq('id', userId).single();

      _userProfile = UserProfile.fromJson(response);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    String? displayName,
    String? lifestyle,
    String? avatarUrl,
    String? bio,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updates = <String, dynamic>{};
      if (displayName != null) updates['display_name'] = displayName;
      if (lifestyle != null) updates['lifestyle'] = lifestyle;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (bio != null) updates['bio'] = bio;

      await _supabase.from('users').update(updates).eq('id', userId);

      if (_userProfile != null) {
        _userProfile = UserProfile(
          id: _userProfile!.id,
          displayName: displayName ?? _userProfile!.displayName,
          lifestyle: lifestyle ?? _userProfile!.lifestyle,
          avatarUrl: avatarUrl ?? _userProfile!.avatarUrl,
          bio: bio ?? _userProfile!.bio,
        );
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearProfile() {
    _userProfile = null;
    _error = null;
    notifyListeners();
  }
}
