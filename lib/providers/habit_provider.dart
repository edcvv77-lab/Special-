import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/habit.dart';
import 'auth_provider.dart';

class HabitProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Habit> _habits = [];
  bool _isLoading = false;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;

  List<Habit> get todayHabits {
    int currentDay = DateTime.now().weekday;
    return _habits.where((habit) => habit.days.contains(currentDay)).toList();
  }

  double get completionRate {
    final today = todayHabits;
    if (today.isEmpty) return 0.0;

    int completedCount = today.where((h) => h.isCompletedToday).length;
    return completedCount / today.length;
  }

  HabitProvider() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _listenToHabits(user.uid);
      } else {
        _habits = [];
        notifyListeners();
      }
    });
  }

  void _listenToHabits(String uid) {
    _isLoading = true;
    notifyListeners();

    _firestore.collection('users').doc(uid).collection('habits').snapshots().listen((snapshot) {
      _habits = snapshot.docs.map((doc) => Habit.fromMap(doc.data(), doc.id)).toList();
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addHabit(Habit habit) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('habits')
          .doc(habit.id)
          .set(habit.toMap());
    }
  }

  Future<void> toggleHabitCompletion(String id, AuthProvider authProvider) async {
    final user = _auth.currentUser;
    if (user != null) {
      final index = _habits.indexWhere((h) => h.id == id);
      if (index >= 0) {
        bool newStatus = !_habits[index].isCompletedToday;

        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('habits')
            .doc(id)
            .update({'isCompletedToday': newStatus});

        // Reward points on completion
        if (newStatus) {
            authProvider.addPoints(_habits[index].importance * 10); // Importance multiplier
        } else {
            authProvider.addPoints(-(_habits[index].importance * 10)); // Deduct if unchecked
        }
      }
    }
  }
}
