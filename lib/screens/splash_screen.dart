import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final t = await auth.loadToken();
    await Future.delayed(const Duration(milliseconds: 400)); // short pause
    if (t != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    // central "phone" mock size — tweak to match your desired preview
    const phoneWidth = 360.0;
    const phoneHeight = 800.0;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: Container(
            width: phoneWidth,
            height: phoneHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top header (red + black curved strip)
                Stack(
                  children: [
                    // red header
                    Container(
                      height: 160,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFE53935), Color(0xFFEF5350)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // left icon circle
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.stars, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          // title + points
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SizedBox(height: 8),
                              Text(
                                'Your Points',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto Flex',
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                '1,200 Points',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontFamily: 'Roboto Flex',
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // redeem button mimic
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Redeem',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto Flex',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // black curved strip (overlapping bottom of header)
                    Positioned(
                      bottom: -12,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          width: phoneWidth,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Main scroll area (cards + recent activity)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: ListView(
                      children: [
                        // white card with offers (rounded border, slight shadow)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.15),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    'Special Offers',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto Flex',
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    'View All',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'Roboto Flex',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // simplified offer rows
                              _offerRow(
                                '20% OFF',
                                'Special limited time offer',
                              ),
                              const SizedBox(height: 8),
                              _offerRow(
                                'Premium Whiskey',
                                'Valid until 15 sep 2025',
                              ),
                              const SizedBox(height: 8),
                              _offerRow(
                                '20% OFF',
                                'Special limited time offer',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // recent activity box
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.12),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    'Recent Activity',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto Flex',
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    'View All',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'Roboto Flex',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _activityRow('Points Earned', '+150 pts'),
                              const SizedBox(height: 8),
                              _activityRow('Points Earned', '+150 pts'),
                              const SizedBox(height: 8),
                              _activityRow('Points Earned', '+150 pts'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom navigation mimic
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.history),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.card_giftcard_outlined),
                      ),
                      // highlighted home button
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.home, color: Colors.white),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.label_outline),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.qr_code),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // small helper widgets
  static Widget _offerRow(String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.percent, color: Colors.red),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto Flex',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontFamily: 'Roboto Flex',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _activityRow(String title, String points) {
    return Row(
      children: [
        const Icon(Icons.circle, size: 14, color: Colors.grey),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto Flex',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Purchase at Downtown Spirits\nJul 28, 2023 • 6:42 PM',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                  fontFamily: 'Roboto Flex',
                ),
              ),
            ],
          ),
        ),
        Text(
          points,
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto Flex',
          ),
        ),
      ],
    );
  }
}
