/// API endpoint constants
class ApiEndpoints {
  static const String login = '/login';
  static const String sendOtp = '/send-otp';
  static const String verifyOtp = '/verify-otp';
  static const String createAccount = '/create-account';

  // Home screen endpoints
  static const String getUserPoints = '/user/points';
  static const String getSpecialOffers = '/special-offers';
  static const String getRecentActivity = '/recent-activity';

  // Purchase history endpoints
  static const String getPurchaseHistory = '/purchase-history';

  // Barcode/QR code endpoints
  static const String getUserQrData = '/user/qr-data';
}
