import 'package:flutter/material.dart';

class HomeTextStyles {
  HomeTextStyles._();

  static const double sizeCaption = 12;
  static const double sizeSmall = 13;
  static const double sizeBody = 14;
  static const double sizeProduct = 15;
  static const double sizePrice = 16;
  static const double sizeSummaryTotal = 17;
  static const double sizeSection = 18;
  static const double sizeSectionLarge = 19;
  static const double sizeTitle = 20;
  static const double sizePriceLarge = 23;
  static const double sizeRating = 28;

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  static const TextStyle appBarTitle = TextStyle(
    fontSize: sizeTitle,
    fontWeight: semiBold,
  );
  static const TextStyle productAppBarTitle = TextStyle(
    fontSize: sizeProduct,
    fontWeight: medium,
  );
  static const TextStyle appBarSubtitle = TextStyle(
    fontSize: sizeSmall,
    fontWeight: bold,
  );
  static const TextStyle pageTitle = TextStyle(
    fontSize: sizeTitle,
    fontWeight: bold,
  );
  static const TextStyle sectionTitle = TextStyle(
    fontSize: sizeSection,
    fontWeight: bold,
  );
  static const TextStyle sectionTitleLarge = TextStyle(
    fontSize: sizeSectionLarge,
    fontWeight: bold,
  );
  static const TextStyle productTitle = TextStyle(
    fontSize: sizeProduct,
    fontWeight: semiBold,
  );
  static const TextStyle productCardTitle = TextStyle(
    fontSize: sizeSmall,
    fontWeight: semiBold,
  );
  static const TextStyle body = TextStyle(
    fontSize: sizeBody,
    fontWeight: regular,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: sizeSmall,
    fontWeight: regular,
  );
  static const TextStyle bodyEmphasis = TextStyle(
    fontSize: sizeBody,
    fontWeight: semiBold,
  );
  static const TextStyle caption = TextStyle(
    fontSize: sizeCaption,
    fontWeight: regular,
  );
  static const TextStyle chip = TextStyle(
    fontSize: sizeCaption,
    fontWeight: semiBold,
  );
  static const TextStyle price = TextStyle(
    fontSize: sizePrice,
    fontWeight: bold,
  );
  static const TextStyle largePrice = TextStyle(
    fontSize: sizePriceLarge,
    fontWeight: bold,
  );
  static const TextStyle rating = TextStyle(
    fontSize: sizeRating,
    fontWeight: bold,
  );
  static const TextStyle button = TextStyle(
    fontSize: sizeProduct,
    fontWeight: semiBold,
  );
  static const TextStyle compactButton = TextStyle(
    fontSize: sizeCaption,
    fontWeight: semiBold,
  );
  static const TextStyle summaryLabel = TextStyle(
    fontSize: sizeBody,
    fontWeight: medium,
  );
  static const TextStyle summaryTotalLabel = TextStyle(
    fontSize: sizeSummaryTotal,
    fontWeight: bold,
  );
  static const TextStyle summaryValue = TextStyle(
    fontSize: sizeBody,
    fontWeight: bold,
  );
  static const TextStyle summaryTotalValue = TextStyle(
    fontSize: sizeSection,
    fontWeight: bold,
  );
}
