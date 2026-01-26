// lib/services/api_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/points_data.dart';
import '../models/special_offer.dart';
import '../models/recent_activity.dart';
import '../models/recent_activity.dart';
import '../models/purchase_history.dart';
import '../models/offer_detail.dart';

class ApiService {
  final Dio dio;

  ApiService._(this.dio);

  /// Create an ApiService with sensible defaults.
  /// Replace baseUrl with your server base URL.
  factory ApiService.create({required String baseUrl}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Simple logging interceptor (optional)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // print('→ ${options.method} ${options.uri}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          // print('← ${response.statusCode} ${response.requestOptions.uri}');
          handler.next(response);
        },
        onError: (err, handler) {
          // print('✖ ${err.message}');
          handler.next(err);
        },
      ),
    );

    // Authentication interceptor - automatically adds token to requests
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Load token from SharedPreferences
          final sp = await SharedPreferences.getInstance();
          final token = sp.getString('auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (err, handler) {
          // Handle 401 Unauthorized - token may be expired
          if (err.response?.statusCode == 401) {
            // Token expired or invalid
            // You may want to clear token and navigate to login
            // This can be handled by the calling code or via a callback
          }
          handler.next(err);
        },
      ),
    );

    return ApiService._(dio);
  }

  /// Mock API: Get user points data
  /// Simulates API call with delay
  Future<PointsData> getUserPoints() async {
    // Return empty data
    return PointsData(points: 0, completedMissions: 4, totalMissions: 8);
  }

  /// Get special offers from API
  Future<List<SpecialOffer>> getSpecialOffers({String? type}) async {
    try {
      final headers = <String, dynamic>{
        'UserId': 'i/jvNw56275GboRZu0XoNQ==', // Static
        'Password': 'no4mXKgy2gnpvdDDjXG49A==', // Static
      };

      final response = await dio.get(
        'GetSalesPromotionByProduct',
        options: Options(headers: headers),
      );

      print('GetSalesPromotionByProduct Response: ${response.statusCode}');

      if (response.data['Result'] == true && response.data['Data'] != null) {
        final promotionsJson =
            response.data['Data']['Promotions'] as List<dynamic>? ?? [];
        final allOffers = promotionsJson
            .map((json) => SpecialOffer.fromJson(json as Map<String, dynamic>))
            .toList();

        // Filter by type if provided
        if (type != null && type != 'all') {
          return allOffers.where((offer) => offer.type == type).toList();
        }

        return allOffers;
      } else {
        // Return empty list if Result is false or Data is null
        return [];
      }
    } catch (e) {
      // Re-throw to be handled by the UI
      rethrow;
    }
  }

  /// Get special offer details by Sale ID
  Future<OfferDetail?> getOfferDetails(String saleId) async {
    try {
      final headers = <String, dynamic>{
        'UserId': 'i/jvNw56275GboRZu0XoNQ==', // Static
        'Password': 'no4mXKgy2gnpvdDDjXG49A==', // Static
        'Sale_Id': saleId,
      };
      //print('GetSalesPromotionDescription Request: ${response}');
      // Construct query parameters
      // Assuming GET request with query param, or POST with body?
      // Based on method name 'GetSalesPromotionDescription', likely a GET or POST.
      // Standard practice for this app seems to be GET or POST with headers.
      // User didn't specify method, assuming GET with query param or path.
      // Actually, looking at previous calls, it might take params in body if POST, or query if GET.
      // Let's assume query param 'id' or similar.
      // WAIT: The prompt says "API Name: GetSalesPromotionDescription".
      // It likely expects a query parameter for SaleID.
      // Let's try sending it as a query parameter `?saleid=...`

      final response = await dio.get(
        'GetSalesPromotionDescription',
        options: Options(headers: headers),
      );

      print('GetSalesPromotionDescription Response: ${response}');
      // print('Data: ${response.data}');

      if (response.data['Result'] == true && response.data['Data'] != null) {
        return OfferDetail.fromJson(
          response.data['Data'] as Map<String, dynamic>,
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching offer details: $e');
      rethrow;
    }
  }

  /// Legacy method for home tab compatibility
  /// Returns simplified offers for home screen
  Future<List<SpecialOffer>> getSpecialOffersForHome() async {
    final offers = await getSpecialOffers();
    // Return first 3 offers for home screen
    return offers.take(3).toList();
  }

  /// Mock API: Get recent activity
  /// Simulates API call with delay
  Future<List<RecentActivity>> getRecentActivity() async {
    // Return empty list
    return [];
  }

  /// Get user QR code data from local storage
  Future<Map<String, dynamic>> getUserQrData() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final userStr = sp.getString('user_data');
      if (userStr != null && userStr.isNotEmpty) {
        final Map<String, dynamic> userMap = jsonDecode(userStr);
        return {
          'firstname': userMap['firstname'] ?? '',
          'lastname': userMap['lastname'] ?? '',
          'customer_id': userMap['customer_id']?.toString() ?? '',
        };
      }
    } catch (e) {
      // ignore
    }
    return {'firstname': '', 'lastname': '', 'customer_id': ''};
  }

  /// Mock API: Get purchase history summary
  /// Simulates API call with delay
  Future<PurchaseHistorySummary> getPurchaseHistory() async {
    // Return empty summary
    return PurchaseHistorySummary(
      pointsBalance: 0,
      pointsEarned: 0,
      pointsRedeemed: 0,
      earnedTransactionsCount: 0,
      redeemedTransactionsCount: 0,
      allTransactions: [],
    );
  }

  Future<Map<String, dynamic>> generateRedemptionCode({
    required String amount,
    required String store,
  }) async {
    return {'success': false, 'message': 'API implementation pending'};
  }
}
