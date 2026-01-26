// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/theme.dart';
import 'tabs/home_tab.dart';

import 'tabs/special_offers_tab.dart';
import 'tabs/purchase_history_tab.dart';
import 'tabs/barcode_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> get _tabs => [
    HomeTabContent(onNavigateToTab: _navigateToTab),

    const SpecialOffersTabContent(),
    const PurchaseHistoryTabContent(),
    const BarcodeTabContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavButton('assets/images/home.svg', 0),
              _buildNavButton('assets/images/special_offers.svg', 1),
              _buildNavButton('assets/images/purchase_history.svg', 2),
              _buildNavButton('assets/images/barcode.svg', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(String assetPath, int index) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          debugPrint('Tab tapped: $index, current: $_currentIndex');
          setState(() {
            _currentIndex = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: SvgPicture.asset(
              assetPath,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(
                isSelected ? AppTheme.primary : Colors.grey.shade600,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
