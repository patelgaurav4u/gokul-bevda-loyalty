// lib/models/recent_activity.dart
class RecentActivity {
  final String id;
  final String type; // e.g., 'Points Earned'
  final String description;
  final String date;
  final String time;
  final int points;
  final bool isPositive; // true for earned, false for redeemed

  RecentActivity({
    required this.id,
    required this.type,
    required this.description,
    required this.date,
    required this.time,
    required this.points,
    this.isPositive = true,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      id: json['id'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      points: json['points'] as int,
      isPositive: json['is_positive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'date': date,
      'time': time,
      'points': points,
      'is_positive': isPositive,
    };
  }
}

