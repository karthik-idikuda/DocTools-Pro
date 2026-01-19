import 'package:flutter/foundation.dart';
import '../../services/auth_service.dart';
import '../../domain/entities/app_user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  AppUser? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider({required AuthService authService}) : _authService = authService {
    // Listen to real Firebase Auth changes
    _authService.userChanges.listen((firebaseUser) {
      if (firebaseUser != null) {
        _user = AppUser(
          id: firebaseUser.uid,
          email: firebaseUser.email,
          displayName: firebaseUser.displayName,
          photoUrl: firebaseUser.photoURL,
        );
      } else {
        // Only clear user if we are not in 'Demo' mode (hacky check, or just overwrite)
        // For simplicity, real auth logout clears everything.
        // But if we are in demo mode, we shouldn't listen to stream? 
        // Actually, let's keep it simple: Real Auth > Demo Auth.
        // If stream emits null, we clear, unless we explicitly set a demo user that ignores stream?
        // Let's just say: standard stream listener updates _user. Demo login manually sets it.
        if (_user?.id != 'demo_user_id') {
           _user = null;
        }
      }
      notifyListeners();
    });
  }

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _authService.signInWithGoogle();

    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (user) {
        // Stream will update `_user`
        _isLoading = false;
        notifyListeners();
      },
    );
  }
  
  void signInDemo() {
    _user = const AppUser(
      id: 'demo_user_id',
      email: 'demo@example.com',
      displayName: 'Demo User',
      photoUrl: null, // No fake image, just generic icon
    );
    notifyListeners();
  }

  Future<void> signOut() async {
    if (_user?.id == 'demo_user_id') {
      _user = null;
      notifyListeners();
    } else {
      await _authService.signOut();
    }
  }
}
