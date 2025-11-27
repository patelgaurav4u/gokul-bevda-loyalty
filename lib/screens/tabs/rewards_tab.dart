// lib/screens/tabs/rewards_tab.dart
import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class RewardsTabContent extends StatelessWidget {
  const RewardsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.card_giftcard, size: 80, color: AppTheme.primary),
              const SizedBox(height: 16),
              const Text(
                'Rewards',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto Flex',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Rewards tab content',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontFamily: 'Roboto Flex',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

