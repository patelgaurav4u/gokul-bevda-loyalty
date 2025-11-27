// lib/screens/tabs/home_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/theme.dart';
import '../../models/points_data.dart';
import '../../models/special_offer.dart';
import '../../models/recent_activity.dart';
import '../../services/api_service.dart';

class HomeTabContent extends StatefulWidget {
  const HomeTabContent({super.key});

  @override
  State<HomeTabContent> createState() => _HomeTabContentState();
}

class _HomeTabContentState extends State<HomeTabContent> {
  final ApiService _apiService = ApiService.create(
    baseUrl: 'https://api.example.com',
  );

  bool _isLoadingPoints = true;
  bool _isLoadingOffers = true;
  bool _isLoadingActivity = true;

  PointsData? _pointsData;
  List<SpecialOffer> _offers = [];
  List<RecentActivity> _activities = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Load points
    _apiService.getUserPoints().then((data) {
      if (mounted) {
        setState(() {
          _pointsData = data;
          _isLoadingPoints = false;
        });
      }
    });

    // Load offers
    _apiService.getSpecialOffersForHome().then((offers) {
      if (mounted) {
        setState(() {
          _offers = offers;
          _isLoadingOffers = false;
        });
      }
    });

    // Load activity
    _apiService.getRecentActivity().then((activities) {
      if (mounted) {
        setState(() {
          _activities = activities;
          _isLoadingActivity = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.bg,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Your Points Section
              _buildPointsSection(),

              const SizedBox(height: 20),

              // Special Offers Section
              _buildSpecialOffersSection(),

              const SizedBox(height: 20),

              // Recent Activity Section
              _buildRecentActivitySection(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointsSection() {
    return Container(
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Stack(
        children: [
          // Red gradient overlay from intersect.svg - positioned behind the icon
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120,
            child: SvgPicture.asset(
              'assets/images/intersect.svg',
              width: double.infinity,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Background hexagon - behind (larger to show behind the icon)
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.3,
                              child: SvgPicture.asset(
                                'assets/images/trans_points_bg.svg',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          // Icon on top - in front with top padding
                          Positioned(
                            top: 25,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/images/points_icn.svg',
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Your Points',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto Flex',
                                  ),
                                ),
                                if (!_isLoadingPoints && _pointsData != null)
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0x26FFFFFF),
                                          Color(0x26FFFFFF),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          // Handle redeem points
                                        },
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          child: const Text(
                                            'Redeem points',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Roboto Flex',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (_isLoadingPoints)
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (!_isLoadingPoints && _pointsData != null)
                            Text(
                              '${_pointsData!.points} Points >',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto Flex',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (_isLoadingPoints)
                  const SizedBox(
                    height: 40,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                else if (_pointsData != null) ...[
                  const SizedBox(height: 40),
                  Center(
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Complete ${_pointsData!.totalMissions} missions to become Platinum member',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFFFFF3D1),
                                  fontSize: 12,
                                  fontFamily: 'Roboto Flex',
                                ),
                              ),
                              const SizedBox(width: 8),
                              SvgPicture.asset(
                                'assets/images/gray_badgee.svg',
                                width: 20,
                                height: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'You\'ve completed ${_pointsData!.completedMissions} missions',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Color(0xFFFFF3D1),
                              fontSize: 10,
                              fontFamily: 'Roboto Flex',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialOffersSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.lightRed, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/flash_sale.svg',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Special Offers',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkRed,
                      fontFamily: 'Roboto Flex',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (_isLoadingOffers)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primary,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.darkRed,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // Handle view all offers
                        },
                        child: const Text(
                          'View All Offers',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto Flex',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoadingOffers)
            const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                ),
              ),
            )
          else if (_offers.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No offers available',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Roboto Flex',
                  ),
                ),
              ),
            )
          else
            ..._offers.map((offer) => _buildOfferCard(offer)),
        ],
      ),
    );
  }

  Widget _buildOfferCard(SpecialOffer offer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.lightRed, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            child: Stack(
              children: [
                // Background SVG
                Positioned.fill(
                  child: SvgPicture.asset(
                    'assets/images/red_round.svg',
                    fit: BoxFit.cover,
                  ),
                ),
                // Icon content
                Center(
                  child: offer.iconType == 'percentage'
                      ? SvgPicture.asset(
                          'assets/images/percentage.svg',
                          width: 15,
                          height: 15,
                        )
                      : SvgPicture.asset(
                          'assets/images/celebration.svg', // TODO: Replace with bottle.svg when available
                          width: 20,
                          height: 20,
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkRed,
                    fontFamily: 'Roboto Flex',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  offer.description.isNotEmpty
                      ? offer.description
                      : offer.category,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.unselected_tab_color,
                    fontFamily: 'Roboto Flex',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.lightRed, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/recent.svg',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkRed,
                      fontFamily: 'Roboto Flex',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (_isLoadingActivity)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primary,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.darkRed,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // Handle view all activity
                        },
                        child: const Text(
                          'View All Activity',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto Flex',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoadingActivity)
            const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                ),
              ),
            )
          else if (_activities.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No recent activity',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Roboto Flex',
                  ),
                ),
              ),
            )
          else
            ..._activities.asMap().entries.map((entry) {
              final index = entry.key;
              final activity = entry.value;
              return Column(
                children: [
                  _buildActivityItem(activity),
                  if (index < _activities.length - 1)
                    Divider(color: AppTheme.lightRed, thickness: 1, height: 1),
                ],
              );
            }),
        ],
      ),
    );
  }

  Widget _buildActivityItem(RecentActivity activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.type,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkRed2,
                    fontFamily: 'Roboto Flex',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.unselected_tab_color,
                    fontFamily: 'Roboto Flex',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${activity.date} • ${activity.time}',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.unselected_tab_color,
                    fontFamily: 'Roboto Flex',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${activity.isPositive ? '+' : '-'}${activity.points} pts',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: activity.isPositive
                  ? AppTheme.darkGreen
                  : AppTheme.primary,
              fontFamily: 'Roboto Flex',
            ),
          ),
        ],
      ),
    );
  }
}
