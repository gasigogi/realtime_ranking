import 'package:flutter/material.dart';

/// TODO: 설명
abstract class RealtimeRankingItem {}

/// TODO: 설명
class RealtimeRankingNormalItem extends RealtimeRankingItem {
  final String title;
  final String? subtitle;

  RealtimeRankingNormalItem({
    required this.title,
    this.subtitle,
  });
}

/// TODO: 설명
class RealtimeRankingIndexItem extends RealtimeRankingItem {
  final int index;
  final String title;

  RealtimeRankingIndexItem({
    required this.index,
    required this.title,
  });
}

/// TODO: 설명
class RealtimeRankingWidgetItem extends RealtimeRankingItem {
  final Widget child;

  RealtimeRankingWidgetItem({
    required this.child,
  });
}
