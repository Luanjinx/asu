// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import 'colors.dart';
import 'common_functions.dart';

class PriceWidget extends StatelessWidget {
  final num price;
  final String? priceText;
  final num? discountedPrice;
  final double? size;
  final Color? color;
  final Color? hourlyTextColor;
  final bool isBoldText;
  final bool isSemiBoldText;
  final bool isExtraBoldText;
  final bool isLineThroughEnabled;
  final bool isDiscountedPrice;
  final bool isPercentage;
  final String formatedPrice;
  final num discount;

  const PriceWidget({
    super.key,
    required this.price,
    this.size = 16.0,
    this.color,
    this.hourlyTextColor,
    this.isLineThroughEnabled = false,
    this.isBoldText = true,
    this.isSemiBoldText = false,
    this.isExtraBoldText = false,
    this.isDiscountedPrice = false,
    this.isPercentage = false,
    this.priceText,
    this.discount = 0,
    this.discountedPrice,
    this.formatedPrice = "",
  });

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle({int? aSize, bool isOriginalPrice = false}) {
      // Apply line-through decoration only for the original price when a discount exists
      bool applyLineThrough = isOriginalPrice && isDiscountedPrice;

      // If it's the original price and a discount exists, apply secondaryTextStyle with line-through
      if (applyLineThrough) {
        return TextStyle(
          fontSize: aSize?.toDouble() ?? size,
          color: color ?? darkGrayTextColor,
        );
      }

      // For discounted price or normal price, return appropriate styles
      if (isSemiBoldText) {
        return commonPrimaryTextStyle(
          size: aSize ?? size!.toInt(),
          color: color ?? appColorPrimary,
        );
      }
      if (isExtraBoldText) {
        return boldTextStyle(
          size: aSize ?? size!.toInt(),
          color: color ?? context.primaryColor,
          decoration: null,
        );
      }

      return isBoldText
          ? boldTextStyle(
              size: aSize ?? size!.toInt(),
              color: color ?? context.primaryColor,
            )
          : commonSecondaryTextStyle(
              size: aSize ?? size!.toInt(),
              color: color ?? context.primaryColor,
            );
    }

    String formatCurrency(num value) {
      // 1. Format with fixed decimals
      String valueStr = value.toStringAsFixed(appCurrency.value.noOfDecimal);

      // 2. Split into integer and fraction parts
      List<String> parts = valueStr.split('.');
      String integerPart = parts[0];
      String fractionPart = parts.length > 1 ? parts[1] : '';

      // 3. Format integer part with thousand separator
      RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      String mathFunc(Match match) => '${match[1]}${appCurrency.value.thousandSeparator}';
      integerPart = integerPart.replaceAllMapped(reg, mathFunc);

      // 4. Rejoin with decimal separator
      String formattedValue = integerPart;
      if (fractionPart.isNotEmpty) {
        formattedValue += '${appCurrency.value.decimalSeparator}$fractionPart';
      }

      return "${isPercentage ? '' : leftCurrencyFormat()}$formattedValue${isPercentage ? '' : rightCurrencyFormat()}";
    }

    final String formattedDiscountedPrice = formatCurrency(discountedPrice.validate());
    final String formattedOriginalPrice = formatCurrency(price);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isDiscountedPrice && discount != 0 && discountedPrice != null) ...[
          // Discounted price
          Text(
            formattedDiscountedPrice,
            style: _textStyle(),
          ),
          8.width, // Add spacing
          Stack(
            children: [
              Text(
                formattedOriginalPrice,
                style: _textStyle(isOriginalPrice: true),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 2,
                    color: color ?? darkGrayTextColor,
                  ),
                ),
              )
            ],
          ),
        ] else ...[
          Text(
            priceText ?? formattedOriginalPrice,
            style: _textStyle(),
          ),
        ],
        if (isPercentage)
          Text(
            '%',
            style: _textStyle(),
          ),
      ],
    );
  }
}

String leftCurrencyFormat() {
  if (isCurrencyPositionLeft || isCurrencyPositionLeftWithSpace) {
    return isCurrencyPositionLeftWithSpace ? '${appCurrency.value.currencySymbol} ' : appCurrency.value.currencySymbol;
  }
  return '';
}

String rightCurrencyFormat() {
  if (isCurrencyPositionRight || isCurrencyPositionRightWithSpace) {
    return isCurrencyPositionRightWithSpace ? ' ${appCurrency.value.currencySymbol}' : appCurrency.value.currencySymbol;
  }
  return '';
}