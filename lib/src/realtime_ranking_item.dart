import 'package:flutter/material.dart';

abstract class RealtimeRankingItem {}

class RealtimeRankingNormalItem extends RealtimeRankingItem {
  final String title;
  final String? subtitle;

  RealtimeRankingNormalItem({
    required this.title,
    this.subtitle,
  });
}

class RealtimeRankingIndexItem extends RealtimeRankingItem {
  final int index;
  final String title;

  RealtimeRankingIndexItem({
    required this.index,
    required this.title,
  });
}

class RealtimeRankingWidgetItem extends RealtimeRankingItem {
  final Widget child;

  RealtimeRankingWidgetItem({
    required this.child,
  });
}
