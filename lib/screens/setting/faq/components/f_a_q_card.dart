import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/setting/model/faq_model.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

class FAQCard extends StatelessWidget {
  final FAQModel faqData;

  const FAQCard({super.key, required this.faqData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: boxDecorationDefault(color: cardColor, borderRadius: radius(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(faqData.question, style: boldTextStyle()),
          8.height,
          readMoreTextWidget(faqData.answer),
        ],
      ),
    );
  }
}