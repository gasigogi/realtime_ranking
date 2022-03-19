import 'package:flutter/material.dart';
import 'package:realtime_ranking/src/realtime_ranking_header.dart';
import 'package:realtime_ranking/src/realtime_ranking_item.dart';
import 'package:realtime_ranking/src/realtime_ranking_page_view.dart';

class RealtimeRanking extends StatelessWidget {
  final RealtimeRankingBaseHeader header;
  final List<RealtimeRankingBaseHeader> animatedHeaders;
  final Duration duration;
  final Curve curve;
  final double? height;
  final int? maxCount;
  final bool isSelected;
  final bool keepAlive;
  final PageController? pageController;
  final ScrollPhysics? physics;
  final ValueChanged<int>? onPageChanged;
  final double? itemHeight;
  final int pagePerCount;
  final Widget? trailing;

  RealtimeRanking({
    Key? key,
    required this.header,
    List<RealtimeRankingBaseHeader>? animatedHeaders,
    Duration? duration,
    Curve? curve,
    this.height,
    this.maxCount,
    this.isSelected = false,
    this.keepAlive = true,
    this.pageController,
    this.physics,
    this.onPageChanged,
    this.itemHeight,
    int? pagePerCount,
    this.trailing,
  })  : animatedHeaders = animatedHeaders ?? [],
        duration = duration ?? const Duration(milliseconds: 500),
        curve = curve ?? Curves.fastOutSlowIn,
        pagePerCount = pagePerCount ?? 5,
        super(key: key);

  factory RealtimeRanking.custom({
    required Widget header,
    List<Widget>? animatedHeaders,
    Duration? duration,
    Curve? curve,
    double? height,
    int? maxCount,
    bool isSelected = false,
    bool keepAlive = true,
    PageController? pageController,
    ScrollPhysics? physics,
    ValueChanged<int>? onPageChanged,
    double? itemHeight,
    int? pagePerCount,
    Widget? trailing,
  }) {
    return RealtimeRanking(
      header: RealtimeRankingWidgetHeader(
        item: RealtimeRankingWidgetItem(
          child: header,
        ),
        height: height,
        contentPadding: EdgeInsets.zero,
      ),
      animatedHeaders: animatedHeaders != null && animatedHeaders.isNotEmpty
          ? animatedHeaders
              .map(
                (header) => RealtimeRankingWidgetHeader(
                  item: RealtimeRankingWidgetItem(
                    child: header,
                  ),
                  height: height,
                  contentPadding: EdgeInsets.zero,
                ),
              )
              .toList()
          : null,
      duration: duration,
      curve: curve,
      height: height,
      maxCount: maxCount,
      isSelected: isSelected,
      keepAlive: keepAlive,
      pageController: pageController,
      physics: physics,
      onPageChanged: onPageChanged,
      itemHeight: itemHeight,
      pagePerCount: pagePerCount,
      trailing: trailing,
    );
  }

  bool get _isOpened => isSelected && animatedHeaders.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RealtimeRankingHeader(
          header: header,
          animatedHeader: animatedHeaders.isNotEmpty
              ? RealtimeRankingAnimatedHeader(
                  children: animatedHeaders,
                  duration: duration,
                  curve: curve,
                  animated: !isSelected,
                  height: height,
                  maxCount: maxCount,
                  keepAlive: keepAlive,
                )
              : null,
          height: height,
          animated: !isSelected,
          trailing: trailing,
        ),
        if (_isOpened)
          RealtimeRankingPageView.builder(
            pageController: pageController,
            physics: physics,
            itemBuilder: (context, index) => animatedHeaders[index],
            itemCount: animatedHeaders.length,
            onPageChanged: onPageChanged,
            pagePerCount: pagePerCount,
            itemHeight: itemHeight,
          ),
      ],
    );
  }
}
