import 'package:flutter/material.dart';
import 'package:streamit_laravel/utils/colors.dart';

class CustomProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final Duration bufferedPosition;
  final List<Duration> adBreaks; // seconds
  final bool isAdPlaying;
  final void Function(Duration)? onSeek;

  const CustomProgressBar({
    super.key,
    required this.position,
    required this.duration,
    required this.adBreaks,
    this.bufferedPosition = Duration.zero,
    this.isAdPlaying = false,
    this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = duration.inSeconds == 0 ? 0 : position.inSeconds / duration.inSeconds;
    const barColor = appColorPrimary;
    const horizontalInset = 4.0;
    const thumbDiameter = 8.0;
    const dotSize = 6.0;
    const Color bufferedColor = Color(0xFFD9D9D9);

    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = (constraints.maxWidth - (horizontalInset * 2)).clamp(0.0, double.infinity);

        void handleSeek(Offset localPosition) {
          if (duration.inSeconds <= 0 || barWidth == 0) return;
          final dx = (localPosition.dx - horizontalInset).clamp(0.0, barWidth);
          final percent = (dx / barWidth).clamp(0.0, 1.0);
          final newSeconds = (duration.inSeconds * percent).round();
          if (onSeek != null) {
            onSeek!(Duration(seconds: newSeconds));
          }
        }

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragUpdate: (details) {
            final box = context.findRenderObject()! as RenderBox;
            final localPosition = box.globalToLocal(details.globalPosition);
            handleSeek(localPosition);
          },
          onTapDown: (details) {
            final box = context.findRenderObject()! as RenderBox;
            final localPosition = box.globalToLocal(details.globalPosition);
            handleSeek(localPosition);
          },
          child: SizedBox(
            height: 14,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Background bar
                Container(
                  height: 6,
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: horizontalInset),
                  decoration: BoxDecoration(
                    color: greyBtnColor.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Buffered progress
                FractionallySizedBox(
                  widthFactor: bufferedPosition.inSeconds <= 0 || duration.inSeconds == 0 ? 0 : (bufferedPosition.inSeconds / duration.inSeconds).clamp(0.0, 1.0),
                  child: Container(
                    height: 6,
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: horizontalInset),
                    decoration: BoxDecoration(
                      color: bufferedColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Upcoming ad markers
                ...adBreaks.where((adBreak) => adBreak > Duration.zero && adBreak < duration).map((adBreak) {
                  if (duration.inMilliseconds == 0 || barWidth == 0) return const SizedBox.shrink();
                  final adPosition = adBreak.inMilliseconds / duration.inMilliseconds;
                  final clamped = adPosition.clamp(0.0, 1.0);
                  final left = horizontalInset + (clamped * barWidth) - (dotSize / 2);
                  final bool isSeen = position >= adBreak;

                  return PositionedDirectional(
                    start: left,
                    top: 4,
                    child: Container(
                      width: dotSize,
                      height: dotSize,
                      decoration: BoxDecoration(
                        color: isSeen ? barColor : yellowColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),

                // Played progress
                FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    height: 6,
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: horizontalInset),
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Thumb (round circle)
                if (!isAdPlaying)
                  PositionedDirectional(
                    start: horizontalInset + (progress.clamp(0.0, 1.0) * barWidth) - (thumbDiameter / 2),
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: thumbDiameter,
                      height: thumbDiameter,
                      decoration: BoxDecoration(
                        color: barColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}