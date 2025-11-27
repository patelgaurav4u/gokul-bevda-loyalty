// lib/models/points_data.dart
class PointsData {
  final int points;
  final int completedMissions;
  final int totalMissions;

  PointsData({
    required this.points,
    required this.completedMissions,
    required this.totalMissions,
  });

  factory PointsData.fromJson(Map<String, dynamic> json) {
    return PointsData(
      points: json['points'] as int,
      completedMissions: json['completed_missions'] as int,
      totalMissions: json['total_missions'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'points': points,
      'completed_missions': completedMissions,
      'total_missions': totalMissions,
    };
  }
}

