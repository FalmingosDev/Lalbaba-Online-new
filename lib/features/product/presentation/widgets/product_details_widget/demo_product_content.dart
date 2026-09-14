import '../../model/product_models.dart';


// ==============================================================================
// DEMO / PLACEHOLDER CONTENT
// ------------------------------------------------------------------------------
// Swap these out once the real product API is wired up. Kept in one place so
// product_list_page.dart doesn't get cluttered with copy text.
// ==============================================================================

// ---- Exact content matching the "Lalbaba Jeera Kathi" screenshots ----

const List<ProductSpecification> jeeraKathiSpecifications = [
  ProductSpecification(label: 'Model Name', value: 'Lalbaba Jeera Kathi Rice'),
  ProductSpecification(label: 'Rice Type', value: 'Jeera Kathi Rice'),
  ProductSpecification(label: 'Grain Size', value: 'Medium Grain'),
  ProductSpecification(label: 'Maximum Shelf Life', value: '36 Months'),
  ProductSpecification(
    label: 'Approximate Nutritional Value (Per 100 g, uncooked)',
    value: 'Calories: 340-360 kcal\n'
        'Protein: 6.0-7.0 g\n'
        'Carbohydrates: 77-80 g\n'
        'Total Fat: 0.5-1.0 g\n'
        'Dietary Fiber: 0.5-1.0 g\n'
        'Sugars: <1 g\n'
        'Sodium: <5 mg\n'
        'Calcium: 5-15 mg\n'
        'Iron: 0.5-1.5 mg\n\n'
        '*These values are indicative, based on standard polished white '
        'rice and common market benchmarks. Actual values may vary '
        'slightly depending on harvest and processing.',
  ),
];

const List<ProductReview> jeeraKathiReviews = [
  ProductReview(name: 'Guest', date: '05-02-2026', rating: 3, comment: 'very nice'),
  ProductReview(name: 'Guest', date: '05-02-2026', rating: 4, comment: 'good quality'),
  ProductReview(name: 'Guest', date: '05-02-2026', rating: 5, comment: 'Excellent'),
];

const List<ProductFaq> jeeraKathiFaqs = [
  ProductFaq(
    question:
        'What makes Jeera Kathi rice different from Miniket or Ratna rice?',
    answer:
        'Jeera Kathi rice has slightly slender grains with a mild aroma and '
        'softer texture compared to Miniket or Ratna rice. It cooks fluffy '
        'and separate, making it ideal for daily meals where you want '
        'light texture without strong fragrance.',
  ),
  ProductFaq(
    question: 'Is Jeera Kathi rice aromatic like Basmati?',
    answer:
        'No, Jeera Kathi rice has a mild natural aroma but is not strongly '
        'fragrant like aged basmati rice. It is preferred for regular '
        'home-style cooking rather than premium biryani preparations.',
  ),
  ProductFaq(
    question: 'Will the rice become sticky after cooking?',
    answer:
        'When cooked with the correct water ratio (1.25-1.5 cups water per '
        'cup of rice), Jeera Kathi rice remains soft yet separate. '
        'Overcooking or excess water may cause slight stickiness, so '
        'controlled simmering is recommended.',
  ),
  ProductFaq(
    question: 'Is this rice suitable for elderly people and children?',
    answer:
        'Yes. Due to its light texture and easy digestibility, Jeera '
        'Kathi rice is comfortable for daily consumption by both children '
        'and elderly family members.',
  ),
  ProductFaq(
    question: 'Does this rice expand well after cooking?',
    answer:
        'Yes. Jeera Kathi rice increases in volume when cooked and '
        'becomes soft and fluffy, making it economical for family meals '
        'and bulk preparation.',
  ),
  ProductFaq(
    question:
        'How do I cook Lalbaba Jeera Kathi Rice for fluffy, separate grains?',
    answer:
        'Rinse the rice until water runs clear, optionally soak 15-20 '
        'minutes, then use about 1.25-1.5 cups water per 1 cup rice '
        '(adjust by stove/pot). Cook on low simmer with a tight lid and '
        'rest 8-10 minutes off heat before fluffing.',
  ),
  ProductFaq(
    question: 'What pack sizes are available and can I buy in bulk?',
    answer:
        'Available pack sizes are listed on the product page. For bulk or '
        'wholesale purchases and special pricing, contact Lalbaba '
        'customer support or use the bulk-order enquiry option on the '
        'site.',
  ),
  ProductFaq(
    question: 'Can I use this rice for biryani, pulao, and other special dishes?',
    answer:
        "It's great for daily pulao and light pilafs and gives consistent "
        'results for everyday recipes. For very aromatic, long-grain '
        'biryanis you may prefer an aged basmati variety - use Jeera '
        'Kathi when you want milder flavor and firmer texture.',
  ),
];

const String jeeraKathiDescription =
    'Lalbaba Jeera Kathi Rice is a premium quality rice sourced from '
    'Bardhamman paddy fields and processed at Bhadreswar Rice Mills. This '
    'trusted Indian rice brand offers fluffy, separate grains with a mild '
    'aroma, ideal for everyday meals when you buy rice online from the '
    'Lalbaba online rice store. Competitive Jeera Kathi rice pricing and '
    'hygienic, HACCP-certified processing make it a reliable everyday '
    'choice for the whole family.';

const String jeeraKathiProcessedAt = 'Bhadreswar Rice Mills';

// ---- Generic fallback content for products without custom copy yet ----

List<ProductSpecification> genericSpecifications(String riceType) => [
      ProductSpecification(label: 'Rice Type', value: riceType),
      const ProductSpecification(label: 'Grain Size', value: 'Medium Grain'),
      const ProductSpecification(
        label: 'Maximum Shelf Life',
        value: '36 Months',
      ),
    ];

List<ProductFaq> genericFaqs(String riceName) => [
      ProductFaq(
        question: 'Is $riceName suitable for daily cooking?',
        answer:
            'Yes, $riceName is processed for everyday home cooking and '
            'cooks up soft and fluffy when prepared with the recommended '
            'water ratio.',
      ),
      ProductFaq(
        question: 'How should I store $riceName?',
        answer:
            'Store in a cool, dry place in an airtight container away '
            'from direct sunlight and moisture to preserve freshness.',
      ),
      ProductFaq(
        question: 'What pack sizes are available for $riceName?',
        answer:
            'Available pack sizes are listed on the product page. Contact '
            'Lalbaba customer support for bulk-order pricing.',
      ),
    ];

const List<ProductReview> genericReviews = [
  ProductReview(name: 'Guest', date: '05-02-2026', rating: 4, comment: 'good quality'),
  ProductReview(name: 'Guest', date: '05-02-2026', rating: 5, comment: 'Excellent'),
];

String genericDescription(String name) =>
    '$name is a premium quality rice, hygienically processed and packed '
    'to deliver fluffy, separate grains for your everyday meals. Order '
    'online from the Lalbaba online rice store for doorstep delivery.';

const String genericProcessedAt = 'Bhadreswar Rice Mills';
