import 'dart:math';

import 'package:flutter/material.dart';

const kRealtimeRankingItemHeight = 40.0;

/// TODO: 설명
class RealtimeRankingPageView extends StatelessWidget {
  final PageController? pageController;
  final ScrollPhysics? physics;
  final ValueChanged<int>? onPageChanged;
  final List<Widget> children;
  final double itemHeight;
  final int pagePerCount;

  RealtimeRankingPageView({
    Key? key,
    this.pageController,
    this.physics,
    this.onPageChanged,
    required this.children,
    double? itemHeight,
    int? pagePerCount,
  })  : itemHeight = itemHeight ?? kRealtimeRankingItemHeight,
        pagePerCount = pagePerCount ?? 5,
        super(key: key);

  factory RealtimeRankingPageView.builder({
    PageController? pageController,
    ScrollPhysics? physics,
    ValueChanged<int>? onPageChanged,
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    double? itemHeight,
    int? pagePerCount,
  }) {
    assert(itemCount >= 0);

    return RealtimeRankingPageView(
      pageController: pageController,
      physics: physics,
      onPageChanged: onPageChanged,
      children: List.generate(
        itemCount,
        (index) => Builder(builder: (context) => itemBuilder(context, index)),
      ),
      itemHeight: itemHeight,
      pagePerCount: pagePerCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return SizedBox.shrink();

    final int totalPage = (children.length / pagePerCount).ceil();
    return SizedBox(
      height: max(0, min(children.length, pagePerCount)) * itemHeight,
      child: PageView.builder(
        controller: pageController,
        physics: physics,
        itemBuilder: (context, page) {
          final int start = page * pagePerCount;
          final int itemCount = children.length - start;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              max(0, min(itemCount, pagePerCount)),
              (index) => SizedBox(
                height: itemHeight,
                child: children[start + index],
              ),
            ),
          );
        },
        onPageChanged: onPageChanged,
        itemCount: totalPage,
      ),
    );
  }
}
