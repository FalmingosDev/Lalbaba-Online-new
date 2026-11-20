import 'package:flutter/material.dart';
import 'package:lalbaba_online/new_app/constant/constantappbar.dart';
import 'package:lalbaba_online/new_app/constant/constantcolour.dart';
import 'package:lalbaba_online/new_app/constant/new_constant_text_styles.dart';



// ============================================================
// NEW ABOUT US PAGE
// ============================================================

class NewAboutUsPage extends StatelessWidget {
  const NewAboutUsPage({
    super.key, required String imageUrl,
  });

  // ==========================================================
  // ABOUT US NETWORK IMAGE
  // ==========================================================

  static const String _aboutImageUrl =
      'https://www.lalbabaonline.com/public/uploads/all/'
      'bGGGE26rwRBuaSOAcGyhqKN99wkkAfEttcudNtOb.webp';

  // ==========================================================
  // MAIN BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,

      // ======================================================
      // COMMON APP BAR
      // ======================================================

      appBar: const CommonAppBar(
        automaticallyImplyLeading: false,
        showBackButton: true,
        title: 'About Us',
        backgroundColor: HomeColors.secondary,
        titleColor: HomeColors.white,
        iconColor: HomeColors.white,
        titleFontSize: HomeTextStyles.sizeTitle,
      ),

