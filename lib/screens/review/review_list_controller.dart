import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/screens/content/content_details_controller.dart';
import 'package:streamit_laravel/screens/review/model/review_model.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

class ReviewListController extends BaseListController<ReviewModel> {
  RxBool isBtnEnable = false.obs;
  TextEditingController reviewCont = TextEditingController();
  FocusNode focus = FocusNode();
  RxDouble ratingVal = 0.0.obs;
  RxBool isEdit = false.obs;

  int contentId = 0;

  ReviewModel review = ReviewModel();

  @override
  void onInit() {
    if (Get.arguments is ArgumentModel) {
      contentId = (Get.arguments as ArgumentModel).intArgument;
      update([contentId]);
      if (contentId > 0) getListData(showLoader: false);
    }
    super.onInit();
  }

  void getBtnEnable() {
    if (review.review.isNotEmpty) {
      if (reviewCont.text.isNotEmpty || reviewCont.text != review.review || ratingVal.value != review.rating) {
        isBtnEnable(true);
      } else {
        isBtnEnable(false);
      }
    } else {
      if (reviewCont.text.isNotEmpty || ratingVal.value != 0.0) {
        isBtnEnable(true);
        isEdit(true);
      } else {
        isBtnEnable(false);
        isEdit(true);
      }
    }
  }

  Future<void> deleteReview(int id) async {
    setLoading(true);
    await CoreServiceApis.deleteRating(
      request: {ApiRequestKeys.idKey: id},
    ).then((value) async {
      successSnackBar(value.message.toString());
      getListData();
      if (Get.isRegistered<ContentDetailsController>()) {
        Get.find<ContentDetailsController>().getContentData(
          starTrailer: false,
        );
      }
    }).catchError((e) {
      errorSnackBar(error: e);
    }).whenComplete(() {
      Get.back();
      setLoading(false);
    });
  }

  void onReviewCheck() {
    if (review.review.isNotEmpty) {
      reviewCont.text = review.review;
    }
    if (review.rating > -1) {
      ratingVal(double.parse(review.rating.toString()));
    }
  }

  Future<void> editReview() async {
    setLoading(true);
    await CoreServiceApis.addRating(
      request: {
        ApiRequestKeys.idKey: review.id,
        ApiRequestKeys.entertainmentIdKey: review.entertainmentId,
        ApiRequestKeys.ratingKey: ratingVal.value,
        ApiRequestKeys.reviewKey: reviewCont.text,
      },
    ).then((value) async {
      isEdit(false);
      isBtnEnable(false);
      successSnackBar(value.message);
      getListData();
      if (Get.isRegistered<ContentDetailsController>()) {
        Get.find<ContentDetailsController>().getContentData(starTrailer: false);
      }
    }).catchError((e) {
      errorSnackBar(error: e);
    }).whenComplete(() => isLoading(false));
  }

  ///Get Review List
  ///
  @override
  Future<void> getListData({bool showLoader = true}) async {
    setLoading(showLoader);

    await listContentFuture(
      CoreServiceApis.getReviewList(
        page: currentPage.value,
        contentId: contentId,
        reviewList: listContent,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      if (isLoggedIn.value) {
        int usersReviewIndex = value.indexWhere((element) => element.userId == loginUserData.value.id);
        if (usersReviewIndex > -1) {
          review = value[usersReviewIndex];
        }
      }
    }).catchError((e) {
      throw e;
    }).whenComplete(() => setLoading(false));
  }
}