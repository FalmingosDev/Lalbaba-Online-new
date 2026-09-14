import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';


// ==============================================================================
// CONTACT SUPPORT WIDGET
// "We're Here For You !" footer block with hours, email and phone.
// ==============================================================================

class ContactSupportWidget extends StatelessWidget {
  final String hours;
  final String email;
  final String phone;

  const ContactSupportWidget({
    super.key,
    this.hours = 'Mon to Sun: 8am - 8pm',
    this.email = 'support@lalbabaonline.com',
    this.phone = '+91 9933346117',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
      child: Column(
        children: [
          const Text(
            "We're Here For You !",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          Text(
            hours,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(width: 1, height: 34, color: AppColors.divider),
              Column(
                children: [
                  const Text(
                    'Call',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phone,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
