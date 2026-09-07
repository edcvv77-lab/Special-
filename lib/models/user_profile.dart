class UserProfile {
  final String id;
  final String name;
  final List<String> goals;
  final int points;
  final int level;
  final int currentStreak;
  final int bestStreak;

  UserProfile({
    required this.id,
    required this.name,
    this.goals = const [],
    this.points = 0,
    this.level = 1,
    this.currentStreak = 0,
    this.bestStreak = 0,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    List<String>? goals,
    int? points,
    int? level,
    int? currentStreak,
    int? bestStreak,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      goals: goals ?? this.goals,
      points: points ?? this.points,
      level: level ?? this.level,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'goals': goals,
      'points': points,
      'level': level,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, String documentId) {
    return UserProfile(
      id: documentId,
      name: map['name'] ?? '',
      goals: List<String>.from(map['goals'] ?? []),
      points: map['points'] ?? 0,
      level: map['level'] ?? 1,
      currentStreak: map['currentStreak'] ?? 0,
      bestStreak: map['bestStreak'] ?? 0,
    );
  }
}
