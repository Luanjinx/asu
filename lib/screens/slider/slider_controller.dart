import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

class SliderController extends BaseListController<PosterDataModel> {
  RxString sliderType = "".obs;

  RxBool isWatchListLoading = false.obs;

  @override
  Future<void> getListData({bool showLoader = true}) async {
    if (sliderType.value.isEmpty) return;
    setLoading(showLoader);
    await listContentFuture(CoreServiceApis.getSliderList(type: sliderType.value)).then((value) async {
      listContent(value);
      if (sliderType.value == BannerType.promotional) {
        if (listContent.isEmpty) {
          listContent.clear();
          listContent.add(
            PosterDataModel(
              posterImage: Assets.imagesIcChooseOptionBg,
              details: ContentData(
                id: 1,
                name: locale.value.walkthroughTitle2,
                description: locale.value.walkthroughDesp2,
              ),
            ),
          );
        }
      }
    }).catchError((e) {
      setLoading(false);
      if (e is Map<String, dynamic> && (e.containsKey('message') || e.containsKey('error_message'))) {
        e = e['message'] ?? e['error_message'];
      }
      throw e;
    }).whenComplete(() => setLoading(false));
  }

  Future<void> getBanner({bool showLoader = true, required String type}) async {
    sliderType(type);
    getListData(showLoader: showLoader);
  }

  Future<void> saveWatchLists(int index, {bool addToWatchList = true}) async {
    if (isWatchListLoading.isTrue) return;
    isWatchListLoading(true);

    final int previousValue = listContent[index].details.isInWatchList;
    listContent[index].details.isInWatchList = addToWatchList ? 1 : 0;
    listContent.refresh();

    try {
      if (addToWatchList) {
        successSnackBar(locale.value.addedToWatchList,
            icon: Container(
              padding: const EdgeInsets.all(5),
              decoration: boxDecorationDefault(
                color: appColorPrimary,
                borderRadius: radius(50),
              ),
              child: IconWidget(
                imgPath: Assets.iconsCheck,
                size: 12,
              ),
            ));
        await CoreServiceApis.saveWatchList(
          request: {
            ApiRequestKeys.entertainmentIdKey: listContent[index].details.id,
            if (selectedAccountProfile.value.id != 0) ApiRequestKeys.profileIdKey: selectedAccountProfile.value.id,
            if (selectedAccountProfile.value.id != 0) ApiRequestKeys.userIdKey: loginUserData.value.id,
            ApiRequestKeys.typeKey: listContent[index].details.type,
          },
        );
      } else {
        successSnackBar(locale.value.removedFromWatchList);
        await CoreServiceApis.deleteFromWatchlist(
          request: {
            ApiRequestKeys.isAjaxKey: 1,
            ApiRequestKeys.idKey: listContent[index].details.id,
            if (selectedAccountProfile.value.id != 0) ApiRequestKeys.profileIdKey: selectedAccountProfile.value.id,
            if (selectedAccountProfile.value.id != 0) ApiRequestKeys.userIdKey: loginUserData.value.id,
            ApiRequestKeys.typeKey: listContent[index].details.type,
          },
        );
      }

      await getBanner(type: sliderType.value);
    } catch (e) {
      listContent[index].details.isInWatchList = previousValue;
      listContent.refresh();
    } finally {
      isWatchListLoading(false);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}