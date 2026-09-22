import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';

import 'checkout_constant_widget.dart';
import 'checkout_product_page.dart';
import 'checkout_continue_button_widget.dart';

/// ============================================================================
/// DELIVERY TYPE
/// ============================================================================
enum DeliveryType {
  homeDelivery,
  localPickup,
}

/// ============================================================================
/// PICKUP POINT MODEL
/// ============================================================================
class PickupPoint {
  final String name;
  final String address;
  final String phone;

  const PickupPoint({
    required this.name,
    required this.address,
    required this.phone,
  });
}

/// ============================================================================
/// DELIVERY WIDGET
/// ============================================================================
class DeliveryWidget extends StatefulWidget {
  final VoidCallback onContinueToPayment;

  final List<PickupPoint>? pickupPoints;

  const DeliveryWidget({
    super.key,
    required this.onContinueToPayment,
    this.pickupPoints,
  });

  @override
  State<DeliveryWidget> createState() => _DeliveryWidgetState();
}

class _DeliveryWidgetState extends State<DeliveryWidget> {
  /// ==========================================================================
  /// DEFAULT = HOME DELIVERY
  /// ==========================================================================
  DeliveryType _selectedDeliveryType = DeliveryType.homeDelivery;

  PickupPoint? _selectedPickupPoint;

  OverlayEntry? _overlayEntry;

  bool _isDropdownOpen = false;

  final LayerLink _layerLink = LayerLink();

  final GlobalKey _dropdownKey = GlobalKey();

  final TextEditingController _searchController =
      TextEditingController();

  /// ==========================================================================
  /// SAMPLE PICKUP POINT DATA
  /// ==========================================================================
  static const List<PickupPoint> _defaultPickupPoints = [
    PickupPoint(
      name: 'Office Premises Store',
      address:
          'City Tower, Ground Floor 70, G.T. Road, Badamtala More',
      phone: '9999988888',
    ),
    PickupPoint(
      name: 'Main Warehouse',
      address:
          'Main Road, Kolkata, West Bengal',
      phone: '9876543210',
    ),
    PickupPoint(
      name: 'Local Pickup Store',
      address:
          'Station Road, Kolkata, West Bengal',
      phone: '9123456789',
    ),
  ];

  List<PickupPoint> get _pickupPoints {
    return widget.pickupPoints ?? _defaultPickupPoints;
  }

  /// ==========================================================================
  /// CONTINUE BUTTON
  /// ==========================================================================
  bool get _canContinue {
    if (_selectedDeliveryType ==
        DeliveryType.homeDelivery) {
      return true;
    }

    return _selectedPickupPoint != null;
  }

  @override
  void dispose() {
    _removePickupDropdown(
      updateState: false,
    );

    _searchController.dispose();

    super.dispose();
  }

