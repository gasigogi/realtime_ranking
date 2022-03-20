import 'package:flutter/material.dart';
import 'package:realtime_ranking/src/realtime_ranking_header.dart';

class RealtimeRankingIconButton extends StatelessWidget {
  final Widget? icon;
  final bool isSelected;
  final bool animated;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onTap;

  const RealtimeRankingIconButton({
    Key? key,
    this.icon,
    this.isSelected = false,
    this.animated = false,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.fastOutSlowIn,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = AnimatedRotation(
      duration: animated ? duration : Duration.zero,
      curve: curve,
      turns: isSelected ? 0.5 : 1,
      child: icon ??
          Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).primaryColor,
            size: kDefaultRealtimeRankingHeaderHeight / 2.0,
          ),
    );

    if (onTap != null) {
      child = InkWell(
        onTap: () => onTap!.call(),
        child: child,
      );
    }

    return child;
  }
}
