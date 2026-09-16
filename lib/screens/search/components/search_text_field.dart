import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/search/search_controller.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../../main.dart';
import '../../../utils/colors.dart';

class SearchTextFieldComponent extends StatelessWidget {
  const SearchTextFieldComponent({super.key, required this.searchCont});

  final SearchScreenController searchCont;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          AppTextField(
            textStyle: commonPrimaryTextStyle(size: 14),
            controller: searchCont.searchCont,
            focus: searchCont.searchFocus,
            textFieldType: TextFieldType.NAME,
            cursorColor: white,
            decoration: inputDecoration(
              context,
              fillColor: cardColor,
              filled: true,
              hintText: locale.value.searchMoviesShowsAndMore,
              prefixIcon: Padding(
                padding: EdgeInsets.all(16.0),
                child: IconWidget(
                  imgPath: Assets.iconsMagnifyingGlass,
                  color: iconColor,
                ),
              ),
              //
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (searchCont.isTyping.value)
                    GestureDetector(
                      onTap: () {
                        searchCont.clearSearchField();
                      },
                      child: IconWidget(imgPath: Assets.iconsX, size: 18, color: appColorPrimary),
                    ),
                  8.width,
                  GestureDetector(
                    onTap: () {
                      hideKeyboard(context);
                      if (!searchCont.isListening.value) {
                        searchCont.startListening();
                      } else {
                        searchCont.stopListening();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Obx(
                        () => IconWidget(
                          imgPath: Assets.iconsMicrophone,
                          color: searchCont.isListening.value ? appColorPrimary : iconColor,
                        ),
                      ),
                    ),
                  ),
                  16.width,
                ],
              ),
            ),
          ).expand(),
          Container(
            decoration: boxDecorationDefault(),
          )
        ],
      ),
    );
  }
}