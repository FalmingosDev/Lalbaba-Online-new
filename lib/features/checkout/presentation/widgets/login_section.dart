import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_colors.dart';

class LoginPage
    extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage>
      createState() =>
          _LoginPageState();
}

class _LoginPageState
    extends State<LoginPage> {
  final TextEditingController
      _mobileController =
      TextEditingController();

  bool _receiveCommunication =
      true;

  bool _isLoading = false;

  // ============================================================
  // VALID MOBILE
  // ============================================================

  bool get _isValidMobile {
    final String mobile =
        _mobileController.text
            .trim();

    return mobile.length == 10;
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _mobileController
        .addListener(
      _mobileNumberChanged,
    );
  }

  // ============================================================
  // MOBILE CHANGE
  // ============================================================

  void _mobileNumberChanged() {
    setState(() {});
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _mobileController
        .removeListener(
      _mobileNumberChanged,
    );

    _mobileController.dispose();

    super.dispose();
  }

  // ============================================================
  // SEND OTP
  // ============================================================

  Future<void> _sendOtp() async {
    if (!_isValidMobile ||
        _isLoading) {
      return;
    }

    FocusScope.of(context)
        .unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      final String mobile =
          _mobileController.text
              .trim();

      final String phoneNumber =
          '+91$mobile';

      debugPrint(
        'Send OTP: $phoneNumber',
      );

      debugPrint(
        'Receive Communication: '
        '$_receiveCommunication',
      );

      // ========================================================
      // TODO:
      // Ekhane OTP API call korben.
      //
      // Example:
      //
      // await AuthService.sendOtp(
      //   mobile: mobile,
      // );
      //
      // Tarpor OTP verification page open korben.
      // ========================================================

      await Future.delayed(
        const Duration(
          milliseconds: 400,
        ),
      );

      if (!mounted) {
        return;
      }

      // TODO:
      // OTP page ready hole ekhane navigate korben.
      //
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) =>
      //         OtpVerificationPage(
      //       mobileNumber: mobile,
      //     ),
      //   ),
      // );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          Colors.white,

      body: SafeArea(
        child:
            SingleChildScrollView(
          child: Column(
            children: [
              // =================================================
              // HEADER
              // =================================================

              Container(
                width:
                    double.infinity,
                padding:
                    const EdgeInsets
                        .fromLTRB(
                  12,
                  12,
                  12,
                  14,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      Colors.white,
                  border: Border(
                    bottom:
                        BorderSide(
                      color: Colors
                          .grey.shade200,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child:
                          RichText(
                        text:
                            const TextSpan(
                          style:
                              TextStyle(
                            fontSize:
                                18,
                            color:
                                Colors.black,
                            height:
                                1.2,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'Login',
                              style:
                                  TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w700,
                              ),
                            ),

                            TextSpan(
                              text:
                                  ' with your mobile number',
                              style:
                                  TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      borderRadius:
                          BorderRadius
                              .circular(
                        20,
                      ),
                      child:
                          const Padding(
                        padding:
                            EdgeInsets
                                .all(
                          6,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 21,
                          color:
                              Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // =================================================
              // FORM
              // =================================================

              Padding(
                padding:
                    const EdgeInsets
                        .fromLTRB(
                  40,
                  20,
                  40,
                  30,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    // =============================================
                    // MOBILE FIELD
                    // =============================================

                    Container(
                      height: 52,
                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white,
                        border:
                            Border.all(
                          color: Colors
                              .grey
                              .shade400,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets
                                    .only(
                              left: 10,
                            ),
                            child: Text(
                              '+91',
                              style:
                                  TextStyle(
                                fontSize:
                                    13,
                                fontWeight:
                                    FontWeight
                                        .w600,
                                color:
                                    Colors.grey,
                              ),
                            ),
                          ),

                          Container(
                            height: 20,
                            width: 1,
                            margin:
                                const EdgeInsets
                                    .symmetric(
                              horizontal:
                                  4,
                            ),
                            color: Colors
                                .grey
                                .shade300,
                          ),

                          Expanded(
                            child:
                                TextField(
                              controller:
                                  _mobileController,

                              keyboardType:
                                  TextInputType
                                      .phone,

                              maxLength:
                                  10,

                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly,
                                LengthLimitingTextInputFormatter(
                                  10,
                                ),
                              ],

                              style:
                                  const TextStyle(
                                fontSize:
                                    13,
                                color:
                                    Colors.black87,
                              ),

                              decoration:
                                  InputDecoration(
                                counterText:
                                    '',

                                hintText:
                                    'Enter your mobile number',

                                hintStyle:
                                    TextStyle(
                                  fontSize:
                                      12,
                                  color: Colors
                                      .grey
                                      .shade400,
                                ),

                                border:
                                    InputBorder
                                        .none,

                                contentPadding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal:
                                      2,
                                  vertical:
                                      15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // =============================================
                    // COMMUNICATION CHECKBOX
                    // =============================================

                    InkWell(
                      onTap: () {
                        setState(() {
                          _receiveCommunication =
                              !_receiveCommunication;
                        });
                      },
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                Checkbox(
                              value:
                                  _receiveCommunication,

                              onChanged:
                                  (value) {
                                setState(
                                  () {
                                    _receiveCommunication =
                                        value ??
                                            false;
                                  },
                                );
                              },

                              activeColor:
                                  const Color(
                                0xFF246FDB,
                              ),

                              materialTapTargetSize:
                                  MaterialTapTargetSize
                                      .shrinkWrap,

                              visualDensity:
                                  VisualDensity
                                      .compact,
                            ),
                          ),

                          const SizedBox(
                            width: 5,
                          ),

                          Expanded(
                            child:
                                Text(
                              'Receive communications from us on messages',
                              style:
                                  TextStyle(
                                fontSize:
                                    11.5,
                                color: Colors
                                    .grey
                                    .shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 22,
                    ),

                    // =============================================
                    // SEND OTP
                    // =============================================

                    SizedBox(
                      width:
                          double.infinity,
                      height: 47,
                      child:
                          ElevatedButton(
                        onPressed:
                            _isValidMobile &&
                                    !_isLoading
                                ? _sendOtp
                                : null,

                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              AppColors
                                  .primary,

                          disabledBackgroundColor:
                              const Color(
                            0xFFB5B7BA,
                          ),

                          foregroundColor:
                              Colors.white,

                          disabledForegroundColor:
                              Colors.white,

                          elevation:
                              0,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              5,
                            ),
                          ),
                        ),

                        child: _isLoading
                            ? const SizedBox(
                                width:
                                    20,
                                height:
                                    20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth:
                                      2,
                                  color:
                                      Colors.white,
                                ),
                              )
                            : const Text(
                                'SEND OTP',
                                style:
                                    TextStyle(
                                  fontSize:
                                      13,
                                  fontWeight:
                                      FontWeight
                                          .w500,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}