      // ======================================================
      // BODY
      // ======================================================

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),

          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 900,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // ==========================================
                  // RESPONSIVE NETWORK IMAGE
                  // ==========================================

                  const _AboutBannerImage(
                    imageUrl: _aboutImageUrl,
                  ),

                  // ==========================================
                  // ABOUT CONTENT
                  // ==========================================

                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      24,
                      16,
                      32,
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // ====================================
                        // MAIN HEADING
                        // ====================================

                        Text(
                          'Bringing Pure Taste & Trusted Quality to Every Home',

                          style: HomeTextStyles.pageTitle.copyWith(
                            color: HomeColors.textPrimary,
                            height: 1.35,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Container(
                          width: 56,
                          height: 4,

                          decoration: BoxDecoration(
                            color: HomeColors.secondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // ====================================
                        // INTRODUCTION
                        // ====================================

                        const _AboutParagraph(
                          text:
                              'For decades, Lalbaba Rice has been a trusted '
                              'name in Indian households, delivering '
                              'premium-quality rice that combines tradition, '
                              'purity, and consistency. What began in 1994 '
                              'as a small rice mill founded by Mr. Sanat '
                              'Kumar Nandy and his sons, Parthasarathi Nandy '
                              'and Palash Nandy, has today grown into one of '
                              'the recognized rice brands committed to '
                              'excellence and innovation.',
                        ),

                        const SizedBox(height: 16),

                        const _AboutParagraph(
                          text:
                              'At Lalbaba Rice, we believe rice is more than '
                              'just a daily staple — it is an essential part '
                              'of every family meal, celebration, and '
                              'tradition. Our mission is to provide carefully '
                              'processed, nutritious, and flavorful rice '
                              'varieties that elevate every dining experience.',
                        ),

                        const SizedBox(height: 32),

                        // ====================================
                        // OUR JOURNEY
                        // ====================================

                        const _AboutSectionHeading(
                          title: 'Our Journey',
                          icon: Icons.history_edu_outlined,
                        ),

                        const SizedBox(height: 16),

                        const _AboutParagraph(
                          text:
                              'Established with a vision to redefine rice '
                              'processing standards, Lalbaba Rice expanded '
                              'rapidly with the commissioning of a modern '
                              'rice manufacturing facility in Burdwan in '
                              '2003. With continuous investments in advanced '
                              'technology, quality control, and customer '
                              'satisfaction, we have built a strong presence '
                              'across domestic and international markets.',
                        ),

                        const SizedBox(height: 16),

                        const _AboutParagraph(
                          text:
                              'Today, our multiple state-of-the-art processing '
                              'units are equipped with advanced machinery '
                              'and modern parboiling techniques that help '
                              'preserve the natural taste, aroma, and '
                              'nutritional value of every grain.',
                        ),

                        const SizedBox(height: 32),

                        // ====================================
                        // WHAT MAKES LALBABA RICE SPECIAL?
                        // ====================================

                        const _AboutSectionHeading(
                          title: 'What Makes Lalbaba Rice Special?',
                          icon: Icons.stars_outlined,
                        ),

                        const SizedBox(height: 18),

                        // FEATURE 1

                        const _AboutFeatureCard(
                          icon: Icons.verified_outlined,
                          title: 'Premium Quality Assurance',
                          description:
                              'Every grain undergoes strict quality checks '
                              'to ensure purity, consistency, and '
                              'superior taste.',
                        ),

                        const SizedBox(height: 12),

                        // FEATURE 2

                        const _AboutFeatureCard(
                          icon: Icons.grass_outlined,
                          title: 'Wide Variety of Rice',
                          description:
                              'From aromatic Basmati to flavorful Gobindobhog '
                              'and nutritious Minikit rice, we offer rice '
                              'varieties suitable for every meal and occasion.',
                        ),

                        const SizedBox(height: 12),

                        // FEATURE 3

                        const _AboutFeatureCard(
                          icon: Icons.precision_manufacturing_outlined,
                          title: 'Advanced Processing Technology',
                          description:
                              'Our scientific processing methods help retain '
                              'essential nutrients while maintaining '
                              'freshness and texture.',
                        ),

                        const SizedBox(height: 12),

                        // FEATURE 4

                        const _AboutFeatureCard(
                          icon: Icons.groups_outlined,
                          title: 'Trusted by Generations',
                          description:
                              'Lalbaba Rice has earned the trust of families '
                              'through years of quality commitment and '
                              'customer satisfaction.',
                        ),

                        const SizedBox(height: 12),

                        // FEATURE 5

                        const _AboutFeatureCard(
                          icon: Icons.favorite_outline,
                          title: 'Healthy & Nutritious Choice',
                          description:
                              'Our rice varieties are processed to support '
                              'balanced nutrition without compromising '
                              'authentic taste.',
                        ),

                        const SizedBox(height: 32),

                        // ====================================
                        // OUR COMMITMENT
                        // ====================================

                        const _AboutSectionHeading(
                          title: 'Our Commitment',
                          icon: Icons.handshake_outlined,
                        ),

                        const SizedBox(height: 16),

                        const _AboutParagraph(
                          text:
                              'We are committed to maintaining the highest '
                              'standards of quality, hygiene, and sustainability '
                              'at every stage — from sourcing and processing '
                              'to packaging and delivery. Our goal is to make '
                              'premium-quality rice easily accessible to '
                              'customers through a seamless online shopping '
                              'experience.',
                        ),

                        const SizedBox(height: 24),

                        // ====================================
                        // FINAL COMMITMENT MESSAGE
                        // ====================================

                        Container(
                          width: double.infinity,

                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 24,
                          ),

                          decoration: BoxDecoration(
                            color: HomeColors.secondaryLight,

                            borderRadius: BorderRadius.circular(14),

                            border: Border.all(
                              color: HomeColors.border,
                            ),
                          ),

                          child: Column(
                            children: [
                              const Icon(
                                Icons.spa_outlined,
                                color: HomeColors.secondary,
                                size: 34,
                              ),

                              const SizedBox(height: 14),

                              Text(
                                'With Lalbaba Rice, you don’t just buy rice — '
                                'you bring home tradition, trust, and excellence.',

                                textAlign: TextAlign.center,

                                style: HomeTextStyles.sectionTitle.copyWith(
                                  color: HomeColors.secondary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// RESPONSIVE ABOUT US NETWORK IMAGE
// ============================================================

class _AboutBannerImage extends StatelessWidget {
  final String imageUrl;

  const _AboutBannerImage({
    required this.imageUrl,
  });

  static const Color _background = HomeColors.secondaryLight;
  static const Color _iconColor = HomeColors.secondary;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      // Original About Us image proportion.
      aspectRatio: 1408 / 768,

      child: Container(
        width: double.infinity,
        color: _background,
        alignment: Alignment.center,

        child: Image.network(
          imageUrl,

          width: double.infinity,
          height: double.infinity,

          // Full image visible without cropping.
          fit: BoxFit.contain,

          alignment: Alignment.center,

          filterQuality: FilterQuality.medium,

          // ================================================
          // LOADING PLACEHOLDER
          // ================================================

          loadingBuilder: (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) {
              return child;
            }

            return const ColoredBox(
              color: _background,
              child: Center(
                child: CircularProgressIndicator(
                  color: _iconColor,
                  strokeWidth: 2,
                ),
              ),
            );
          },

          // ================================================
          // IMAGE ERROR
          // ================================================

          errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
          ) {
            debugPrint('About Us network image error: $error');

            return const ColoredBox(
              color: _background,

              child: Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: _iconColor,
                  size: 30,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// ABOUT SECTION HEADING
// ============================================================

class _AboutSectionHeading extends StatelessWidget {
  final String title;
  final IconData icon;

  const _AboutSectionHeading({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Container(
          width: 42,
          height: 42,

          alignment: Alignment.center,

          decoration: BoxDecoration(
            color: HomeColors.secondaryLight,
            borderRadius: BorderRadius.circular(10),
          ),

          child: Icon(
            icon,
            size: 23,
            color: HomeColors.secondary,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),

            child: Text(
              title,

              style: HomeTextStyles.sectionTitle.copyWith(
                color: HomeColors.textPrimary,
                height: 1.35,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// ABOUT PARAGRAPH
// ============================================================

class _AboutParagraph extends StatelessWidget {
  final String text;

  const _AboutParagraph({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,

      textAlign: TextAlign.start,
      softWrap: true,

      style: HomeTextStyles.body.copyWith(
        color: HomeColors.textSecondary,
        height: 1.75,
      ),
    );
  }
}

// ============================================================
// ABOUT FEATURE CARD
// ============================================================

class _AboutFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _AboutFeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: HomeColors.surface,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: HomeColors.border,
        ),

        boxShadow: [
          BoxShadow(
            color: HomeColors.black.withValues(alpha: 0.035),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 46,
            height: 46,

            alignment: Alignment.center,

            decoration: BoxDecoration(
              color: HomeColors.secondaryLight,
              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(
              icon,
              color: HomeColors.secondary,
              size: 25,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: HomeTextStyles.bodyEmphasis.copyWith(
                    color: HomeColors.textPrimary,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  description,

                  softWrap: true,

                  style: HomeTextStyles.bodySmall.copyWith(
                    color: HomeColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}