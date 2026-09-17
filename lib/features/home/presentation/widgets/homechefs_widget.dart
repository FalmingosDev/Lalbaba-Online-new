import 'dart:async';

import 'package:flutter/material.dart';

import '../../../account/presentation/widgets/app_string.dart';
import '../../../account/presentation/widgets/languange_constant.dart';

class TestimonialWidget
    extends StatefulWidget {
  final ValueChanged<int>?
      onReviewTap;

  const TestimonialWidget({
    super.key,
    this.onReviewTap,
  });

  @override
  State<TestimonialWidget>
      createState() =>
          _TestimonialWidgetState();
}

class _TestimonialWidgetState
    extends State<
        TestimonialWidget> {
  static const Color _navy =
      Color(0xFF1E2A6E);

  static const Color _black =
      Color(0xFF212121);

  static const Color _grey =
      Color(0xFF6B6B6B);

  static const List<
          Map<String, String>>
      _reviews = [
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/pZbNxM9gJAzjo8IdurZClyu6VmIiK7FX39jNrg4j.webp',
      'quote':
          'We loved the overall experience. The food is scrumptious! They were very courteous. We are regular customers now.',
      'name':
          'Jharna Bose (Homemaker)',
    },
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/bURkWLeNCHrdLRsGW9HZHCIhPhvN6NbfT0kAnRLf.webp',
      'quote':
          'Good products, the company is very professional and helpful. Quick solution for the smallest problem.',
      'name':
          'Sana Khan (Homemaker)',
    },
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/HiUcgKV7lcSs2SHhulqBb7ukhTY844mqzYl8fNnZ.webp',
      'quote':
          'As a caterer, consistency is everything. Lalbaba\'s quality never wavers — always reliable.',
      'name':
          'Priya Sharma (Catering Manager)',
    },
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/k7XzoAL0hBmbXGiBggtgObemLqZs0Y44HbEdaUec.webp',
      'quote':
          'Perfect for biryani and pulao — long, consistent grains that give restaurant-style results at home.',
      'name':
          'Rajiv Mehra (Home Chef)',
    },
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/rf8rf1loASwSeArbhayRZ7vZJepqwzJClfiOjEzw.webp',
      'quote':
          'Quick to cook and rice stays soft — my kids ask for Lalbaba rice every day.',
      'name':
          'Neha Roy (Homemaker)',
    },
    {
      'imageUrl':
          'https://lalbabaonline.com/public/uploads/all/Omd0y1GhNijua9gvV33wwGjpSYDnaJtdFHc9elRX.webp',
      'quote':
          'Excellent value — fragrant, non-sticky rice that my small restaurant customers love.',
      'name':
          'Subhajit Chatterjee (Restaurant Owner)',
    },
  ];

  late final PageController
      _pageController;

  Timer? _autoScrollTimer;

  late final int _initialPage;

  int get _reviewCount =>
      _reviews.length;

  @override
  void initState() {
    super.initState();

    _initialPage =
        _reviewCount > 0
            ? 10000 -
                (10000 %
                    _reviewCount)
            : 0;

    _pageController =
        PageController(
      initialPage:
          _initialPage,
      viewportFraction:
          0.86,
    );

    if (_reviewCount > 1) {
      _autoScrollTimer =
          Timer.periodic(
        const Duration(
          seconds: 4,
        ),
        (_) => _goToNext(),
      );
    }
  }

  void _goToNext() {
    if (!_pageController
            .hasClients ||
        _reviewCount <= 1) {
      return;
    }

    final int currentPage =
        _pageController
                .page
                ?.round() ??
            _initialPage;

    _pageController
        .animateToPage(
      currentPage + 1,
      duration:
          const Duration(
        milliseconds: 500,
      ),
      curve:
          Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _autoScrollTimer
        ?.cancel();

    _pageController
        .dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    if (_reviewCount == 0) {
      return const SizedBox
          .shrink();
    }

    return AnimatedBuilder(
      animation:
          AppLanguageConstants
              .instance,
      builder: (
        context,
        child,
      ) {
        return Padding(
          padding:
              const EdgeInsets
                  .fromLTRB(
            14,
            24,
            14,
            16,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              // =================================================
              // HEADER
              // =================================================

              Row(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Container(
                    width: 4,
                    height: 48,
                    decoration:
                        BoxDecoration(
                      color:
                          _navy,
                      borderRadius:
                          BorderRadius
                              .circular(
                        10,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          AppStrings
                              .happyHomeChefs,
                          style:
                              const TextStyle(
                            fontSize:
                                17,
                            fontWeight:
                                FontWeight
                                    .bold,
                            color:
                                _black,
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        Text(
                          AppStrings
                              .homeChefsSubtitle,
                          maxLines:
                              2,
                          overflow:
                              TextOverflow
                                  .ellipsis,
                          style:
                              const TextStyle(
                            fontSize:
                                12,
                            height:
                                1.35,
                            fontWeight:
                                FontWeight
                                    .w500,
                            color:
                                _grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 36,
                    height: 36,
                    decoration:
                        BoxDecoration(
                      color: _navy
                          .withValues(
                        alpha:
                            0.08,
                      ),
                      shape:
                          BoxShape
                              .circle,
                    ),
                    child:
                        const Icon(
                      Icons
                          .format_quote_rounded,
                      color:
                          _navy,
                      size: 21,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 14,
              ),

              // =================================================
              // REVIEW CAROUSEL
              // =================================================

              SizedBox(
                height: 285,
                child:
                    PageView.builder(
                  controller:
                      _pageController,
                  itemCount:
                      100000,

                  clipBehavior:
                      Clip.hardEdge,

                  padEnds: false,

                  itemBuilder: (
                    context,
                    pageIndex,
                  ) {
                    final int index =
                        pageIndex %
                            _reviewCount;

                    final review =
                        _reviews[
                            index];

                    return Padding(
                      padding:
                          const EdgeInsets
                              .only(
                        right: 12,
                      ),
                      child:
                          GestureDetector(
                        onTap: () {
                          widget
                              .onReviewTap
                              ?.call(
                            index,
                          );
                        },
                        child:
                            _ReviewCard(
                          imageUrl:
                              review[
                                  'imageUrl']!,
                          quote:
                              review[
                                  'quote']!,
                          name:
                              review[
                                  'name']!,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ===========================================================================
// REVIEW CARD
// ===========================================================================

class _ReviewCard
    extends StatelessWidget {
  final String imageUrl;
  final String quote;
  final String name;

  const _ReviewCard({
    required this.imageUrl,
    required this.quote,
    required this.name,
  });

  static const Color _navy =
      Color(0xFF1E2A6E);

  static const Color _black =
      Color(0xFF212121);

  static const Color _grey =
      Color(0xFF666666);

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color:
              const Color(
            0xFFEEEEEE,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(
              alpha: 0.06,
            ),
            blurRadius: 10,
            offset:
                const Offset(
              0,
              4,
            ),
          ),
        ],
      ),
      clipBehavior:
          Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(
            height: 145,
            width:
                double.infinity,
            child: Stack(
              fit:
                  StackFit.expand,
              children: [
                _ReviewImage(
                  imageUrl:
                      imageUrl,
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child:
                      Container(
                    width: 34,
                    height: 34,
                    decoration:
                        BoxDecoration(
                      color:
                          Colors.white,
                      shape:
                          BoxShape
                              .circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors
                              .black
                              .withValues(
                            alpha:
                                0.12,
                          ),
                          blurRadius:
                              6,
                        ),
                      ],
                    ),
                    child:
                        const Icon(
                      Icons
                          .format_quote_rounded,
                      color:
                          _navy,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets
                      .fromLTRB(
                14,
                12,
                14,
                12,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    '“$quote”',
                    maxLines:
                        3,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        const TextStyle(
                      fontSize:
                          12.5,
                      height:
                          1.4,
                      color:
                          _grey,
                      fontWeight:
                          FontWeight
                              .w500,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    height: 1,
                    color:
                        const Color(
                      0xFFEEEEEE,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    name,
                    maxLines:
                        1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        const TextStyle(
                      fontSize:
                          13,
                      fontWeight:
                          FontWeight
                              .w800,
                      color:
                          _black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// REVIEW IMAGE
// ===========================================================================

class _ReviewImage
    extends StatelessWidget {
  final String imageUrl;

  const _ReviewImage({
    required this.imageUrl,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Image.network(
      imageUrl,
      fit:
          BoxFit.cover,
      width:
          double.infinity,
      height:
          double.infinity,
      loadingBuilder: (
        context,
        child,
        progress,
      ) {
        if (progress ==
            null) {
          return child;
        }

        return Container(
          color:
              const Color(
            0xFFEDEFF7,
          ),
        );
      },
      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return Container(
          color:
              const Color(
            0xFFEDEFF7,
          ),
          alignment:
              Alignment.center,
          child:
              const Icon(
            Icons
                .person_outline_rounded,
            color:
                Color(
              0xFF1E2A6E,
            ),
            size: 30,
          ),
        );
      },
    );
  }
}