// lib/screens/tabs/special_offers_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/api_config.dart';
import '../../utils/theme.dart';
import '../../services/api_service.dart';
import '../../models/special_offer.dart';
import '../../widgets/offer_dialog.dart';

class SpecialOffersTabContent extends StatefulWidget {
  const SpecialOffersTabContent({super.key});

  @override
  State<SpecialOffersTabContent> createState() =>
      _SpecialOffersTabContentState();
}

class _SpecialOffersTabContentState extends State<SpecialOffersTabContent>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService.create(baseUrl: ApiConfig.baseUrl);

  late TabController _tabController;

  // Loading states for each tab
  bool _isLoadingAll = true;
  bool _isLoadingDiscounts = true;
  bool _isLoadingBuy1Get1 = true;

  // Error states for each tab
  String? _errorAll;
  String? _errorDiscounts;
  String? _errorBuy1Get1;

  // Data for each tab
  List<SpecialOffer> _allOffers = [];
  List<SpecialOffer> _discounts = [];
  List<SpecialOffer> _buy1get1 = [];
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    // Load data for all tabs independently
    _loadAllOffers();
    _loadDiscounts();
    _loadBuy1Get1();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Load data for "All Offers" tab
  Future<void> _loadAllOffers() async {
    setState(() {
      _isLoadingAll = true;
      _errorAll = null;
    });

    try {
      final allOffers = await _apiService.getSpecialOffers(type: 'all');

      if (mounted) {
        setState(() {
          _allOffers = allOffers;
          _isLoadingAll = false;
        });
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = _getErrorMessage(e);
        setState(() {
          _errorAll = errorMessage;
          _isLoadingAll = false;
        });
      }
    }
  }

  // Load data for "Discounts" tab
  Future<void> _loadDiscounts() async {
    setState(() {
      _isLoadingDiscounts = true;
      _errorDiscounts = null;
    });

    try {
      final discounts = await _apiService.getSpecialOffers(type: 'discounts');

      if (mounted) {
        setState(() {
          _discounts = discounts;
          _isLoadingDiscounts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = _getErrorMessage(e);
        setState(() {
          _errorDiscounts = errorMessage;
          _isLoadingDiscounts = false;
        });
      }
    }
  }

  // Load data for "Buy 1 Get 1" tab
  Future<void> _loadBuy1Get1() async {
    setState(() {
      _isLoadingBuy1Get1 = true;
      _errorBuy1Get1 = null;
    });

    try {
      final buy1get1 = await _apiService.getSpecialOffers(type: 'buy1get1');

      if (mounted) {
        setState(() {
          _buy1get1 = buy1get1;
          _isLoadingBuy1Get1 = false;
        });
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = _getErrorMessage(e);
        setState(() {
          _errorBuy1Get1 = errorMessage;
          _isLoadingBuy1Get1 = false;
        });
      }
    }
  }

  // Helper method to extract error message
  String _getErrorMessage(dynamic e) {
    // Check for network errors
    if (e.toString().contains('SocketException') ||
        e.toString().contains('Network') ||
        e.toString().contains('connection') ||
        e.toString().contains('timeout') ||
        e.toString().contains('Failed host lookup')) {
      return 'Network error. Please check your internet connection and try again.';
    } else if (e.toString().contains('DioException') ||
        e.toString().contains('DioError')) {
      return 'Network request failed. Please try again.';
    } else {
      return e.toString();
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
    return Column(
      children: [
        // Header with red background
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: AppTheme.primary,
          child: Row(
            children: [
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
                    Tab(text: 'BOGO'),
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
              controller: _searchController,
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
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppTheme.unselected_tab_color,
                          size: 20,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          // Hide keyboard
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
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
              _buildTabContent(
                isLoading: _isLoadingAll,
                error: _errorAll,
                offers: _allOffers,
                onRetry: _loadAllOffers,
              ),
              _buildTabContent(
                isLoading: _isLoadingDiscounts,
                error: _errorDiscounts,
                offers: _discounts,
                onRetry: _loadDiscounts,
              ),
              _buildTabContent(
                isLoading: _isLoadingBuy1Get1,
                error: _errorBuy1Get1,
                offers: _buy1get1,
                onRetry: _loadBuy1Get1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build tab content with loading/error handling
  Widget _buildTabContent({
    required bool isLoading,
    required String? error,
    required List<SpecialOffer> offers,
    required VoidCallback onRetry,
  }) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
        ),
      );
    }

    if (error != null) {
      final isNetworkError =
          error.toLowerCase().contains('network') ||
          error.toLowerCase().contains('connection') ||
          error.toLowerCase().contains('timeout');

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
                  error,
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
                onPressed: onRetry,
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

    return _buildOffersList(offers);
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
                ) ||
                offer.categoryTitle.toLowerCase().contains(
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
        _showOfferPopup(context, offer.id, offer.description);
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
            //const SizedBox(height: 8),
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
                      offer.categoryTitle,
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
                      "Selected Stores",
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
            if (offer.expires.isNotEmpty)
              Divider(color: AppTheme.lightRed, thickness: 1, height: 1),
            if (offer.expires.isNotEmpty) const SizedBox(height: 10),
            // Expires and Tag row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Expires
                if (offer.expires.isNotEmpty)
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
                if (offer.expires.isNotEmpty)
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

  void _showOfferPopup(BuildContext context, String saleId, String note) {
    print('Showing popup for saleId: $saleId');
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (BuildContext dialogContext) {
        return OfferDialog(saleId: saleId, note: note);
      },
    );
  }
}
