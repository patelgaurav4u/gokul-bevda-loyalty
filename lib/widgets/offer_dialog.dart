import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/theme.dart';
import '../utils/responsive.dart';
import '../models/offer_detail.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class OfferDialog extends StatefulWidget {
  final String saleId;
  final String note;

  const OfferDialog({super.key, required this.saleId, required this.note});

  @override
  State<OfferDialog> createState() => _OfferDialogState();
}

class _OfferDialogState extends State<OfferDialog> {
  late Future<OfferDetail?> _offerDetailFuture;
  int? selectedStoreIndex = 0;
  final ApiService _apiService = ApiService.create(baseUrl: ApiConfig.baseUrl);

  @override
  void initState() {
    super.initState();
    _offerDetailFuture = _apiService.getOfferDetails(widget.saleId);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(
        horizontal: Responsive.padding(context, 16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Material(
          color: Colors.white,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: Responsive.dialogWidth(context),
              maxHeight: Responsive.dialogMaxHeight(context),
            ),
            color: Colors.white,
            child: FutureBuilder<OfferDetail?>(
              future: _offerDetailFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primary,
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        'Error loading offer details',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: Text('Offer details not found')),
                  );
                }

                final offer = snapshot.data!;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // White header bar with close button
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Close icon aligned to right
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SvgPicture.asset(
                                'assets/images/close.svg',
                                width: 15,
                                height: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // White content area
                    Flexible(
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(
                          Responsive.padding(context, 16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Main offer title - centered (fixed)
                            Center(
                              child: Text(
                                offer.saleName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontFamily: 'Roboto Flex',
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Subtitle (fixed)
                            if (widget.note.isNotEmpty)
                              Center(
                                child: Text(
                                  widget.note,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.unselected_tab_color,
                                    fontFamily: 'Roboto Flex',
                                  ),
                                ),
                              ),
                            const SizedBox(height: 24),
                            // Special Offer Details Section (fixed)
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppTheme.semiDarkPink,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'SPECIAL OFFER DETAILS',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.primary,
                                        fontFamily: 'Roboto Flex',
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      offer.saleDetails.isNotEmpty
                                          ? offer.saleDetails
                                          : 'Check stores for availability',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                        color: AppTheme.unselected_tab_color,
                                        fontFamily: 'Roboto Flex',
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Available at these stores section (fixed)
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/store.svg',
                                  width: 22,
                                  height: 22,
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'Available at these stores',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily: 'Roboto Flex',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Store list - scrollable only
                            Flexible(
                              child: offer.stores.isEmpty
                                  ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text(
                                          'No stores available for this offer',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontFamily: 'Roboto Flex',
                                          ),
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: offer.stores.length,
                                      itemBuilder: (context, index) {
                                        final store = offer.stores[index];
                                        final isLast =
                                            index == offer.stores.length - 1;
                                        return Column(
                                          children: [
                                            _buildStoreItem(
                                              index,
                                              store.name,
                                              store.address,
                                              store.hours,
                                              store.phone,
                                              store.stock,
                                              selectedStoreIndex == index,
                                              index == 0,
                                              isLast,
                                              offer.stores.length,
                                              () {
                                                setState(() {
                                                  selectedStoreIndex = index;
                                                });
                                              },
                                            ),
                                            if (!isLast)
                                              const Divider(
                                                color: Color(0xFFCBCBCB),
                                                thickness: 1,
                                                height: 1,
                                              ),
                                          ],
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreItem(
    int index,
    String storeName,
    String address,
    String hours,
    String phone,
    String stock,
    bool isSelected,
    bool isFirst,
    bool isLast,
    int totalCount,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.lightPink : AppTheme.lightGray,
          border: isSelected
              ? const Border(
                  left: BorderSide(color: AppTheme.primary, width: 2),
                )
              : const Border(
                  left: BorderSide(color: Colors.transparent, width: 2),
                ),
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? const Radius.circular(8) : Radius.zero,
            topRight: isFirst ? const Radius.circular(8) : Radius.zero,
            bottomLeft: isLast ? const Radius.circular(8) : Radius.zero,
            bottomRight: isLast ? const Radius.circular(8) : Radius.zero,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location pin icon
            const SizedBox(width: 8),
            // Store details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store name - bold black
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/location.svg',
                        width: 17,
                        height: 17,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        storeName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'Roboto Flex',
                        ),
                      ),
                    ],
                  ),

                  // Address - smaller black (not gray)
                  Row(
                    children: [
                      SvgPicture.asset('', width: 17, height: 17),
                      const SizedBox(width: 7),
                      Text(
                        address,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.unselected_tab_color,
                          fontFamily: 'Roboto Flex',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  // Time and phone hours in a column
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hours with clock icon
                      Row(
                        children: [
                          const SizedBox(width: 4),
                          SvgPicture.asset(
                            'assets/images/time_small.svg',
                            width: 12,
                            height: 12,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            hours.isEmpty ? 'N/A' : hours,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.unselected_tab_color,
                              fontFamily: 'Roboto Flex',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      // Phone hours with phone icon,
                      Row(
                        children: [
                          const SizedBox(width: 4),
                          SvgPicture.asset(
                            'assets/images/phone.svg',
                            width: 12,
                            height: 12,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            phone.isEmpty ? 'N/A' : phone,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.unselected_tab_color,
                              fontFamily: 'Roboto Flex',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
