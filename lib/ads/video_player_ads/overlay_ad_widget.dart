import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:streamit_laravel/ads/custom_ads/ad_player.dart';
import 'package:streamit_laravel/ads/models/overlay_ad.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:url_launcher/url_launcher.dart';

class OverlayAdWidget extends StatefulWidget {
  final OverlayAd overlayAd;
  final VoidCallback onClose;
  final int remainingSeconds;
  final bool isSplitMode;

  const OverlayAdWidget({
    super.key,
    required this.overlayAd,
    required this.onClose,
    required this.remainingSeconds,
    this.isSplitMode = false,
  });

  @override
  State<OverlayAdWidget> createState() => _OverlayAdWidgetState();
}

class _OverlayAdWidgetState extends State<OverlayAdWidget> {
  bool _canSkip = false;
  Timer? _skipTimer;

  @override
  void initState() {
    super.initState();
    if (widget.overlayAd.isVideo) {
      _skipTimer = Timer(Duration(seconds: widget.overlayAd.skipDuration), () {
        if (mounted) setState(() => _canSkip = true);
      });
    }
  }

  @override
  void dispose() {
    _skipTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = widget.isSplitMode ? double.infinity : (Get.width > 400 ? 400 : Get.width * 0.9);

    final double height = widget.isSplitMode ? 140 : (Get.height * 0.25);

    return Container(
      constraints: BoxConstraints(
        maxWidth: width,
        maxHeight: height,
        minWidth: 200,
        minHeight: 100,
      ),
      child: Material(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            final url = widget.overlayAd.primaryClickUrl;
            if (!widget.overlayAd.isVideo && url != null) {
              _openUrl(url);
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildContent(),
                ),
              ),

              // Close button
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconWidget(
                      imgPath: Assets.iconsX,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),

              // Image timer
              if (widget.overlayAd.isImage && widget.remainingSeconds > 0)
                Positioned(
                  bottom: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${locale.value.ad} ${widget.remainingSeconds}s',
                      style: commonPrimaryTextStyle(size: 10, color: Colors.white),
                    ),
                  ),
                ),

              // Skip button for video
              if (widget.overlayAd.isVideo && _canSkip)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: widget.onClose,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: appColorPrimary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Skip Ad',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final ad = widget.overlayAd;

    // 1) VIDEO
    if (ad.isVideo && ad.videoUrl != null && ad.videoUrl!.isNotEmpty) {
      return AdPlayer(
        videoUrl: ad.videoUrl!,
        redirectUrl: ad.primaryClickUrl ?? '',
        onVideoCompleted: widget.onClose,
        isFromPlayerAd: true,
        height: double.infinity,
        width: double.infinity,
      );
    }

    // 2) HTML
    if (ad.isHtml && ad.htmlContent.trim().isNotEmpty) {
      return _OverlayAdWebView(htmlContent: ad.htmlContent);
    }

    // 3) IMAGE
    if (ad.isImage && ad.imageUrl.trim().isNotEmpty) {
      return CachedImageWidget(
        url: ad.imageUrl,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover, // FIXED for banners
      );
    }

    // 4) FALLBACK (prevents blank overlays)
    return const Center(
      child: Text(
        "Ad unavailable",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print("OverlayAd URL error: $e");
    }
  }
}

class _OverlayAdWebView extends StatefulWidget {
  final String htmlContent;

  const _OverlayAdWebView({required this.htmlContent});

  @override
  State<_OverlayAdWebView> createState() => _OverlayAdWebViewState();
}

class _OverlayAdWebViewState extends State<_OverlayAdWebView> {
  InAppWebViewController? _webViewController;

  @override
  void didUpdateWidget(covariant _OverlayAdWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.htmlContent != widget.htmlContent) {
      _webViewController?.loadData(data: widget.htmlContent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialData: InAppWebViewInitialData(data: widget.htmlContent),
      initialSettings: InAppWebViewSettings(
        transparentBackground: true,
        javaScriptEnabled: true,
        useShouldOverrideUrlLoading: true,
      ),
      onWebViewCreated: (controller) {
        _webViewController = controller;
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        final uri = navigationAction.request.url;
        if (uri != null && uri.scheme.startsWith('http')) {
          launchUrl(uri, mode: LaunchMode.externalApplication);
          return NavigationActionPolicy.CANCEL;
        }
        return NavigationActionPolicy.ALLOW;
      },
    );
  }
}
