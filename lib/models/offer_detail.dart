import 'package:flutter/foundation.dart';
import 'store.dart';

class OfferDetail {
  final String saleId;
  final String saleName;
  final String saleOn;
  final String saleItemName;
  final String saleDetails;
  final String storeIds;
  final List<Store> stores;

  OfferDetail({
    required this.saleId,
    required this.saleName,
    required this.saleOn,
    required this.saleItemName,
    required this.saleDetails,
    required this.storeIds,
    required this.stores,
  });

  factory OfferDetail.fromJson(Map<String, dynamic> json) {
    // Parse StoreDetails
    var storeList = <Store>[];
    if (json['StoreDetails'] != null) {
      final storeJsonList = json['StoreDetails'] as List<dynamic>;
      storeList = storeJsonList
          .map((data) => Store.fromJson(data as Map<String, dynamic>))
          .toList();
    }

    return OfferDetail(
      saleId: json['SaleId'] as String? ?? '',
      saleName: json['SaleName'] as String? ?? '',
      saleOn: json['SaleOn'] as String? ?? '',
      saleItemName: json['SaleItemName'] as String? ?? '',
      saleDetails: json['SaleDetails'] as String? ?? '',
      storeIds: json['Store_ids'] as String? ?? '',
      stores: storeList,
    );
  }
}
