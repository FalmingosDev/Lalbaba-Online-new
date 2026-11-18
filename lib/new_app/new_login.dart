import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constantcolour.dart';
import 'new_constant_text_styles.dart';

// ============================================================
// CHECKOUT LOGIN POPUP
// ============================================================

class NewCheckoutLoginPopup extends StatefulWidget {
  const NewCheckoutLoginPopup({super.key});

  // ==========================================================
  // SHOW LOGIN POPUP
  // ==========================================================

  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,

      backgroundColor: Colors.transparent,

      builder: (context) {
        return const NewCheckoutLoginPopup();
      },
    );
  }

  @override
  State<NewCheckoutLoginPopup> createState() =>
      _NewCheckoutLoginPopupState();
}

class _NewCheckoutLoginPopupState
    extends State<NewCheckoutLoginPopup> {

  bool _showOtp = false;

  final TextEditingController _phoneController =
      TextEditingController();

  final List<TextEditingController> _otpControllers =
      List.generate(
        6,
        (_) => TextEditingController(),
      );

  final List<FocusNode> _otpFocusNodes =
      List.generate(
        6,
        (_) => FocusNode(),
      );

  @override
  void dispose() {
    _phoneController.dispose();

    for (final controller in _otpControllers) {
      controller.dispose();
    }

    for (final focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  // ==========================================================
  // MAIN BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),

      child: Container(
        width: double.infinity,

        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(context).size.height * 0.75,
        ),

        decoration: const BoxDecoration(
          color: HomeColors.surface,

          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26),
            topRight: Radius.circular(26),
          ),
        ),

        child: SafeArea(
          top: false,

          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              24, 12, 24, 24,
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                _buildDragHandle(),

                _buildTopSection(),

                _buildHeader(),

                const SizedBox(height: 28),

                if (_showOtp)
                  _buildOtpSection()
                else
                  _buildMobileSection(),

                const SizedBox(height: 24),

                _buildContinueButton(),

                const SizedBox(height: 20),

                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // DRAG HANDLE
  // ==========================================================

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,

        decoration: BoxDecoration(
          color: HomeColors.border,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // ==========================================================
  // BACK AND CLOSE BUTTON
  // ==========================================================

  Widget _buildTopSection() {
    return Row(
      children: [
        if (_showOtp)
          IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();

              setState(() {
                _showOtp = false;
              });
            },

            icon: const Icon(
              Icons.arrow_back,
              color: HomeColors.textPrimary,
            ),
          ),

        const Spacer(),

        Container(
          decoration: const BoxDecoration(
            color: HomeColors.background,
            shape: BoxShape.circle,
          ),

          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },

            icon: const Icon(
              Icons.close_rounded,
              color: HomeColors.textPrimary,
              size: 23,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // LOGIN HEADER
  // ==========================================================

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,

            decoration: const BoxDecoration(
              color: HomeColors.secondaryLight,
              shape: BoxShape.circle,
            ),

            child: Icon(
              _showOtp
                  ? Icons.verified_user_outlined
                  : Icons.phone_android_rounded,

              size: 36,

              color: HomeColors.secondary,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            _showOtp
                ? 'Verify OTP'
                : 'Login to Continue',

            textAlign: TextAlign.center,

            style: HomeTextStyles.largePrice.copyWith(
              color: HomeColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            _showOtp
                ? 'Enter your 6-digit verification code.'
                : 'Please login to complete your order.',

            textAlign: TextAlign.center,

            style: HomeTextStyles.body.copyWith(
              color: HomeColors.textSecondary,
              height: 1.5,
            ),
          ),

          if (_showOtp &&
              _phoneController.text.isNotEmpty) ...[
            const SizedBox(height: 6),

            Text(
              '+91 ${_phoneController.text}',

              style: HomeTextStyles.bodyEmphasis.copyWith(
                color: HomeColors.textPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================================
  // MOBILE NUMBER FIELD
  // ==========================================================

  Widget _buildMobileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'Mobile Number',

          style: HomeTextStyles.bodyEmphasis.copyWith(
            color: HomeColors.textPrimary,
          ),
        ),

        const SizedBox(height: 10),

        Container(
          height: 58,

          decoration: BoxDecoration(
            color: HomeColors.surface,

            borderRadius: BorderRadius.circular(10),

            border: Border.all(
              color: HomeColors.border,
            ),
          ),

          child: Row(
            children: [
              const SizedBox(width: 14),

              const Text(
                '🇮🇳',

                style: TextStyle(
                  fontSize: 22,
                ),
              ),

              const SizedBox(width: 8),

              Text(
                '+91',

                style:
                    HomeTextStyles.bodyEmphasis.copyWith(
                  color: HomeColors.textPrimary,
                ),
              ),

              const SizedBox(width: 12),

              Container(
                width: 1,
                height: 26,

                color: HomeColors.border,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: TextField(
                  controller: _phoneController,

                  keyboardType: TextInputType.phone,

                  cursorColor: HomeColors.secondary,

                  maxLength: 10,

                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],

                  style: HomeTextStyles.body.copyWith(
                    color: HomeColors.textPrimary,
                  ),

                  decoration: InputDecoration(
                    hintText: 'Enter mobile number',

                    hintStyle: HomeTextStyles.body.copyWith(
                      color: HomeColors.textHint,
                    ),

                    counterText: '',

                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,

                    contentPadding: const EdgeInsets.only(
                      right: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // OTP SECTION
  // ==========================================================

  Widget _buildOtpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'Enter OTP',

          style: HomeTextStyles.bodyEmphasis.copyWith(
            color: HomeColors.textPrimary,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: List.generate(
            6,

            (index) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == 5 ? 0 : 8,
                ),

                child: _buildOtpBox(index),
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        Center(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,

            children: [
              Text(
                "Didn't receive OTP? ",

                style: HomeTextStyles.bodySmall.copyWith(
                  color: HomeColors.textSecondary,
                ),
              ),

              GestureDetector(
                onTap: () {
                  // TODO: Connect Resend OTP API.
                },

                child: Text(
                  'Resend OTP',

                  style:
                      HomeTextStyles.bodyEmphasis.copyWith(
                    color: HomeColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // SINGLE OTP BOX
  // ==========================================================

  Widget _buildOtpBox(int index) {
    return SizedBox(
      height: 54,

      child: TextField(
        controller: _otpControllers[index],

        focusNode: _otpFocusNodes[index],

        keyboardType: TextInputType.number,

        textAlign: TextAlign.center,

        maxLength: 1,

        cursorColor: HomeColors.secondary,

        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],

        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 5) {
              _otpFocusNodes[index + 1].requestFocus();
            } else {
              FocusScope.of(context).unfocus();
            }
          } else if (index > 0) {
            _otpFocusNodes[index - 1].requestFocus();
          }
        },

        style: HomeTextStyles.sectionTitle.copyWith(
          color: HomeColors.textPrimary,
        ),

        decoration: InputDecoration(
          counterText: '',

          hintText: '-',

          hintStyle: HomeTextStyles.body.copyWith(
            color: HomeColors.textHint,
          ),

          contentPadding: EdgeInsets.zero,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),

            borderSide: const BorderSide(
              color: HomeColors.border,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),

            borderSide: const BorderSide(
              color: HomeColors.secondary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // SEND OTP / VERIFY BUTTON
  // UI ONLY
  // ==========================================================

Widget _buildContinueButton() {
  return SizedBox(
    width: double.infinity,
    height: 52,

    child: ElevatedButton(
      onPressed: () {
        FocusScope.of(context).unfocus();

        if (!_showOtp) {
          setState(() {
            _showOtp = true;
          });

        } else {
          // PAYMENT PAGE UI TESTING ONLY

          if (kDebugMode) {
            Navigator.of(context).pop(true);
          }

          // TODO: Connect actual OTP API.
        }
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: HomeColors.secondary,
        foregroundColor: HomeColors.white,
        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(
            _showOtp
                ? 'Verify & Continue'
                : 'Send OTP',

            style: HomeTextStyles.button.copyWith(
              color: HomeColors.white,
            ),
          ),

          const SizedBox(width: 8),

          const Icon(
            Icons.arrow_forward,
            size: 18,
          ),
        ],
      ),
    ),
  );
}
  // ==========================================================
  // SECURE CHECKOUT FOOTER
  // ==========================================================

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        const Icon(
          Icons.verified_user_outlined,

          color: HomeColors.secondary,

          size: 18,
        ),

        const SizedBox(width: 6),

        Text(
          'Safe and secure checkout',

          style: HomeTextStyles.caption.copyWith(
            color: HomeColors.textSecondary,
          ),
        ),
      ],
    );
  }
}