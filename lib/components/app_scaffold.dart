import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/loader_widget.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../utils/common_base.dart';
import 'body_widget.dart';

class AppScaffold extends StatelessWidget {
  final bool hideAppBar;
  final Widget? leadingWidget;
  final Widget? appBarTitle;
  final List<Widget>? actions;
  final bool isCenterTitle;
  final bool automaticallyImplyLeading;
  final double? appBarElevation;
  final String? appBarTitleText;
  final Color? appBarbackGroundColor;
  final Widget body;
  final Color? scaffoldBackgroundColor;
  final RxBool? isLoading;
  final Widget? bottomNavBar;
  final Widget? fabWidget;
  final bool hasLeadingWidget;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool? resizeToAvoidBottomPadding;
  final bool? extendBodyBehindAppBar;

  final Widget? drawer;

  const AppScaffold({
    super.key,
    this.hideAppBar = false,
    //
    this.leadingWidget,
    this.appBarTitle,
    this.actions,
    this.appBarElevation = 0,
    this.appBarTitleText,
    this.appBarbackGroundColor,
    this.isCenterTitle = false,
    this.hasLeadingWidget = true,
    this.automaticallyImplyLeading = false,
    this.extendBodyBehindAppBar = false,
    //
    required this.body,
    this.isLoading,
    //
    this.bottomNavBar,
    this.fabWidget,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomPadding,
    this.scaffoldBackgroundColor,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomPadding,
      extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
      appBar: hideAppBar
          ? null
          : PreferredSize(
              preferredSize: Size(Get.width, 52),
              child: AppBar(
                elevation: appBarElevation,
                automaticallyImplyLeading: automaticallyImplyLeading,
                centerTitle: isCenterTitle,
                titleSpacing: 2,
                title: appBarTitle ??
                    Text(
                      appBarTitleText ?? "",
                      style: commonW600PrimaryTextStyle(size: 18),
                    ).paddingLeft(hasLeadingWidget ? 0 : 16),
                actions: actions,
                leading: leadingWidget ??
                    (hasLeadingWidget
                        ? backButton(
                            onBackPressed: () => Navigator.pop(context),
                          )
                        : null),
              ).paddingTop(0),
            ),
      backgroundColor: scaffoldBackgroundColor ?? context.scaffoldBackgroundColor,
      body: SafeArea(
        top: false,
        child: Body(
          isLoading: isLoading ?? false.obs,
          child: body,
        ),
      ),
      bottomNavigationBar: bottomNavBar,
      floatingActionButton: fabWidget,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

class NewAppScaffold extends StatelessWidget {
  final bool isPinnedAppbar;
  final double? bottomSpace;
  final bool isScrollableWidget;
  final ScrollController? scrollController;
  final Widget? body;
  final List<Widget> bodySlivers;
  final Widget? leadingWidget;
  final String? appBarTitleText;
  final List<Widget>? actions;
  final bool? resizeToAvoidBottomPadding;
  final Color? scaffoldBackgroundColor;
  final RxBool? isLoading;
  final List<Widget> widgetsStackedOverBody;
  final bool hideAppBar;

  final bool isBlurBackgroundLoader;
  final RxInt? currentPage;
  final Widget? floatingActionButton;

  final Widget? titleWidget;
  final Widget? appBarBottomWidget;
  final bool applyLeadingBackButton;
  final Widget? topbarChild;
  final double? collapsedHeight;
  final double? expandedHeight;
  final VoidCallback? onRefresh;
  final Color? statusBarColor;

  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;

  final Widget? appBarWidget;

  final EdgeInsets? bodyPadding;
  final bool isBodyFullScreen;

  const NewAppScaffold({
    super.key,
    this.isPinnedAppbar = false,
    this.isScrollableWidget = true,
    this.body,
    this.bodySlivers = const <Widget>[],
    this.leadingWidget,
    this.appBarTitleText,
    this.actions,
    this.resizeToAvoidBottomPadding,
    this.scaffoldBackgroundColor,
    this.isLoading,
    this.hideAppBar = false,
    this.isBlurBackgroundLoader = false,
    this.currentPage,
    this.floatingActionButton,
    this.appBarBottomWidget,
    this.applyLeadingBackButton = true,
    this.widgetsStackedOverBody = const <Widget>[],
    this.topbarChild,
    this.collapsedHeight,
    this.expandedHeight,
    this.onRefresh,
    this.statusBarColor,
    this.drawer,
    this.appBarWidget,
    this.scrollController,
    this.bodyPadding,
    this.floatingActionButtonLocation,
    this.titleWidget,
    this.bottomSpace,
    this.isBodyFullScreen = false,

  });

  Widget child(BuildContext context) {
    final double safeCollapsedHeight = math.max(collapsedHeight ?? kToolbarHeight, kToolbarHeight);

    return Stack(
      fit: StackFit.expand,
      children: [
        if (hideAppBar)
          SizedBox(
            height: collapsedHeight,
            width: Get.width,
            child: Container(
              padding: EdgeInsets.only(top: kToolbarHeight),
              height: collapsedHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: List.generate(
                    8,
                    (i) => (statusBarColor ?? appColorSecondary).withValues(
                      alpha: [0.16, 0.14, 0.12, 0.10, 0.08, 0.04, 0.02, 0.01][i],
                    ),
                  ),
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        CustomScrollView(
          controller: scrollController,
          clipBehavior: Clip.hardEdge,
          physics: isScrollableWidget ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
          slivers: [
            if (!hideAppBar)
              appBarWidget ??
                  SliverAppBar(
                    pinned: isPinnedAppbar,
                    automaticallyImplyLeading: applyLeadingBackButton,
                    leading: applyLeadingBackButton ? leadingWidget ?? backButton(onBackPressed: () => Navigator.pop(context)) : null,
                    expandedHeight: expandedHeight,
                    collapsedHeight: safeCollapsedHeight,
                    toolbarHeight: kToolbarHeight,
                    bottom: appBarBottomWidget != null
                        ? PreferredSize(
                            preferredSize: Size(Get.width, collapsedHeight ?? Get.height * 0.0548),
                            child: appBarBottomWidget ?? const Offstage(),
                          )
                        : null,
                    actions: actions,
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarBrightness: Brightness.dark,
                      statusBarIconBrightness: Brightness.light,
                      statusBarColor: Colors.transparent,
                      systemNavigationBarIconBrightness: Brightness.light,
                    ),
                    title: appBarTitleText.validate().isNotEmpty ? Text(appBarTitleText.validate(), style: boldTextStyle(size: ResponsiveSize.getFontSize(Constants.labelTextSize))) : titleWidget,
                    titleSpacing: applyLeadingBackButton && appBarTitleText.validate().isNotEmpty ? 0 : 16,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: isPinnedAppbar ? CollapseMode.pin : CollapseMode.parallax,
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: List.generate(
                              5,
                              (i) => (statusBarColor ?? appColorSecondary).withValues(
                                alpha: [0.16, 0.12, 0.08, 0.02, 0.01][i],
                              ),
                            ),
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: topbarChild,
                      ),
                    ),
                  ),
            if(!isBodyFullScreen && body != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: bodyPadding ?? EdgeInsets.only(left: 12, right: 12, top: 12),
                  child: body,
                ),
              )
            else if(body != null) body!,
            ...bodySlivers,
            SliverToBoxAdapter(child: SizedBox(height: bottomSpace ?? Get.height * 0.18)),
          ],
        ),
        ...widgetsStackedOverBody,
        if (applyLeadingBackButton && hideAppBar)
          PositionedDirectional(
            top: kToolbarHeight,
            start: ResponsiveSize.getStart(16),
            child: leadingWidget ??
                backButton(
                  onBackPressed: () => Navigator.pop(context),
                ),
          ),
        Obx(() => currentPage != null && currentPage!.value > 1
            ? PositionedDirectional(bottom: ResponsiveSize.getBottom(32), start: 0, end: 0, child: LoaderWidget(isBlurBackground: isBlurBackgroundLoader).visible((isLoading ?? false.obs).value))
            : LoaderWidget(isBlurBackground: isBlurBackgroundLoader).center().visible((isLoading ?? false.obs).value)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      maintainBottomViewPadding: true,
      bottom: true,
      left: false,
      right: false,
      child: Scaffold(
        drawer: drawer,
        drawerEnableOpenDragGesture: MediaQuery.of(context).orientation == Orientation.landscape,
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: resizeToAvoidBottomPadding,
        backgroundColor: scaffoldBackgroundColor ?? appScreenBackgroundDark,
        body: onRefresh != null
            ? RefreshIndicator(
                color: appColorPrimary,
                onRefresh: () async => onRefresh?.call(),
                child: child(context),
              )
            : child(context),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
    );
  }
}