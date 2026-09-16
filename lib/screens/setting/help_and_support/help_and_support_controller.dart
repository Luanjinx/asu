import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/screens/auth/model/about_page_res.dart';
import 'package:streamit_laravel/services/local_storage_service.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

class HelpAndSupportController extends BaseListController<AboutDataModel> {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    getListData(showLoader: false);
    super.onReady();
  }

  @override
  Future<void> getListData({bool showLoader = true}) async {
    setLoading(showLoader);
    await listContentFuture(CoreServiceApis.getPageList()).then((value) {
      isLastPage(true);
      listContent(value);
      if (!listContent.any((element) => element.slug == AppPages.faq)) {
        listContent.add(
          AboutDataModel(
            slug: AppPages.faq,
            name: locale.value.faqs,
          ),
        );
      }
      appPageList(value); // data in the observable list
      setIntToLocal(SharedPreferenceConst.PAGE_LAST_CALL_TIME, DateTime.timestamp().millisecondsSinceEpoch);
    }).catchError((e) {
      throw e;
    }).whenComplete(() => setLoading(false));
  }
}