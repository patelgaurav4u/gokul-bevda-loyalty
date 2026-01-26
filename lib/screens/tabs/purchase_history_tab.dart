import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../models/transaction_history.dart';
import '../../utils/theme.dart';
import '../../utils/responsive.dart';

class PurchaseHistoryTabContent extends StatefulWidget {
  const PurchaseHistoryTabContent({super.key});

  @override
  State<PurchaseHistoryTabContent> createState() =>
      _PurchaseHistoryTabContentState();
}

class _PurchaseHistoryTabContentState extends State<PurchaseHistoryTabContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Filter State
  String _filterType = 'All';
  String _filterCategory = 'All';
  String _filterStartDate = '';
  String _filterEndDate = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await Future.wait([
      auth.fetchDashboard(context),
      auth.fetchTransactionHistory(context),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppTheme.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Container(
        color: Colors.white,
        child: SafeArea(child: _buildBody(auth)),
      ),
    );
  }

  Widget _buildBody(AuthProvider auth) {
    if (auth.loadingTransactionHistory) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
        ),
      );
    }

    final pointsBalance = auth.dashboardData?.customerPoints ?? 0;

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppTheme.primary,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Sliver Header (Banner + Title Bar)
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // Points Balance Banner
                Container(
                  width: double.infinity,
                  height: 170,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: SvgPicture.asset(
                          'assets/images/reactangle_red.svg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 15,
                        right: 15,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Color(0x40FFFFFF), Color(0x40FFFFFF)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFFFFFFF),
                                width: .5,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 15,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Your Points Balance:',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Roboto Flex',
                                        ),
                                      ),
                                      Text(
                                        '${pointsBalance} pts',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Roboto Flex',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Transparent Title Bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 12,
                    ),
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Purchase History',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto Flex',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          icon: SvgPicture.asset(
                            'assets/images/filter.svg',
                            width: 17,
                            height: 17,
                          ),
                          onPressed: () => _showFilterPopup(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Sticky Tab Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              child: Container(
                color: const Color(0xFFCC0000),
                child: Stack(
                  children: [
                    Row(
                      children: [
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
                        Expanded(
                          child: Container(
                            height: 50,
                            color: _tabController.index == 1
                                ? Colors.white
                                : const Color(0xFFFFF5F5),
                          ),
                        ),
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
                    Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: AppTheme.primary,
                        unselectedLabelColor: AppTheme.primary,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: _tabController.index == 0
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                )
                              : _tabController.index == 2
                              ? const BorderRadius.only(
                                  topRight: Radius.circular(30),
                                )
                              : null,
                          border: const Border(
                            bottom: BorderSide(
                              color: AppTheme.primary,
                              width: 1.5,
                            ),
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
                          Tab(text: 'All'),
                          Tab(text: 'Earned'),
                          Tab(text: 'Redeemed'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Tab Content as List
          if (_tabController.index == 0) ..._buildAllSliverList(auth),
          if (_tabController.index == 1) ..._buildEarnedSliverList(auth),
          if (_tabController.index == 2) ..._buildRedeemedSliverList(auth),
        ],
      ),
    );
  }

  List<Widget> _buildAllSliverList(AuthProvider auth) {
    final transactions = _applyFilters(auth.transactionHistory);
    final totalEarned = transactions
        .where((t) => t.collectedPoint > 0)
        .fold(0.0, (sum, t) => sum + t.collectedPoint);
    final totalRedeemed = transactions
        .where((t) => t.collectedPoint < 0)
        .fold(0.0, (sum, t) => sum + t.collectedPoint.abs());

    return [
      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Center(
            child: Text(
              'All Points Activity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
                fontFamily: 'Roboto Flex',
              ),
            ),
          ),
        ),
      ),
      // Only show summary boxes if no filter is active or handle logic accordingly
      // For now, let's keep showing totals
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            children: [
              Expanded(
                child: _buildSummaryBox(
                  '+${totalEarned.toInt()}',
                  'Points Earned',
                  AppTheme.lightPink,
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: _buildSummaryBox(
                  '-${totalRedeemed.toInt()}',
                  'Points Redeemed',
                  AppTheme.lightPink,
                ),
              ),
            ],
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 16)),
      if (transactions.isEmpty)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text('No transactions match your filter')),
          ),
        )
      else
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildTransactionItem(transactions[index]),
            childCount: transactions.length,
          ),
        ),
      const SliverToBoxAdapter(child: SizedBox(height: 16)),
    ];
  }

  List<Widget> _buildEarnedSliverList(AuthProvider auth) {
    final transactions = _applyFilters(
      auth.transactionHistory.where((t) => t.collectedPoint > 0).toList(),
    );
    final totalEarned = transactions.fold(
      0.0,
      (sum, t) => sum + t.collectedPoint,
    );

    return [
      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Center(
            child: Text(
              'Points Earned',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
                fontFamily: 'Roboto Flex',
              ),
            ),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            children: [
              Expanded(
                child: _buildSummaryBox(
                  '+${totalEarned.toInt()}',
                  'Points Earned',
                  AppTheme.lightPink,
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: _buildSummaryBox(
                  '${transactions.length}',
                  'Transactions',
                  AppTheme.lightPink,
                ),
              ),
            ],
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 16)),
      if (transactions.isEmpty)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text('No earned transactions found')),
          ),
        )
      else
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildTransactionItem(transactions[index]),
            childCount: transactions.length,
          ),
        ),
      const SliverToBoxAdapter(child: SizedBox(height: 16)),
    ];
  }

  List<Widget> _buildRedeemedSliverList(AuthProvider auth) {
    final transactions = _applyFilters(
      auth.transactionHistory.where((t) => t.collectedPoint < 0).toList(),
    );
    final totalRedeemed = transactions.fold(
      0.0,
      (sum, t) => sum + t.collectedPoint.abs(),
    );

    return [
      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Center(
            child: Text(
              'Points Redeemed',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
                fontFamily: 'Roboto Flex',
              ),
            ),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            children: [
              Expanded(
                child: _buildSummaryBox(
                  '-${totalRedeemed.toInt()}',
                  'Points Redeemed',
                  AppTheme.lightPink,
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: _buildSummaryBox(
                  '${transactions.length}',
                  'Rewards',
                  AppTheme.lightPink,
                ),
              ),
            ],
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 16)),
      if (transactions.isEmpty)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text('No redeemed transactions found')),
          ),
        )
      else
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildTransactionItem(transactions[index]),
            childCount: transactions.length,
          ),
        ),
      const SliverToBoxAdapter(child: SizedBox(height: 16)),
    ];
  }

  Widget _buildSummaryBox(String value, String label, Color backgroundColor) {
    final isPink = backgroundColor == AppTheme.lightPink;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: isPink
            ? Border.all(
                color: AppTheme.darkPink, // Dark pink border
                width: 1,
              )
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
              fontFamily: 'Roboto Flex',
            ),
            textAlign: TextAlign.center,
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
                fontFamily: 'Roboto Flex',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTransactionItem(TransactionHistoryItem transaction) {
    final isEarned = transaction.collectedPoint > 0;
    final iconAsset = isEarned
        ? 'assets/images/bag.svg'
        : 'assets/images/prize.svg';
    final title = isEarned
        ? "Purchase at ${transaction.storeName}"
        : "Reward Redeemed: ${transaction.storeName}";

    // Formatting date: July 28, 2023 • 6:42 PM
    String formattedDateTime = '';
    try {
      final dateTime = DateTime.parse(transaction.txnDate);
      formattedDateTime = DateFormat('MMMM d, yyyy • h:mm a').format(dateTime);
    } catch (e) {
      formattedDateTime = transaction.txnDate;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Icon
              Container(
                width: 50,
                height: 50,
                child: Stack(
                  children: [
                    // Background image
                    Positioned.fill(
                      child: SvgPicture.asset(
                        isEarned
                            ? 'assets/images/green_round.svg'
                            : 'assets/images/pink_round.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Icon on top
                    Center(
                      child: SvgPicture.asset(iconAsset, width: 20, height: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Transaction Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontFamily: 'Roboto Flex',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formattedDateTime,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.unselected_tab_color,
                        fontFamily: 'Roboto Flex',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Points
              Text(
                '${isEarned ? '+' : ''}${transaction.collectedPoint.toInt()} pts',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isEarned ? AppTheme.lightGreen : AppTheme.primary,
                  fontFamily: 'Roboto Flex',
                ),
              ),
            ],
          ),
        ),
        // Separator
        Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey.shade200,
          indent: 16,
          endIndent: 16,
        ),
      ],
    );
  }

  void _showFilterPopup(BuildContext context) {
    // Filter state initialized from parent state
    String selectedTransactionType = _filterType;
    String selectedCategory = _filterCategory;
    String startDate = _filterStartDate;
    String endDate = _filterEndDate;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (BuildContext dialogContext) {
        // Helper to parse date string "d/M/yyyy"
        DateTime? parseDate(String dateStr) {
          if (dateStr.isEmpty) return null;
          try {
            final parts = dateStr.split('/');
            if (parts.length != 3) return null;
            return DateTime(
              int.parse(parts[2]),
              int.parse(parts[1]),
              int.parse(parts[0]),
            );
          } catch (e) {
            return null;
          }
        }

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: EdgeInsets.symmetric(
                horizontal: Responsive.padding(context, 16),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Material(
                  color: Colors.white,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: Responsive.dialogWidth(context),
                      maxHeight: Responsive.dialogMaxHeight(context),
                    ),
                    color: Colors.white,
                    padding: EdgeInsets.all(Responsive.padding(context, 20)),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with title and close button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Filter Transactions',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontFamily: 'Roboto Flex',
                                ),
                              ),
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/images/close.svg',
                                  width: 17,
                                  height: 17,
                                ),
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Transaction Type Section
                          _buildFilterSection(
                            'Transaction Type',
                            ['All', 'Earned', 'Redeemed'],
                            selectedTransactionType,
                            (value) {
                              setDialogState(() {
                                selectedTransactionType = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          // Category Section
                          _buildFilterSection(
                            'Category',
                            ['All', 'Purchase', 'Reward'],
                            selectedCategory,
                            (value) {
                              setDialogState(() {
                                selectedCategory = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          // Date Range Section
                          const Text(
                            'Date Range',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'Roboto Flex',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDateField(
                                  'mm/dd/yyyy',
                                  startDate,
                                  () async {
                                    final endDt = parseDate(endDate);
                                    final lastDate =
                                        endDt != null &&
                                            endDt.isBefore(DateTime.now())
                                        ? endDt
                                        : DateTime.now();

                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: lastDate,
                                      firstDate: DateTime(2020),
                                      lastDate: lastDate,
                                    );
                                    if (date != null) {
                                      setDialogState(() {
                                        startDate =
                                            '${date.day}/${date.month}/${date.year}';
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildDateField(
                                  'mm/dd/yyyy',
                                  endDate,
                                  () async {
                                    final startDt = parseDate(startDate);
                                    final firstDate = startDt ?? DateTime(2020);

                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: firstDate,
                                      lastDate: DateTime.now(),
                                    );
                                    if (date != null) {
                                      setDialogState(() {
                                        endDate =
                                            '${date.day}/${date.month}/${date.year}';
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          // Reset and Apply Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: Responsive.widthPercent(context, 25),
                                child: OutlinedButton(
                                  onPressed: () {
                                    setDialogState(() {
                                      selectedTransactionType = 'All';
                                      selectedCategory = 'All';
                                      startDate = '';
                                      endDate = '';
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 8,
                                    ),
                                    minimumSize: const Size(0, 32),
                                    backgroundColor: AppTheme.resetButtonColor,
                                    side: BorderSide.none,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: const Text(
                                    'Reset',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontFamily: 'Roboto Flex',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: Responsive.spacing(context, 12)),
                              SizedBox(
                                width: Responsive.widthPercent(context, 25),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Apply filters here
                                    setState(() {
                                      _filterType = selectedTransactionType;
                                      _filterCategory = selectedCategory;
                                      _filterStartDate = startDate;
                                      _filterEndDate = endDate;

                                      // Sync tab with transaction type
                                      if (_filterType == 'All') {
                                        _tabController.animateTo(0);
                                      } else if (_filterType == 'Earned') {
                                        _tabController.animateTo(1);
                                      } else if (_filterType == 'Redeemed') {
                                        _tabController.animateTo(2);
                                      }
                                    });
                                    Navigator.of(dialogContext).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 8,
                                    ),
                                    minimumSize: const Size(0, 32),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: const Text(
                                    'Apply',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Roboto Flex',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String selectedValue,
    Function(String) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontFamily: 'Roboto Flex',
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = option == selectedValue;
            return GestureDetector(
              onTap: () => onSelect(option),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : AppTheme.lightPink,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.lightPink,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black,
                      fontFamily: 'Roboto Flex',
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.borderCalendarColor, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value.isEmpty ? label : value,
                style: TextStyle(
                  fontSize: 12,
                  color: value.isEmpty ? Colors.grey[600] : Colors.black,
                  fontFamily: 'Roboto Flex',
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/images/calendar.svg',
              width: 18,
              height: 18,
            ),
          ],
        ),
      ),
    );
  }

  List<TransactionHistoryItem> _applyFilters(
    List<TransactionHistoryItem> source,
  ) {
    return source.where((item) {
      // Filter by Transaction Type
      if (_filterType == 'Earned' && item.collectedPoint <= 0) return false;
      if (_filterType == 'Redeemed' && item.collectedPoint >= 0) return false;

      // Filter by Category (Assuming Purchase = Earned, Reward = Redeemed for now as per logic)
      if (_filterCategory == 'Purchase' && item.collectedPoint <= 0) {
        return false;
      }
      if (_filterCategory == 'Reward' && item.collectedPoint >= 0) return false;

      // Filter by Date
      if (_filterStartDate.isNotEmpty || _filterEndDate.isNotEmpty) {
        try {
          final itemDate = DateTime.parse(item.txnDate);

          if (_filterStartDate.isNotEmpty) {
            final startParts = _filterStartDate.split('/');
            final start = DateTime(
              int.parse(startParts[2]),
              int.parse(startParts[1]),
              int.parse(startParts[0]),
            );
            if (itemDate.isBefore(start)) return false;
          }

          if (_filterEndDate.isNotEmpty) {
            final endParts = _filterEndDate.split('/');
            final end = DateTime(
              int.parse(endParts[2]),
              int.parse(endParts[1]),
              int.parse(endParts[0]),
              23,
              59,
              59,
            );
            if (itemDate.isAfter(end)) return false;
          }
        } catch (e) {
          debugPrint('Error parsing date for filter: $e');
        }
      }

      return true;
    }).toList();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.child,
    this.minHeight = 50.0,
    this.maxHeight = 50.0,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
