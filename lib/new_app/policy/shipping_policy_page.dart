import 'package:flutter/material.dart';

import '../constant/constantappbar.dart';
import '../constant/constantcolour.dart';
import '../constant/new_constant_text_styles.dart';

class ShippingPolicyPage extends StatefulWidget {
  const ShippingPolicyPage({super.key});

  @override
  State<ShippingPolicyPage> createState() => _ShippingPolicyPageState();
}

class _ShippingPolicyPageState extends State<ShippingPolicyPage> {
  Widget _heading(String text) => Padding(
    padding: const EdgeInsets.only(top: 18, bottom: 8),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: HomeColors.surface,
        border: Border.all(color: HomeColors.border),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: HomeColors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: HomeColors.secondaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: HomeColors.secondary,
              size: 19,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              text,
              style: HomeTextStyles.bodyEmphasis.copyWith(
                color: HomeColors.textPrimary,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _para(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: HomeTextStyles.body.copyWith(
        color: HomeColors.textSecondary,
        height: 1.6,
      ),
    ),
  );

  Widget _bullet(String text) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7, right: 10),
          child: Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: HomeColors.secondary,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: HomeTextStyles.body.copyWith(
              color: HomeColors.textSecondary,
              height: 1.55,
            ),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      appBar: const CommonAppBar(
        title: 'Shipping Policy',
        centerTitle: true,
        showBackButton: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _para(
                'Lalbaba Online, eCommerce platform for Bhadreswar Rice Mill is committed towards '
                'delivering your order with good quality packaging within the given time frame. We '
                'ship throughout the week except Sundays and Public holidays. To ensure that your '
                'order reaches you in good condition, in the promised span of time, we ship through '
                'reputed logistics agencies (e.g. Delhivery).',
              ),
              _para(
                'For any issues in utilizing our logistic services, you may contact our helpdesk on '
                '+91 9933346117 (10:00 AM to 5:00 PM, Monday to Saturday) or mail us at '
                'support@lalbabaonline.com.',
              ),

              _heading('Shipping & Charges'),
              _bullet(
                'Shipping is available within India at applicable shipping rates as may apply.',
              ),
              _bullet(
                'The shipping charge is based on the weight of the product. For multiple products ordered from the same category, the program adds up the weight of all the units ordered and charges a single delivery fee.',
              ),
              _bullet(
                'The weight of the product has been built into the delivery charge of each product. This will automatically be added to the product cost at the payment stage.',
              ),
              _bullet(
                'We sometimes offer “Free Delivery” as a promotional offer, which is displayed on the website.',
              ),

              _heading('Products & Dispatch'),
              _bullet(
                'All products that you see on the Lalbaba Online website are manufactured and stocked in our own warehouses and are ready to ship.',
              ),
              _bullet(
                'Products always carry the Bhadreswar Rice Mill logo, to ensure authenticity.',
              ),
              _bullet('Products are dispatched within a day.'),

              _heading('Delivery Time'),
              _bullet(
                'Once shipped, please allow 3 to 7 business days to deliver within India.',
              ),

              _heading('Delays'),
              _bullet(
                'In case of any delay in dispatch due to any natural calamity, public holiday or any unforeseen circumstance, we shall not be liable to exchange the goods.',
              ),
              _bullet(
                'In case of delay in dispatch due to the product being out of stock, we may contact you through e-mail / phone. You may then choose to wait, choose alternate products, or opt for a refund.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
