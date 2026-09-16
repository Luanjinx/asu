// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../../main.dart';
import '../../../network/auth_apis.dart';
import '../model/notification_model.dart';

class NotificationScreenController extends BaseListController<NotificationData> {

  RxBool isDeleteEnabled = false.obs;

  @override
  void onInit() {
    getListData(showLoader: false);
    super.onInit();
  }

  @override
  Future<void> getListData({bool showLoader = true}) async {
    setLoading(showLoader);
    await listContentFuture(
      AuthServiceApis.getNotificationDetail(
        page: currentPage.value,
        notifications: listContent,
        isMarkAllAsRead: true,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).catchError((e) {
      throw e;
    }).whenComplete(() {
      setLoading(false);
    });
  }

  Future<void> clearAllNotification() async {
    Get.bottomSheet(
      AppDialogWidget(
        title: locale.value.doYouWantToMarkAllNotificationAsRead,
        onAccept: () async {
          await deleteNotification(type: 'all');
          currentPage(1);
          getListData();
        },
        image: Assets.iconsTrash,
        imageColor: appColorPrimary,
        positiveText: locale.value.proceed,
        negativeText: locale.value.cancel,
      ),
      isScrollControlled: true,
    );
  }

  Future<void> showDeleteNotificationBottomSheet(NotificationData notification) async {
    if (isLoading.value) return;
    if (notification.notificationId.isEmpty) return;
    Get.bottomSheet(
      AppDialogWidget(
        image: Assets.iconsTrash,
        imageColor: appColorPrimary,
        title: locale.value.doYouWantToDeleteThisNotification,
        onAccept: () async {
          await deleteNotification(id: notification.notificationId);
          currentPage(1);
          getListData();
        },
        positiveText: locale.value.proceed,
        negativeText: locale.value.cancel,
      ),
      isScrollControlled: true,
    );
  }

  Future<void> deleteNotification({
    String type = '',
    String id = '',
  }) async {
    setLoading(true);
    await AuthServiceApis.deleteNotification(type: type, notificationId: id).then(
      (value) {
        if (value.status) {
          successSnackBar(value.message);
        } else {
          errorSnackBar(error: value.message);
        }
      },
    ).catchError((e) {
      throw e;
    }).whenComplete(() => setLoading(false));
  }
}