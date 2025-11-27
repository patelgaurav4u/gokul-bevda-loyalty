// lib/models/special_offer.dart
class SpecialOffer {
  final String id;
  final String title;
  final String description;
  final String category;
  final String availability;
  final String expires;
  final String tag; // 'Limited Time', 'Popular', etc.
  final String type; // 'all', 'discounts', 'buy1get1'
  final String iconType; // 'percentage' or 'bottle'

  SpecialOffer({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.availability,
    required this.expires,
    required this.tag,
    required this.type,
    required this.iconType,
  });

  factory SpecialOffer.fromJson(Map<String, dynamic> json) {
    return SpecialOffer(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      availability: json['availability'] as String,
      expires: json['expires'] as String,
      tag: json['tag'] as String,
      type: json['type'] as String,
      iconType: json['icon_type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'availability': availability,
      'expires': expires,
      'tag': tag,
      'type': type,
      'icon_type': iconType,
    };
  }
}

