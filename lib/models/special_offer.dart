// lib/models/special_offer.dart
import 'store.dart';

class SpecialOffer {
  final String id;
  final String title;
  final String description;
  final String category;
  final String categoryTitle;
  final String availability;
  final String expires;
  final String tag; // 'Limited Time', 'Popular', etc.
  final String type; // 'all', 'discounts', 'buy1get1'
  final String iconType; // 'percentage' or 'bottle'
  final List<Store> stores; // List of stores where offer is available

  SpecialOffer({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryTitle,
    required this.category,
    required this.availability,
    required this.expires,
    required this.tag,
    required this.type,
    required this.iconType,
    this.stores = const [], // Default to empty list
  });

  factory SpecialOffer.fromJson(Map<String, dynamic> json) {
    // Helper to format date
    String formatExpires(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return '';
      try {
        final date = DateTime.parse(dateStr);
        // format like 'Oct 11, 2025'
        final months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        return '${months[date.month - 1]} ${date.day}, ${date.year}';
      } catch (e) {
        return dateStr;
      }
    }

    // Helper to parse type
    String parseType(String? discountType) {
      if (discountType == 'Exact') return 'discounts';
      if (discountType == 'BOGO') return 'buy1get1';
      return 'all';
    }

    // Helper to parse icon type
    String parseIconType(String? discountType) {
      if (discountType == 'Exact') return 'percentage';
      if (discountType == 'BOGO') return 'bottle';
      return 'percentage';
    }

    final rawStores = json['stores'] as String? ?? '';
    final storeList = rawStores
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    // Create Store objects from simple names
    final stores = storeList
        .map(
          (name) => Store(
            id: '', // No ID from this API
            name: name,
            address: '', // No address from this API
            hours: 'Check in store', // Default
            phone: 'Check in store', // Default
            stock: 'Check availability', // Default
          ),
        )
        .toList();

    return SpecialOffer(
      id: (json['sale_id'] ?? '').toString(),
      title: json['promodescription'] as String? ?? '',
      description: (json['note'] as String? ?? '').isEmpty
          ? 'No description available'
          : json['note'] as String,
      categoryTitle: json['targettypedesc'] as String? ?? '',
      category: json['promotargetname'] as String? ?? 'No data available',
      availability: rawStores,
      expires: formatExpires(json['enddate'] as String?),
      tag: (json['enddate'] != null && json['enddate'].toString().isNotEmpty)
          ? 'Limited Time'
          : '',
      type: parseType(json['discounttype'] as String?),
      iconType: parseIconType(json['discounttype'] as String?),
      stores: stores,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categoryTitle': categoryTitle,
      'category': category,
      'availability': availability,
      'expires': expires,
      'tag': tag,
      'type': type,
      'iconType': iconType,
      'stores': stores.map((store) => store.toJson()).toList(),
    };
  }
}
