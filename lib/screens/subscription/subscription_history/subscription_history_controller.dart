import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/screens/subscription/model/subscription_plan_model.dart';

import '../../../network/core_api.dart';
import '../../../utils/common_functions.dart';
import '../../../utils/constants.dart';

class SubscriptionHistoryController extends BaseListController<SubscriptionPlanModel> {
  @override
  void onInit() {
    getListData(showLoader: false);
    super.onInit();
  }

  @override
  Future<void> getListData({bool showLoader = true}) async {
    isLoading(showLoader);
    await listContentFuture(
      CoreServiceApis.getSubscriptionHistory(
        page: currentPage.value,
        subscriptionHistoryList: listContent,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then(
      (value) {
        if (value.any((element) => element.status == SubscriptionStatus.active)) {
          currentSubscription(value.firstWhere((element) => element.status == SubscriptionStatus.active));
          if (currentSubscription.value.level > -1 &&
              currentSubscription.value.planType.isNotEmpty &&
              currentSubscription.value.planType.any((element) => element.slug == SubscriptionTitle.videoCast)) {
            isCastingSupported(currentSubscription.value.planType.firstWhere((element) => element.slug == SubscriptionTitle.videoCast).limitationValue.getBoolInt());
          } else {
            isCastingSupported(false);
          }
        }
      },
    ).catchError((e) {
      log("getPlan List Err : $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> downloadInvoice({required int id}) async {
    if (isLoading.value) return;
    setLoading(true);
    CoreServiceApis.downloadInvoice(id: id).then((value) async {
      await downloadAndOpenFile(
        url: value.invoiceLink,
        loaderOnOffCallback: (bool) {
          isLoading(bool);
        },
      );
    }).catchError((e) {
      setLoading(false);
      toast(e.toString());
    });
  }
}