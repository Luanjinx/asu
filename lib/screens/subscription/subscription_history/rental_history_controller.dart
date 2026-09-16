import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';

import '../../../network/core_api.dart';
import '../../../utils/common_functions.dart';
import '../../subscription/model/rental_history_model.dart';

class RentalHistoryController extends BaseListController<RentalHistoryItem> {
  @override
  void onInit() {
    super.onInit();
    if (isLoggedIn.value) {
      initScrollListener(onNextPage: () {
        onScroll();
      });
      getListData(showLoader: false);
    }
  }

  Future<void> getListData({bool showLoader = true}) async {
    setLoading(showLoader);
    await listContentFuture(
      CoreServiceApis.getRentalHistory(
        page: currentPage.value,
        rentalList: listContent,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).catchError((e) {
      log("getPlan List Err : $e");
      throw e;
    }).whenComplete(() => setLoading(false));
  }

  Future<void> downloadInvoice({required int id}) async {
    if (isLoading.value) return;
    setLoading(true);
    CoreServiceApis.payPerViewInvoice(id: id).then((value) async {
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