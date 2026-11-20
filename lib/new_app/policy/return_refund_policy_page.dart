import 'package:flutter/material.dart';

import '../constant/constantappbar.dart';
import '../constant/constantcolour.dart';
import '../constant/new_constant_text_styles.dart';

class ReturnRefundPolicyPage extends StatefulWidget {
  const ReturnRefundPolicyPage({super.key});

  @override
  State<ReturnRefundPolicyPage> createState() => _ReturnRefundPolicyPageState();
}

class _ReturnRefundPolicyPageState extends State<ReturnRefundPolicyPage> {
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
              Icons.assignment_return_outlined,
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

  Widget _labeled(String label, String text, {double indent = 4}) => Padding(
    padding: EdgeInsets.only(left: indent, bottom: 9),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(minWidth: 30),
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: HomeColors.secondaryLight,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: HomeTextStyles.caption.copyWith(
              color: HomeColors.secondary,
              fontWeight: HomeTextStyles.bold,
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
        title: 'Return & Refund Policy',
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
                '“Lalbaba Online” is a web/mobile application (“App”) owned and operated by the '
                'company, Bhadreshwar Rice Mill (the ‘Company’). This return policy describes the '
                'terms and conditions to return a product that is bought using the web/mobile '
                'application (“Return Policy”).',
              ),
              _para(
                'This Return Policy is applicable to persons who have purchased a product by using '
                'the Bhadreshwar mobile application services (“Users”). For the purpose of this '
                'Return Policy, wherever the context so requires "you" or "your" shall have '
                'reference to User and the term "we", "us", "our" shall have reference to the '
                'Company.',
              ),
              _para(
                'We at Bhadreswar Rice have made it our mission to ensure that the shopping '
                'experience of our Users is seamless and enjoyable. Therefore, as a part of our '
                'commitment to customer satisfaction, if the User is not satisfied with his/her '
                'purchase of a product through this App, they have the liberty to return the '
                'product within 7 days of receiving that product. Such return shall however be in '
                'accordance with the terms mentioned in this Return Policy.',
              ),
              _para(
                'This Return Policy is incorporated by reference into the Lalbaba Terms of Use. '
                'Unless otherwise mentioned in this Return Policy, all other terms and conditions '
                'provided in the ‘Terms of Use’ shall be applicable to the User.',
              ),

              // 1
              _heading('1. Standard Return Policy'),
              _para(
                'A product bought through this web/mobile application is eligible to be returned to '
                'the Company in accordance with the following terms and conditions:',
              ),
              _labeled(
                '1.1',
                'The product intended to be returned has been bought using the web/mobile application.',
              ),
              _labeled(
                '1.2',
                'The Company shall not accept any return of products purchased through other online '
                    'platforms (third party or otherwise) or from retail stores. All such products '
                    'purchased from retail stores or through online platforms shall be returned in '
                    'accordance with their return and refund policy.',
              ),
              _labeled(
                '1.3',
                'The product intended to be returned has been received by the User not more than 7 '
                    'days back (‘Return window’).',
              ),
              _labeled(
                '1.4',
                'Any product, unless specifically marked as ‘unreturnable’, can be returned within '
                    'the Return Window in the following circumstances. Products will be termed as '
                    '‘Eligible Products’ if the purpose of their return is within one of the below '
                    'circumstances:',
              ),
              _labeled(
                '(a)',
                'The product was received by the User with damaged packaging including leakage.',
                indent: 28,
              ),
              _labeled(
                '(b)',
                'The product was received by the User with proper packaging but damaged content and is expired.',
                indent: 28,
              ),
              _labeled(
                '(c)',
                'The User has received a different product.',
                indent: 28,
              ),
              _labeled(
                '(d)',
                'The product does not have the characteristics or features as advertised.',
                indent: 28,
              ),
              _labeled(
                '(e)',
                'The products were delivered late from the stated delivery schedule, unless such '
                    'delay was communicated to the User or such delay was due to reasons beyond the '
                    'control of the Company and has been communicated to the User by the Company.',
                indent: 28,
              ),

              // 2
              _heading('2. Process of Return'),
              _labeled(
                '2.1',
                'A return process can be initiated by the User by either:',
              ),
              _labeled(
                '(i)',
                'clicking on the ‘return’ tab in the Order history and selecting the reason for '
                    'return from the dropdown menu. The ‘return’ tab shall be available only during '
                    'the duration of the Return Window, after which it shall be automatically '
                    'disabled; or',
                indent: 28,
              ),
              _labeled(
                '(ii)',
                'writing an email to support@lalbabaonline.com explaining the reasons for the '
                    'return of the products by attaching the relevant documents (e.g. invoice); or',
                indent: 28,
              ),
              _labeled(
                '(iii)',
                'directly contacting customer care for support in this matter, and being guided '
                    'accordingly.',
                indent: 28,
              ),
              _labeled(
                '2.2',
                'Once the request for the return of an Eligible Product has been lodged, as per '
                    'Clause 2.1 above, the User can be requested to send images of the damaged or '
                    'defective product received, the invoice or billing details of the products or any '
                    'further documents by our personnel.',
              ),
              _labeled(
                '2.3',
                'In certain circumstances our personnel may need to schedule a visit/call/chat to '
                    'assess the damage or defect in the product or provide any sort of assistance for '
                    'the purpose of returning their products. A return schedule shall be fixed between '
                    'our personnel and the User.',
              ),
              _labeled(
                '2.4',
                'On acceptance of the return request, Users shall keep the product ready, in its '
                    'original condition, along with brand outer box, MRP tags and invoice attached, '
                    'for a successful return pick up by us.',
              ),
              _labeled(
                '2.5',
                'Shipping – All shipping costs associated with the returning of the products in '
                    'accordance with this Return Policy shall be borne by the Company.',
              ),

              // 3
              _heading('3. Refund Procedure'),
              _labeled(
                '3.1',
                'Once an Eligible Product is received by us, the condition shall be inspected by us.',
              ),
              _labeled(
                '3.2',
                'On a successful return, the User will receive a notification acknowledging such '
                    'return and a confirmation of refund within the period provided hereunder.',
              ),
              _labeled(
                '3.3',
                'Refunds will be sent to the User’s original method of payment.',
              ),
              _labeled(
                '3.4',
                'Please allow at least seven (7) days from our receipt of the returned product to '
                    'process the refund. Refunds may take 1–2 billing cycles to post to Users’ credit '
                    'card statement, depending on their bank policy.',
              ),
              _labeled(
                '3.5',
                'We will notify the User by email/SMS when the refund has been processed.',
              ),

              // 4
              _heading('4. Other important points'),
              _labeled(
                '4.1',
                'Products marked as "non-returnable" on the product detail page cannot be returned.',
              ),
              _labeled(
                '4.2',
                'An Eligible Product, if requested, may be eligible for replacement, at the discretion of the Company.',
              ),
              _labeled(
                '4.3',
                'If a replacement is requested by the User but the Company does not have the exact same product in stock, a refund would be issued to the User.',
              ),
              _labeled(
                '4.4',
                'Users shall not be entitled to return products which were damaged due to mishandling by them or their representatives.',
              ),
              _labeled(
                '4.5',
                'A return request where the User has placed the order for a wrong product or wrong quantity or disliked the products after its purchase will not be entertained.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
