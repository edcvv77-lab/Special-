import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth?.dart';
import 'package:cloud_firestore/cloud_firestore?.dart';
import '../models/user_profile.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;


  UserProfile? _userProfile;
  bool _isLoading = false;

  UserProfile? get user => _userProfile;
  bool get isAuthenticated => _userProfile != null;
  bool get isLoading => _isLoading;

  AuthProvider() {
    try {
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
    } catch(e) {
      print("Firebase not initialized in AuthProvider: $e");
    }
    _init();
  }

  Future<void> _init() async {
    _auth?.authStateChanges().listen((User? user) async {
      if (user != null) {
        await _fetchUserProfile(user.uid);
      } else {
        _userProfile = null;
        notifyListeners();
      }
    });
  }

  Future<void> _fetchUserProfile(String uid) async {
    try {
      _isLoading = true;
      notifyListeners();

      final doc = await _firestore?.collection('users').doc(uid).get();
      if (doc.exists) {
        _userProfile = UserProfile.fromMap(doc.data()!, doc.id);
      }
    } catch (e) {
      print("Error fetching user profile: \$e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginAnonymous(String name) async {
    try {
      _isLoading = true;
      notifyListeners();

      // For MVP we can use anonymous login and store name
      final userCredential = await _auth?.signInAnonymously();

      final newUser = UserProfile(id: userCredential.user!.uid, name: name);
      await _firestore?.collection('users').doc(newUser.id).set(newUser.toMap());

      _userProfile = newUser;
    } catch (e) {
      print("Error signing in anonymously: \$e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateGoals(List<String> newGoals) async {
    if (_userProfile != null) {
      _userProfile = _userProfile!.copyWith(goals: newGoals);
      await _firestore?.collection('users').doc(_userProfile!.id).update({'goals': newGoals});
      notifyListeners();
    }
  }

  Future<void> addPoints(int pointsToAdd) async {
     if (_userProfile != null) {
        int newPoints = _userProfile!.points + pointsToAdd;
        int newLevel = (newPoints / 100).floor() + 1; // 1 level per 100 points

        _userProfile = _userProfile!.copyWith(points: newPoints, level: newLevel);
        await _firestore?.collection('users').doc(_userProfile!.id).update({
          'points': newPoints,
          'level': newLevel,
        });
        notifyListeners();
     }
  }

  Future<void> logout() async {
    await _auth?.signOut();
  }
}
