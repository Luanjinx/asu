import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/screens/setting/model/faq_model.dart';

class FAQListController extends BaseListController<FAQModel> {
  @override
  void onInit() {
    getListData(showLoader: false);
    super.onInit();
  }

  @override
  Future<void> getListData({bool showLoader = true}) async {
    await listContentFuture(
      CoreServiceApis.getFAQList(
        page: currentPage.value,
        faqList: listContent,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).catchError((e) {
      throw e;
    }).whenComplete(() => isLoading(false));
  }
}