  /// ==========================================================================
  /// MAIN BUILD
  /// ==========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (
            BuildContext context,
            BoxConstraints constraints,
          ) {
            /// Small phone হলে padding একটু কমবে
            final double horizontalPadding =
                constraints.maxWidth <= 360
                    ? 12
                    : AppSizes.screenPadding;

            return Column(
              children: [
                /// ============================================================
                /// SCROLLABLE CONTENT
                /// ============================================================
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      AppSizes.screenPadding,
                      horizontalPadding,
                      AppSizes.spacingLarge,
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        /// ====================================================
                        /// CHECKOUT CONSTANT STEPPER
                        /// ====================================================
                        const CheckoutConstantWidget(
                          currentStep:
                              CheckoutStep.delivery,
                        ),

                        SizedBox(
                          height:
                              AppSizes.spacingXLarge,
                        ),

                        /// ====================================================
                        /// PRODUCT WIDGET
                        /// ====================================================
                        const CheckoutProductWidget(),

                        SizedBox(
                          height:
                              AppSizes.spacingXLarge,
                        ),

                        /// ====================================================
                        /// DELIVERY SECTION
                        /// ====================================================
                        _buildDeliverySection(),

                        SizedBox(
                          height:
                              AppSizes.spacingLarge,
                        ),
                      ],
                    ),
                  ),
                ),

                /// ============================================================
                /// EXISTING BOTTOM CONSTANT WIDGET
                /// ============================================================
                CheckoutBottomWidget(
                  continueButtonText:
                      'Continue to Payment',
                  isEnabled: _canContinue,
                  onContinue:
                      widget.onContinueToPayment,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// ==========================================================================
  /// DELIVERY SECTION
  /// ==========================================================================
  Widget _buildDeliverySection() {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(
        AppSizes.spacingLarge,
      ),

      decoration: BoxDecoration(
        color: AppColors.surface,

        borderRadius: BorderRadius.circular(
          AppSizes.radiusLarge,
        ),

        border: Border.all(
          color: AppColors.divider,
        ),

        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          /// ================================================================
          /// TOP DIVIDER
          /// ================================================================
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.divider,
          ),

          SizedBox(
            height: AppSizes.spacingLarge,
          ),

          /// ================================================================
          /// TITLE
          /// ================================================================
          const Text(
            'Choose Delivery Type',
            softWrap: true,
            style: TextStyle(
              fontSize: 22,
              height: 1.25,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(
            height: AppSizes.spacingLarge,
          ),

          /// ================================================================
          /// RESPONSIVE DELIVERY BUTTONS
          /// ================================================================
          LayoutBuilder(
            builder: (
              BuildContext context,
              BoxConstraints constraints,
            ) {
              /// ------------------------------------------------------------
              /// Small phone / increased font size
              /// ------------------------------------------------------------
              ///
              /// Side-by-side রাখলে text কাটতে পারে।
              /// তাই narrow screen-এ vertically দেখানো হবে।
              ///
              final bool useVerticalLayout =
                  constraints.maxWidth < 340;

              if (useVerticalLayout) {
                return Column(
                  children: [
                    /// HOME DELIVERY
                    SizedBox(
                      width: double.infinity,
                      child: _DeliveryTypeCard(
                        title: 'Home Delivery',
                        selected:
                            _selectedDeliveryType ==
                                DeliveryType
                                    .homeDelivery,
                        onTap:
                            _selectHomeDelivery,
                      ),
                    ),

                    SizedBox(
                      height:
                          AppSizes.spacingMedium,
                    ),

                    /// LOCAL PICKUP
                    SizedBox(
                      width: double.infinity,
                      child: _DeliveryTypeCard(
                        title: 'Local Pickup',
                        selected:
                            _selectedDeliveryType ==
                                DeliveryType
                                    .localPickup,
                        onTap:
                            _selectLocalPickup,
                      ),
                    ),
                  ],
                );
              }

              /// ------------------------------------------------------------
              /// NORMAL / LARGE PHONE
              /// ------------------------------------------------------------
              return Row(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _DeliveryTypeCard(
                      title: 'Home Delivery',
                      selected:
                          _selectedDeliveryType ==
                              DeliveryType
                                  .homeDelivery,
                      onTap:
                          _selectHomeDelivery,
                    ),
                  ),

                  SizedBox(
                    width:
                        AppSizes.spacingMedium,
                  ),

                  Expanded(
                    child: _DeliveryTypeCard(
                      title: 'Local Pickup',
                      selected:
                          _selectedDeliveryType ==
                              DeliveryType
                                  .localPickup,
                      onTap:
                          _selectLocalPickup,
                    ),
                  ),
                ],
              );
            },
          ),

          /// ================================================================
          /// LOCAL PICKUP FIELD
          /// ================================================================
          if (_selectedDeliveryType ==
              DeliveryType.localPickup) ...[
            SizedBox(
              height:
                  AppSizes.spacingLarge,
            ),

            _buildPickupField(),
          ],
        ],
      ),
    );
  }

  /// ==========================================================================
  /// SELECT HOME DELIVERY
  /// ==========================================================================
  void _selectHomeDelivery() {
    _removePickupDropdown();

    setState(() {
      _selectedDeliveryType =
          DeliveryType.homeDelivery;

      _selectedPickupPoint = null;
    });
  }

  /// ==========================================================================
  /// SELECT LOCAL PICKUP
  /// ==========================================================================
  void _selectLocalPickup() {
    setState(() {
      _selectedDeliveryType =
          DeliveryType.localPickup;
    });
  }

  /// ==========================================================================
  /// PICKUP FIELD
  /// ==========================================================================
  Widget _buildPickupField() {
    return CompositedTransformTarget(
      link: _layerLink,

      child: GestureDetector(
        key: _dropdownKey,

        behavior:
            HitTestBehavior.opaque,

        onTap: () {
          if (_isDropdownOpen) {
            _removePickupDropdown();
          } else {
            _showPickupDropdown();
          }
        },

        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),

          width: double.infinity,

          /// Fixed height দেওয়া হয়নি।
          /// Text wrap হলে field automatically বড় হবে।
          constraints:
              const BoxConstraints(
            minHeight: 58,
          ),

          padding:
              EdgeInsets.symmetric(
            horizontal:
                AppSizes.spacingMedium,
            vertical: 12,
          ),

          decoration: BoxDecoration(
            color: AppColors.surface,

            borderRadius:
                BorderRadius.circular(
              AppSizes.radiusSmall,
            ),

            border: Border.all(
              color: _isDropdownOpen
                  ? AppColors.primary
                  : AppColors.border,
              width:
                  _isDropdownOpen
                      ? 1.5
                      : 1,
            ),
          ),

          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              /// ============================================================
              /// TEXT
              /// ============================================================
              Expanded(
                child:
                    _selectedPickupPoint ==
                            null
                        ? const Text(
                            'Select your nearest pickup point',

                            /// No ellipsis
                            softWrap: true,

                            style:
                                TextStyle(
                              fontSize:
                                  15,
                              height:
                                  1.3,
                              color: AppColors
                                  .textSecondary,
                            ),
                          )
                        : Column(
                            mainAxisSize:
                                MainAxisSize
                                    .min,

                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [
                              /// STORE NAME
                              Text(
                                _selectedPickupPoint!
                                    .name,

                                softWrap:
                                    true,

                                style:
                                    const TextStyle(
                                  fontSize:
                                      14,
                                  height:
                                      1.3,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                  color: AppColors
                                      .textPrimary,
                                ),
                              ),

                              const SizedBox(
                                height:
                                    4,
                              ),

                              /// ADDRESS
                              Text(
                                _selectedPickupPoint!
                                    .address,

                                softWrap:
                                    true,

                                style:
                                    const TextStyle(
                                  fontSize:
                                      12,
                                  height:
                                      1.35,
                                  color: AppColors
                                      .textSecondary,
                                ),
                              ),
                            ],
                          ),
              ),

              const SizedBox(
                width: 8,
              ),

              /// ============================================================
              /// ARROW
              /// ============================================================
              AnimatedRotation(
                turns:
                    _isDropdownOpen
                        ? 0.5
                        : 0,

                duration:
                    const Duration(
                  milliseconds: 180,
                ),

                child: const Icon(
                  Icons
                      .keyboard_arrow_down_rounded,
                  size: 27,
                  color:
                      AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ==========================================================================
  /// SHOW PICKUP DROPDOWN
  /// ==========================================================================
  void _showPickupDropdown() {
    final BuildContext? fieldContext =
        _dropdownKey.currentContext;

    if (fieldContext == null) {
      return;
    }

    final RenderBox? renderBox =
        fieldContext.findRenderObject()
            as RenderBox?;

    if (renderBox == null) {
      return;
    }

    final Size fieldSize =
        renderBox.size;

    _searchController.clear();

    setState(() {
      _isDropdownOpen = true;
    });

    _overlayEntry = OverlayEntry(
      builder: (
        BuildContext overlayContext,
      ) {
        final String query =
            _searchController.text
                .trim()
                .toLowerCase();

        final List<PickupPoint>
            filteredPoints =
            _pickupPoints.where(
          (PickupPoint point) {
            if (query.isEmpty) {
              return true;
            }

            return point.name
                    .toLowerCase()
                    .contains(query) ||
                point.address
                    .toLowerCase()
                    .contains(query) ||
                point.phone
                    .contains(query);
          },
        ).toList();

        return Stack(
          children: [
            /// ============================================================
            /// OUTSIDE CLICK
            /// ============================================================
            Positioned.fill(
              child: GestureDetector(
                behavior:
                    HitTestBehavior
                        .translucent,
                onTap:
                    _removePickupDropdown,
                child: Container(
                  color:
                      Colors.transparent,
                ),
              ),
            ),

            /// ============================================================
            /// DROPDOWN
            /// ============================================================
            CompositedTransformFollower(
              link: _layerLink,

              showWhenUnlinked: false,

              offset: Offset(
                0,
                fieldSize.height + 4,
              ),

              child: Material(
                color:
                    Colors.transparent,

                child: Container(
                  width:
                      fieldSize.width,

                  constraints:
                      const BoxConstraints(
                    maxHeight: 360,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        AppColors.surface,

                    borderRadius:
                        BorderRadius.circular(
                      AppSizes
                          .radiusSmall,
                    ),

                    border:
                        Border.all(
                      color:
                          AppColors.border,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: AppColors
                            .black
                            .withValues(
                          alpha: 0.12,
                        ),
                        blurRadius:
                            15,
                        offset:
                            const Offset(
                          0,
                          5,
                        ),
                      ),
                    ],
                  ),

                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      /// ==================================================
                      /// SEARCH
                      /// ==================================================
                      Padding(
                        padding:
                            const EdgeInsets
                                .all(10),

                        child:
                            TextField(
                          controller:
                              _searchController,

                          autofocus:
                              true,

                          onChanged:
                              (String value) {
                            _overlayEntry
                                ?.markNeedsBuild();
                          },

                          style:
                              const TextStyle(
                            fontSize:
                                14,
                            color: AppColors
                                .textPrimary,
                          ),

                          decoration:
                              InputDecoration(
                            hintText:
                                'Search pickup point',

                            hintStyle:
                                const TextStyle(
                              fontSize:
                                  14,
                              color: AppColors
                                  .textSecondary,
                            ),

                            prefixIcon:
                                const Icon(
                              Icons.search,
                              size: 21,
                              color: AppColors
                                  .textSecondary,
                            ),

                            contentPadding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal:
                                  12,
                              vertical:
                                  12,
                            ),

                            enabledBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                AppSizes
                                    .radiusSmall,
                              ),
                              borderSide:
                                  const BorderSide(
                                color:
                                    AppColors
                                        .border,
                              ),
                            ),

                            focusedBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                AppSizes
                                    .radiusSmall,
                              ),
                              borderSide:
                                  const BorderSide(
                                color:
                                    AppColors
                                        .primary,
                                width:
                                    1.4,
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// ==================================================
                      /// HEADER
                      /// ==================================================
                      Container(
                        width:
                            double.infinity,

                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),

                        color:
                            AppColors.primary,

                        child:
                            const Text(
                          'Select your nearest pickup point',

                          /// Full text
                          softWrap: true,

                          style:
                              TextStyle(
                            fontSize:
                                14,
                            height:
                                1.3,
                            fontWeight:
                                FontWeight
                                    .w500,
                            color:
                                AppColors.white,
                          ),
                        ),
                      ),

                      /// ==================================================
                      /// PICKUP LIST
                      /// ==================================================
                      Flexible(
                        child:
                            filteredPoints
                                    .isEmpty
                                ? const Padding(
                                    padding:
                                        EdgeInsets
                                            .all(
                                      20,
                                    ),
                                    child:
                                        Text(
                                      'No pickup point found',
                                      textAlign:
                                          TextAlign
                                              .center,
                                      softWrap:
                                          true,
                                      style:
                                          TextStyle(
                                        fontSize:
                                            13,
                                        color: AppColors
                                            .textSecondary,
                                      ),
                                    ),
                                  )
                                : ListView
                                    .separated(
                                    padding:
                                        EdgeInsets
                                            .zero,

                                    shrinkWrap:
                                        true,

                                    itemCount:
                                        filteredPoints
                                            .length,

                                    separatorBuilder:
                                        (
                                      BuildContext
                                          context,
                                      int index,
                                    ) {
                                      return const Divider(
                                        height:
                                            1,
                                        color:
                                            AppColors
                                                .divider,
                                      );
                                    },

                                    itemBuilder:
                                        (
                                      BuildContext
                                          context,
                                      int index,
                                    ) {
                                      return _buildPickupItem(
                                        filteredPoints[
                                            index],
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(
      context,
      rootOverlay: true,
    ).insert(
      _overlayEntry!,
    );
  }

  /// ==========================================================================
  /// PICKUP ITEM
  /// ==========================================================================
  Widget _buildPickupItem(
    PickupPoint point,
  ) {
    final bool isSelected =
        _selectedPickupPoint == point;

    return Material(
      color: isSelected
          ? AppColors.primaryLight
          : AppColors.surface,

      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPickupPoint =
                point;
          });

          _removePickupDropdown();
        },

        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(
            12,
            11,
            12,
            12,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              /// ============================================================
              /// STORE NAME
              /// ============================================================
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      point.name,

                      /// Full store name
                      softWrap: true,

                      style:
                          const TextStyle(
                        fontSize: 14,
                        height: 1.3,
                        fontWeight:
                            FontWeight.w700,
                        color: AppColors
                            .textPrimary,
                      ),
                    ),
                  ),

                  if (isSelected) ...[
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Icons.check_circle,
                      size: 19,
                      color:
                          AppColors.primary,
                    ),
                  ],
                ],
              ),

              const SizedBox(
                height: 8,
              ),

              /// ============================================================
              /// ADDRESS
              /// ============================================================
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.only(
                      top: 1,
                    ),
                    child: Icon(
                      Icons
                          .location_on_outlined,
                      size: 19,
                      color: AppColors
                          .textSecondary,
                    ),
                  ),

                  const SizedBox(
                    width: 6,
                  ),

                  Expanded(
                    child: Text(
                      point.address,

                      /// Full address
                      softWrap: true,

                      style:
                          const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 7,
              ),

              /// ============================================================
              /// PHONE
              /// ============================================================
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.phone_outlined,
                    size: 18,
                    color: AppColors
                        .textSecondary,
                  ),

                  const SizedBox(
                    width: 6,
                  ),

                  Expanded(
                    child: Text(
                      point.phone,

                      softWrap: true,

                      style:
                          const TextStyle(
                        fontSize: 13,
                        height: 1.3,
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ==========================================================================
  /// REMOVE DROPDOWN
  /// ==========================================================================
  void _removePickupDropdown({
    bool updateState = true,
  }) {
    _overlayEntry?.remove();

    _overlayEntry = null;

    if (updateState &&
        mounted &&
        _isDropdownOpen) {
      setState(() {
        _isDropdownOpen = false;
      });
    } else {
      _isDropdownOpen = false;
    }
  }
}

/// ============================================================================
/// DELIVERY TYPE CARD
/// ============================================================================
class _DeliveryTypeCard
    extends StatelessWidget {
  final String title;

  final bool selected;

  final VoidCallback onTap;

  const _DeliveryTypeCard({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius:
            BorderRadius.circular(
          AppSizes.radiusSmall,
        ),

        child: AnimatedContainer(
          duration:
              const Duration(
            milliseconds: 180,
          ),

          /// IMPORTANT:
          /// fixed height removed.
          ///
          /// Text যত line লাগবে,
          /// card automatically বড় হবে।
          constraints:
              const BoxConstraints(
            minHeight: 72,
          ),

          padding:
              EdgeInsets.symmetric(
            horizontal:
                AppSizes.spacingMedium,
            vertical: 14,
          ),

          decoration:
              BoxDecoration(
            color: AppColors.surface,

            borderRadius:
                BorderRadius.circular(
              AppSizes.radiusSmall,
            ),

            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.border,
              width:
                  selected ? 1.5 : 1,
            ),
          ),

          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              /// ============================================================
              /// RADIO
              /// ============================================================
              Container(
                width: 23,
                height: 23,

                padding:
                    const EdgeInsets.all(
                  5,
                ),

                decoration:
                    BoxDecoration(
                  shape:
                      BoxShape.circle,

                  border:
                      Border.all(
                    color: selected
                        ? AppColors.primary
                        : AppColors.border,
                    width: 1.4,
                  ),
                ),

                child:
                    AnimatedContainer(
                  duration:
                      const Duration(
                    milliseconds:
                        180,
                  ),

                  decoration:
                      BoxDecoration(
                    shape:
                        BoxShape.circle,

                    color: selected
                        ? AppColors.primary
                        : Colors.transparent,
                  ),
                ),
              ),

              SizedBox(
                width:
                    AppSizes.spacingMedium,
              ),

              /// ============================================================
              /// FULL TEXT
              /// ============================================================
              Expanded(
                child: Text(
                  title,

                  /// NO maxLines
                  /// NO ellipsis
                  softWrap: true,

                  style:
                      const TextStyle(
                    fontSize: 15,
                    height: 1.3,
                    fontWeight:
                        FontWeight.w600,
                    color: AppColors
                        .textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}