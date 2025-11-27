// lib/models/purchase_history.dart
class PurchaseHistory {
  final String id;
  final String type; // 'purchase' or 'reward'
  final String description;
  final String date;
  final String time;
  final int points;
  final bool isPositive; // true for earned, false for redeemed

  PurchaseHistory({
    required this.id,
    required this.type,
    required this.description,
    required this.date,
    required this.time,
    required this.points,
    required this.isPositive,
  });

  factory PurchaseHistory.fromJson(Map<String, dynamic> json) {
    return PurchaseHistory(
      id: json['id'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      points: json['points'] as int,
      isPositive: json['is_positive'] as bool,
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

class PurchaseHistorySummary {
  final int pointsBalance;
  final int pointsEarned;
  final int pointsRedeemed;
  final int earnedTransactionsCount;
  final int redeemedTransactionsCount;
  final List<PurchaseHistory> allTransactions;

  PurchaseHistorySummary({
    required this.pointsBalance,
    required this.pointsEarned,
    required this.pointsRedeemed,
    required this.earnedTransactionsCount,
    required this.redeemedTransactionsCount,
    required this.allTransactions,
  });

  factory PurchaseHistorySummary.fromJson(Map<String, dynamic> json) {
    return PurchaseHistorySummary(
      pointsBalance: json['points_balance'] as int,
      pointsEarned: json['points_earned'] as int,
      pointsRedeemed: json['points_redeemed'] as int,
      earnedTransactionsCount: json['earned_transactions_count'] as int,
      redeemedTransactionsCount: json['redeemed_transactions_count'] as int,
      allTransactions: (json['transactions'] as List)
          .map((item) => PurchaseHistory.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'points_balance': pointsBalance,
      'points_earned': pointsEarned,
      'points_redeemed': pointsRedeemed,
      'earned_transactions_count': earnedTransactionsCount,
      'redeemed_transactions_count': redeemedTransactionsCount,
      'transactions': allTransactions.map((t) => t.toJson()).toList(),
    };
  }

  List<PurchaseHistory> get earnedTransactions {
    return allTransactions.where((t) => t.isPositive).toList();
  }

  List<PurchaseHistory> get redeemedTransactions {
    return allTransactions.where((t) => !t.isPositive).toList();
  }
}

