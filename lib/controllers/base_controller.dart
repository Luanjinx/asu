import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/utils/common_base.dart';

/// Base controller with common functionality

abstract class BaseController<T> extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  ScrollController scrollController = ScrollController();
  RxBool isScrolled = false.obs;
  RxBool isLoading = false.obs;

  RxString errorMessage = ''.obs;

  RxInt currentPage = 1.obs;
  RxBool isLastPage = false.obs;

  /// Future for FutureBuilder
  Future<T> Function()? apiCall;
  void Function(T data)? onApiSuccess;
  void Function(String error)? onApiError;
  Rx<Future<T>?> contentFuture = Rx<Future<T>?>(null);

  /// Reactive data holder
  Rx<T?> content = Rx<T?>(null);

  bool get hasContent => content.value != null;

  // Scroll behavior
  double scrollThreshold = 120.0; // default
  double lastOffset = 0.0;
  bool isListenerAdded = false; // avoid duplicate listeners
  VoidCallback? onNextPageCallback;

  @override
  void onInit() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
    super.onInit();
  }

  // region ------------------------ Responsive Scroll Behavior ------------------------

  /// Initialize scroll listener with responsive threshold and optional pagination
  void initScrollListener({
    double? customThreshold,
    VoidCallback? onNextPage,
  }) {
    scrollThreshold = customThreshold ?? getDynamicScrollOffset();
    onNextPageCallback = onNextPage;

    // Prevent multiple listeners
    if (isListenerAdded) return;
    scrollController.addListener(_onScroll);
    isListenerAdded = true;
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    final offset = scrollController.offset;
    final maxScroll = scrollController.position.maxScrollExtent;
    final delta = Get.height * 0.10; // trigger next page when within 100px of bottom

    // --- Handle app bar scroll threshold ---
    if (offset > scrollThreshold && !isScrolled.value) {
      isScrolled.value = true;
    } else if (offset <= scrollThreshold && isScrolled.value) {
      isScrolled.value = false;
    }
    scrollController.animateToPosition;

    // --- Handle pagination ---
    if (onNextPageCallback != null && !isLoading.value && offset > (maxScroll - delta)) {
      onNextPageCallback?.call();
    }

    lastOffset = offset;
  }

  // endregion ------------------------------------------------------------------------

  /// Generic content handler

  Future<void> getContent({
    bool showLoader = true,
    required Future<T> Function() contentApiCall,
    required void Function(T data) onSuccess,
    void Function(String error)? onError,
  }) async {
    setLoading(showLoader);
    apiCall = contentApiCall;
    onApiSuccess = onSuccess;
    onApiError = onError;

    Future<T> future = contentApiCall();

    contentFuture.value = future;

    await future.then((value) {
      content(value);
      onSuccess(value);
    }).catchError((e) {
      String message = '';
      if (e is String) {
        message = e;
      } else {
        message = locale.value.somethingWentWrong;
      }

      errorMessage(message);
      onError?.call(message);
    }).whenComplete(() => setLoading(false));
  }

  Future<void> onSwipeRefresh() async {
    if (apiCall != null) {
      getContent(
        contentApiCall: apiCall!,
        onSuccess: onApiSuccess ?? (v) {},
      );
    }
  }

  void setLoading(bool loading) => isLoading.value = loading;

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

/// Base controller for list operations
abstract class BaseListController<T> extends BaseController {
  Rx<Future<List<T>>> listContentFuture = Future(() => <T>[]).obs;
  RxList<T> listContent = <T>[].obs;

  @override
  onReady() {
    initScrollListener(onNextPage: onScroll);
  }

  // Abstract method to be implemented by subclasses
  Future<void> getListData({bool showLoader = true});

  Future<void> onRefresh() async {
    currentPage(1);
    getListData();
  }

  Future<void> onRetry() async {
    getListData();
  }

  Future<void> onScroll() async {
    if (isLoading.value) return;
    if (!isLastPage.value) {
      currentPage++;
      getListData();
    }
  }
}