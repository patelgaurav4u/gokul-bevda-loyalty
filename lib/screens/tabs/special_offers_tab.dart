// lib/screens/tabs/special_offers_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/theme.dart';
import '../../models/special_offer.dart';
import '../../services/api_service.dart';

class SpecialOffersTabContent extends StatefulWidget {
  const SpecialOffersTabContent({super.key});

  @override
  State<SpecialOffersTabContent> createState() =>
      _SpecialOffersTabContentState();
}

class _SpecialOffersTabContentState extends State<SpecialOffersTabContent>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService.create(
    baseUrl: 'https://api.example.com',
  );

  late TabController _tabController;
  bool _isLoading = true;
  String? _error;
  List<SpecialOffer> _allOffers = [];
  List<SpecialOffer> _discounts = [];
  List<SpecialOffer> _buy1get1 = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _loadSpecialOffers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSpecialOffers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final allOffers = await _apiService.getSpecialOffers(type: 'all');
      final discounts = await _apiService.getSpecialOffers(type: 'discounts');
      final buy1get1 = await _apiService.getSpecialOffers(type: 'buy1get1');

      if (mounted) {
        setState(() {
          _allOffers = allOffers;
          _discounts = discounts;
          _buy1get1 = buy1get1;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'An error occurred';

        // Check for network errors
        if (e.toString().contains('SocketException') ||
            e.toString().contains('Network') ||
            e.toString().contains('connection') ||
            e.toString().contains('timeout') ||
            e.toString().contains('Failed host lookup')) {
          errorMessage =
              'Network error. Please check your internet connection and try again.';
        } else if (e.toString().contains('DioException') ||
            e.toString().contains('DioError')) {
          errorMessage = 'Network request failed. Please try again.';
        } else {
          errorMessage = e.toString();
        }

        setState(() {
          _error = errorMessage;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppTheme.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Container(
        color: Colors.white,
        child: SafeArea(child: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
        ),
      );
    }

    if (_error != null) {
      final isNetworkError =
          _error!.toLowerCase().contains('network') ||
          _error!.toLowerCase().contains('connection') ||
          _error!.toLowerCase().contains('timeout');

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isNetworkError ? Icons.wifi_off : Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                isNetworkError ? 'Network Error' : 'Error',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  fontFamily: 'Roboto Flex',
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Roboto Flex',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadSpecialOffers,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Header with red background
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: AppTheme.primary,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  // Navigate back if needed
                },
              ),
              const Expanded(
                child: Text(
                  'Special Offers',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto Flex',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48), // Balance space for back button
            ],
          ),
        ),
        Container(height: 70, color: AppTheme.primary),
        // Tabs
        Container(
          color: AppTheme.primary,
          child: Stack(
            children: [
              // Background containers with border radius for each tab
              Row(
                children: [
                  // Left tab - left top radius
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: _tabController.index == 0
                            ? Colors.white
                            : AppTheme.lightPink,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  // Middle tab - no radius
                  Expanded(
                    child: Container(
                      height: 50,
                      color: _tabController.index == 1
                          ? Colors.white
                          : AppTheme.lightPink,
                    ),
                  ),
                  // Right tab - right top radius
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: _tabController.index == 2
                            ? Colors.white
                            : AppTheme.lightPink,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // TabBar on top
              Container(
                height: 50,
                decoration: const BoxDecoration(color: Colors.transparent),
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppTheme.primary,
                  unselectedLabelColor: AppTheme.primary,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: _tabController.index == 0
                        ? const BorderRadius.only(topLeft: Radius.circular(30))
                        : _tabController.index == 2
                        ? const BorderRadius.only(topRight: Radius.circular(30))
                        : null,
                    border: const Border(
                      bottom: BorderSide(color: AppTheme.primary, width: 1.5),
                    ),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Roboto Flex',
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Roboto Flex',
                  ),
                  onTap: (index) {
                    setState(() {});
                  },
                  tabs: const [
                    Tab(text: 'All Offers'),
                    Tab(text: 'Discounts'),
                    Tab(text: 'Buy 1 Get 1'),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.lightPink,
              borderRadius: BorderRadius.circular(24),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search offers...',
                hintStyle: TextStyle(
                  color: AppTheme.unselected_tab_color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto Flex',
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SvgPicture.asset(
                    'assets/images/search.svg',
                    width: 15,
                    height: 15,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),

        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOffersList(_allOffers),
              _buildOffersList(_discounts),
              _buildOffersList(_buy1get1),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOffersList(List<SpecialOffer> offers) {
    final filteredOffers = _searchQuery.isEmpty
        ? offers
        : offers.where((offer) {
            return offer.title.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                offer.description.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                offer.category.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                );
          }).toList();

    if (filteredOffers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            _searchQuery.isNotEmpty
                ? 'No offers found for "$_searchQuery"'
                : 'No offers available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontFamily: 'Roboto Flex',
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredOffers.length,
      itemBuilder: (context, index) {
        return _buildOfferCard(filteredOffers[index]);
      },
    );
  }

  Widget _buildOfferCard(SpecialOffer offer) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        print('Offer card tapped: ${offer.title}');
        _showOfferPopup(context, offer);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.darkRed, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              offer.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.darkRed,
                fontFamily: 'Roboto Flex',
              ),
            ),
            const SizedBox(height: 8),

            // Tag - Right aligned
            const SizedBox(height: 8),
            // Description
            Text(
              offer.description,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.unselected_tab_color,
                fontFamily: 'Roboto Flex',
              ),
            ),
            const SizedBox(height: 12),
            // Category and Availability
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category - Left aligned
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontFamily: 'Roboto Flex',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      offer.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primary,
                        fontFamily: 'Roboto Flex',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                // Availability - Right aligned
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Availability:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontFamily: 'Roboto Flex',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      offer.availability,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primary,
                        fontFamily: 'Roboto Flex',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Light red separator
            Divider(color: AppTheme.lightRed, thickness: 1, height: 1),
            const SizedBox(height: 10),
            // Expires and Tag row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Expires
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: SvgPicture.asset(
                        'assets/images/time.svg',
                        width: 18,
                        height: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Expires: ${offer.expires}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.unselected_tab_color,
                        fontFamily: 'Roboto Flex',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                // Tag - Right aligned
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    offer.tag,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'Roboto Flex',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOfferPopup(BuildContext context, SpecialOffer offer) {
    print('Showing popup for offer: ${offer.title}');
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(14),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title and close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          offer.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'Roboto Flex',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  Text(
                    offer.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontFamily: 'Roboto Flex',
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Special Offer Details Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.lightPink,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'SPECIAL OFFER DETAILS',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primary,
                            fontFamily: 'Roboto Flex',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          offer.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[800],
                            fontFamily: 'Roboto Flex',
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Available at these stores section
                  const Text(
                    'Available at these stores',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Roboto Flex',
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Store list with icon
                  _buildStoreItem(
                    'Downtown Cellars',
                    '123 Main Street, India, NY 10001',
                    '9AM-9PM',
                    'In stock: 15 bottles',
                  ),
                  const SizedBox(height: 12),
                  _buildStoreItem(
                    'Downtown Cellars',
                    '123 Main Street, India, NY 10001',
                    '9AM-9PM',
                    'In stock: 15 bottles',
                  ),
                  const SizedBox(height: 12),
                  _buildStoreItem(
                    'Downtown Cellars',
                    '123 Main Street, India, NY 10001',
                    '9AM-9PM',
                    'In stock: 15 bottles',
                  ),
                  const SizedBox(height: 16),
                  // Close button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto Flex',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStoreItem(
    String storeName,
    String address,
    String hours,
    String stock,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightPink,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store icon
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SvgPicture.asset(
              'assets/images/store.svg',
              width: 20,
              height: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Store details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storeName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Roboto Flex',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontFamily: 'Roboto Flex',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hours,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    fontFamily: 'Roboto Flex',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stock,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto Flex',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
