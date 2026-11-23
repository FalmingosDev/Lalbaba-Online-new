import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant/constantappbar.dart';
import '../constant/constantcolour.dart';
import '../constant/new_constant_text_styles.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  Future<void> _launchExternal(Uri uri) async {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open the requested app')),
      );
    }
  }

  Widget _contactBullet({
    required String label,
    required String value,
    required Uri uri,
  }) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 9),
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
          child: Text.rich(
            TextSpan(
              style: HomeTextStyles.body.copyWith(
                color: HomeColors.textSecondary,
                height: 1.55,
              ),
              children: [
                TextSpan(text: '$label '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: GestureDetector(
                    onTap: () => _launchExternal(uri),
                    child: Text(
                      value,
                      style: HomeTextStyles.body.copyWith(
                        color: HomeColors.secondary,
                        height: 1.55,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _emailPara(String before, String after) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text.rich(
      TextSpan(
        style: HomeTextStyles.body.copyWith(
          color: HomeColors.textSecondary,
          height: 1.6,
        ),
        children: [
          TextSpan(text: before),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: () => _launchExternal(
                Uri(scheme: 'mailto', path: 'support@lalbabaonline.com'),
              ),
              child: Text(
                'support@lalbabaonline.com',
                style: HomeTextStyles.body.copyWith(
                  color: HomeColors.secondary,
                  height: 1.6,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          TextSpan(text: after),
        ],
      ),
    ),
  );

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
              Icons.privacy_tip_outlined,
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

  Widget _subHeading(String text) => Padding(
    padding: const EdgeInsets.only(left: 4, top: 14, bottom: 8),
    child: Text(
      text,
      style: HomeTextStyles.bodyEmphasis.copyWith(color: HomeColors.secondary),
    ),
  );

  Widget _para(String text, {bool bold = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
      padding: bold ? const EdgeInsets.all(14) : EdgeInsets.zero,
      decoration: bold
          ? BoxDecoration(
              color: HomeColors.secondaryLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: HomeColors.secondary.withValues(alpha: 0.18),
              ),
            )
          : null,
      child: Text(
        text,
        style: HomeTextStyles.body.copyWith(
          color: bold ? HomeColors.textPrimary : HomeColors.textSecondary,
          height: 1.6,
          fontWeight: bold ? HomeTextStyles.semiBold : HomeTextStyles.regular,
        ),
      ),
    ),
  );

  Widget _bullet(String text) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 9),
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

  Widget _labeled(String label, String text) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 9),
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
        title: 'Privacy Policy',
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
                'BY ACCESSING THIS APPLICATION, YOU HEREBY CONSENT TO THE COLLECTION, RECEIPT, '
                'POSSESSION, STORAGE, DEALING AND HANDLING OF YOUR INFORMATION AS PER THIS PRIVACY '
                'POLICY. YOUR USE OF AND ACCESS TO THE MOBILE APPLICATION, CONSTITUTE YOUR CONSENT '
                'TO THE TERMS OF THIS PRIVACY POLICY (OR ANY RELATED AMENDMENT).',
                bold: true,
              ),
              _para(
                '“LALBABA ONLINE” is a web/mobile application (“App”) owned and operated by the '
                'company, Bhadreshwar Rice Mill (the ‘Company’). This privacy policy describes how '
                'the Company collects, uses, processes and discloses your information, in relation '
                'to your access to and use of our services (“Privacy Policy”).',
              ),
              _para(
                'This Privacy Policy is applicable to persons who access, browse or use the Lalbaba '
                'web/mobile application services (“Users”). For the purpose of this Policy, wherever '
                'the context so requires "you" or "your" shall have reference to User and the term '
                '"we", "us", "our" shall have reference to the Company.',
              ),
              _para(
                'The Company confirms that it is strongly committed in protecting your privacy and '
                'has taken all necessary and reasonable measures to protect your information and '
                'handle the same in a safe and responsible manner in accordance with this Privacy '
                'Policy.',
              ),
              _para(
                'This Privacy Policy is incorporated by reference into the Terms of Use.',
              ),

              // 1
              _heading('1. Collection and use of Information'),
              _para(
                'The information about the User as collected by the Company is: (a) information '
                'supplied by Users, (b) information automatically tracked while navigation and '
                '(c) information collected from any other source (collectively referred to as '
                '“Information”).',
              ),

              _subHeading('1.1 Information provided by Users'),
              _labeled(
                '(a)',
                'Once you have decided to register for the purpose of accessing and placing orders '
                    'through the web/mobile application, you may be required to create an account with '
                    'us by providing the following basic information or such other information as may '
                    'be requested while creating the account:',
              ),
              _bullet('Name'),
              _bullet('E-mail ID'),
              _bullet('Phone number(s)'),
              _bullet('Profile login ID and password'),
              _para(
                'The information we collect differs upon what kind of user you are. If you are an '
                'end customer/consumer, you provide us your above personal information. If you are '
                'a business visitor/franchisee/dealer, in addition to the above information, we may '
                'also collect your business information including GST number, PAN number etc.',
              ),
              _labeled(
                '(b)',
                'For all payment transactions made through the web/mobile application, our approved '
                    'payment gateway provider – Worldline/CCAVENUE/Cashfree may collect your purchase, '
                    'address or billing information, including your credit card number and expiration '
                    'date etc. All card payments are subject to authorisation by your card issuer and '
                    'are electronically processed by the payment gateway provider. We do not collect or '
                    'store any credit card information such as CVV, Expiry Date etc.',
              ),
              _labeled(
                '(c)',
                'Voluntary information: We may collect additional information at other times, '
                    'including but not limited to, when you provide feedback, comments, change your '
                    'content or email preferences, respond to a survey, or any communications with us.',
              ),

              _subHeading('1.2 Automatically collected information'),
              _para(
                'In addition to the information that you provide us directly, we also use '
                'technology like application programming interfaces (APIs) and embeds to make that '
                'information available in our database.',
              ),
              _labeled(
                '(a)',
                'Usage and Log Information – To make our web/mobile application more useful to you, '
                    'our servers (which may be hosted by a third-party service provider) collect '
                    'information from you, including your browser type, operating system, Internet '
                    'Protocol (IP) address (a number that is automatically assigned to your computer '
                    'when you use the Internet, which may vary from session to session), domain name, '
                    'and/or a date/time of your visit. We use this information to examine our traffic '
                    'and to view how our customers use our website. This type of information will not '
                    'allow you to be personally identified although we might be able to associate it '
                    'with your account.',
              ),
              _labeled(
                '(b)',
                'Third party information – We collect user information from third parties '
                    'especially tracking technologies to track the activity on our service and hold '
                    'certain information. Browser based, network based, ad-tracking and user UX '
                    'behaviour tracking information is collected from third parties. We collect '
                    'information to understand and track the behavioural as means for security and '
                    'connection integrity. We will keep such information for our reference and will '
                    'never share with any third party. Also, please remember that the manner in which '
                    'third-party services use, store and disclose your information is governed by the '
                    'policies of such third parties, and the Company shall have no liability or '
                    'responsibility for the privacy practices or other actions of any third party '
                    'services that may be enabled within the web/mobile application.',
              ),
              _labeled(
                '(c)',
                'Cookies – To improve the responsiveness of the web/mobile application for our '
                    'Users, we may use "cookies", or similar electronic tools to collect Information to '
                    'assign each visitor a unique, random number as a User Identification (User ID) to '
                    'understand the User\'s individual interests using the identified computer or '
                    'device. Unless you voluntarily identify yourself (through registration, for '
                    'example), we will have no way of knowing who you are, even if we assign a cookie '
                    'to your computer or device. The only personal information a cookie can contain is '
                    'information you supply. A cookie cannot read data off your hard drive or device. '
                    'Our advertisers and network partners may also assign their own cookies to your '
                    'browser (if you click on their ads etc.), a process that we do not control. We '
                    'receive and store certain types of Information whenever you interact with us via '
                    'our web/mobile application through your computer/laptop/netbook or '
                    'mobile/tablet/pad/handheld device etc.',
              ),
              _para(
                'Opting out – If you would like to opt-out of the technologies we employ on our '
                'applications or tools (as applicable) you may do so by blocking, deleting, or '
                'disabling them as your browser or device permits. If a User opts out using the Ads '
                'Settings, the unique DoubleClick cookie ID on the User\'s browser is overwritten '
                'with the phrase "OPT OUT". Because there is no longer a unique cookie ID, the '
                'opt-out cookie can\'t be associated with a particular browser.',
              ),

              _subHeading('1.3 Information from other sources'),
              _para(
                'We may receive Information about you from other sources, add it to our account '
                'information and treat it in accordance with this Privacy Policy.',
              ),
              _para(
                'Demographic and other information: We may reference other sources of demographic '
                'and other information in order to provide you with more targeted communications '
                'and promotions. We use various services including Google Analytics and many '
                'others, to track the user behaviour on our Sites. Google Analytics specifically '
                'has been enabled to support display advertising towards helping us gain '
                'understanding of our users\' demographics and interests. The reports are anonymous '
                'and cannot be associated with any individual personally identifiable information '
                'that you may have shared with us. You can opt-out of Google Analytics for display '
                'advertising and customize Google Display Network ads using the Ads Settings '
                'options provided by Google.',
              ),

              _subHeading('1.4 Use of Information'),
              _para(
                'The information so collected by the Company permits them to provide the user with '
                'a smooth, efficient, and customized experience. The information is used to enhance '
                'the visitor’s experience when using the website to display personalized content and '
                'possibly advertising. We may use the information we collect from you when you '
                'register, make a purchase, sign up for our newsletter, respond to a survey or '
                'marketing communication, surf the website, or use certain other features in the '
                'following ways:',
              ),
              _para(
                'The Company may use the information that it collects for the following purposes:',
              ),
              _bullet('Create and manage your account'),
              _bullet('To personalize your experience'),
              _bullet(
                'Compile anonymous statistical data and analysis for use internally',
              ),
              _bullet('Email you regarding your account or order'),
              _bullet('Enable user-to-user communications'),
              _bullet(
                'Increase the efficiency and operation of the Application',
              ),
              _bullet(
                'Request feedback and contact you about your use of the Application',
              ),
              _bullet('Resolve disputes and troubleshoot problems'),
              _bullet('Send you a newsletter'),
              _bullet('Assist law enforcement'),
              _bullet('Notify you of updates to the Application'),
              _bullet('Respond to product and customer service requests'),
              _bullet(
                'To administer a contest, promotion, survey or other web/mobile application feature',
              ),
              _bullet('To quickly process your transactions'),
              _bullet('To ask for ratings and reviews of services or products'),

              _subHeading('1.5 Disclosure of Information'),
              _para(
                'The Company may disclose Information to third parties including but not limited to '
                'lawyers, government officials etc. Below are the instances where such '
                'sharing/disclosure of personal data is permitted to third parties by us:',
              ),
              _bullet(
                'Law enforcement – We may share the Information, if necessary, to respond to legal '
                'process, for investigation purposes or remedy potential violations of our '
                'policies, or to protect the rights, property, and safety of others. We will ensure '
                'that sharing of Information shall be done in accordance with the permitted or '
                'required applicable law, rule, or regulation.',
              ),
              _bullet(
                'Service Provider – We may share the Information with third parties that perform '
                'services for us or on our behalf, including payment processing, email delivery, '
                'customer service, and marketing assistance.',
              ),

              // 2
              _heading('2. Security standards'),
              _para(
                'The Company safeguards the users’ privacy using known security standards and '
                'procedures and complies with applicable privacy laws. We take reasonable security '
                'measures to protect Information against loss, misuse, unauthorized or accidental '
                'access, disclosure, alteration and destruction. We implement policies and maintain '
                'appropriate technical, physical, and organizational measures and follow industry '
                'practices and standards in adopting procedures and implementing systems designed '
                'for securing and protecting Information. All information gathered is securely '
                'stored within the Company-controlled database. The database is stored on servers '
                'secured behind a firewall; access to the servers is password-protected and is '
                'strictly limited.',
              ),
              _emailPara(
                'However, as effective as our security measures are, no security system is '
                    'impenetrable. We cannot guarantee the security of our database, nor can we '
                    'guarantee that information you supply will not be intercepted while being '
                    'transmitted to us over the Internet. Any information you include in a posting to '
                    'the discussion areas is available to anyone with Internet access. If you have any '
                    'questions, doubts or confusion in regard to any of the terms set out in this '
                    'Privacy Policy, please seek clarifications from us through email at ',
                '. We assure to get back to you within reasonable time.',
              ),

              // 3
              _heading('3. Rights of Users'),
              _para(
                'The Company has an established mechanism to enable and facilitate exercise of data '
                'subject’s rights of access, blockage, erasure, opposition, rectification, and, '
                'where appropriate or required by applicable law. You may, at any time, review or '
                'change the information in your account or terminate your account by either logging '
                'into your account setting and updating your information or by contacting the '
                'grievance officer mentioned in Clause 7 below.',
              ),

              // 4
              _heading('4. Data storage and Retention policy'),
              _para(
                'We collect and store your data in AWS cloud as you use services and will retain '
                'the data for as long as necessary to fulfil the purposes for which it was '
                'obtained. Processed and non-identifiable data, if accessible, will be perpetually '
                'stored. Other heuristic data may be stored which may be identifiable data in '
                'cookies and through other mechanisms by third-party ad-tracking services like '
                'Facebook & Google.',
              ),
              _para(
                'To determine the appropriate retention period for personal data, we consider the '
                'amount, nature, and sensitivity of the personal data, the potential risk of harm '
                'from unauthorised use or disclosure of your personal data, the purposes for which '
                'we process your personal data and whether we can achieve those purposes through '
                'other means, and the applicable legal requirements.',
              ),
              _emailPara(
                'If you wish to delete your account or request that we no longer use your '
                    'information to provide you services, contact us at ',
                '. We '
                    'will respond to your request within reasonable time. We will retain and use your '
                    'information as necessary to comply with our legal obligations, resolve disputes '
                    'and enforce our agreements.',
              ),

              // 5
              _heading('5. Disclaimers'),
              _para(
                'When we collect Information, we will not consider the nationality or privacy '
                'rights granted to you by the concerned authorities. We are an Indian company and '
                'our privacy policy is based on Indian laws.',
              ),

              // 6
              _heading('6. Changes and updates to Privacy Policy'),
              _para(
                'The internet is an ever evolving medium. The Company reserves the right to modify '
                'this Privacy Policy from time to time to incorporate necessary changes in '
                'technology, applicable law or any other variant. In any case, we reserve the right '
                'to change (at any point of time) the terms of this Privacy Policy or the Terms of '
                'Use. Any changes we make will be effective immediately on notice, which we may '
                'give by posting the new policy on the Sites. Your use of the web/mobile '
                'application after such notice will be deemed acceptance of such changes. We may '
                'also make reasonable efforts to inform you via electronic mail. In any case, you '
                'are advised to review this Privacy Policy periodically on the web/mobile '
                'application to ensure that you are aware of the latest version.',
              ),

              // 7
              _heading('7. Grievances'),
              _para(
                'The Company has appointed Grievance Officers to redress complaints relating to '
                'privacy. If you have any grievances against the Company’s privacy practices, or '
                'have any apprehension that your privacy is compromised in the web/mobile '
                'application, then please address your complaint/concerns to:',
              ),
              _contactBullet(
                label: 'Phone Number:',
                value: '9933346117',
                uri: Uri(scheme: 'tel', path: '9933346117'),
              ),
              _contactBullet(
                label: 'Email ID:',
                value: 'support@lalbabaonline.com',
                uri: Uri(scheme: 'mailto', path: 'support@lalbabaonline.com'),
              ),
              const SizedBox(height: 8),
              _para(
                'We request you to please provide the following information in your complaint:',
              ),
              _labeled(
                'a)',
                'Identification of the information provided by you;',
              ),
              _labeled(
                'b)',
                'Clear statement as to whether the information is personal information or sensitive personal information;',
              ),
              _labeled(
                'c)',
                'Your address, telephone number or e-mail address;',
              ),
              _labeled(
                'd)',
                'A statement that you have a good-faith belief that the Information has been processed incorrectly or disclosed without authorization, as the case may be;',
              ),
              _labeled(
                'e)',
                'A statement, under penalty of perjury, that the information in the notice is accurate, and that the information being complained about belongs to you;',
              ),
              _labeled(
                'f)',
                'You may also contact us in case you have any questions / suggestions about the Privacy Policy using the contact information mentioned above.',
              ),
              _para(
                'We assure you that we will proactively address your concerns. We will attempt to '
                'address all legitimate complaints or requests within one month. Occasionally it '
                'may take us longer than a month if the user’s complaint/request is particularly '
                'complex or the user has made a number of complaints/requests. In that case, we '
                'will notify the user and keep you updated.',
              ),
              _para(
                'The Company may reach out to you to confirm or discuss certain details about your '
                'complaint and issues raised.',
              ),
              _para(
                'The Company shall not be responsible for any communication, if addressed, to any '
                'non-designated person in this regard.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
