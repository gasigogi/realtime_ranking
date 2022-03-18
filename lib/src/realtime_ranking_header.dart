import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:realtime_ranking/src/realtime_ranking_item.dart';

const kDefaultRealtimeRankingHeaderHeight = 48.0;

class RealtimeRankingHeader extends StatelessWidget {
  final Widget header;
  final Widget animatedHeader;
  final Duration duration;
  final Widget? trailing;
  final double height;
  final bool animated;

  RealtimeRankingHeader({
    Key? key,
    required Widget header,
    Widget? animatedHeader,
    this.duration = const Duration(milliseconds: 250),
    this.trailing,
    double? height,
    this.animated = false,
  })  : header = header,
        animatedHeader = animatedHeader ?? header,
        height = height ?? kDefaultRealtimeRankingHeaderHeight,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: height,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: IndexedStack(
                    index: animated ? 0 : 1,
                    children: [
                      animatedHeader,
                      header,
                    ],
                  ),
                ),
                if (trailing != null)
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: min(height, kDefaultRealtimeRankingHeaderHeight),
                      minHeight: height,
                    ),
                    child: trailing!,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum RealtimeRankingAlignment {
  top,
  center,
  bottom,
}

class RealtimeRankingAnimatedHeader extends StatefulWidget {
  final List<Widget> children;
  final double height;
  final Duration duration;
  final Curve curve;
  final bool animated;
  final bool keepAlive;
  final int maxCount;

  RealtimeRankingAnimatedHeader({
    Key? key,
    List<Widget>? children,
    double? height,
    Duration? duration,
    Curve? curve,
    this.animated = false,
    this.keepAlive = true,
    int? maxCount,
  })  : children = children ?? [],
        height = height ?? kDefaultRealtimeRankingHeaderHeight,
        duration = duration ?? const Duration(milliseconds: 500),
        curve = curve ?? Curves.fastOutSlowIn,
        maxCount = maxCount ?? (children != null ? children.length : 10),
        super(key: key);

  @override
  _RealtimeRankingAnimatedHeaderState createState() => _RealtimeRankingAnimatedHeaderState();
}

class _RealtimeRankingAnimatedHeaderState extends State<RealtimeRankingAnimatedHeader> {
  late int _start = 0;
  int get _end => max(0, min(widget.maxCount, widget.children.length) - 1);
  int get _current => min(_start, _end);

  RealtimeRankingAlignment _alignment = RealtimeRankingAlignment.bottom;
  Duration get _duration => _alignment == RealtimeRankingAlignment.bottom ? Duration(microseconds: 1) : widget.duration;

  Timer? _timer;
  late double _opacity;
  late double _offsetY;

  @override
  void initState() {
    super.initState();

    _setupAnimation();
  }

  void _setupAnimation() {
    _updateAlignment(RealtimeRankingAlignment.center);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (widget.animated) {
        _disposeTimer();
        _timer = Timer.periodic(Duration(milliseconds: widget.duration.inMilliseconds * 4), (timer) {
          timer.cancel();
          _updateAlignment(RealtimeRankingAlignment.top, markNeedSetState: true);
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant RealtimeRankingAnimatedHeader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animated != widget.animated) {
      if (!widget.keepAlive) {
        _start = 0;
      }

      _setupAnimation();
    }
  }

  @override
  void dispose() {
    _disposeTimer();
    super.dispose();
  }

  void _disposeTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  void _updateAlignment(
    RealtimeRankingAlignment alignment, {
    bool markNeedSetState = false,
  }) {
    switch (alignment) {
      case RealtimeRankingAlignment.top:
        _opacity = 0.0;
        _offsetY = widget.height;
        break;
      case RealtimeRankingAlignment.center:
        _opacity = 1.0;
        _offsetY = 0.0;
        break;
      case RealtimeRankingAlignment.bottom:
        _opacity = 0.0;
        _offsetY = -widget.height;
        break;
    }
    _alignment = alignment;

    if (mounted && markNeedSetState) setState(() {});
  }

  void _next() {
    if (_start < _end) {
      _start++;
    } else {
      _start = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          AnimatedPositioned(
            left: 0,
            right: 0,
            bottom: _alignment == RealtimeRankingAlignment.bottom ? -widget.height : _offsetY,
            duration: _duration,
            curve: widget.curve,
            onEnd: () async {
              switch (_alignment) {
                case RealtimeRankingAlignment.top:
                  _next();
                  _updateAlignment(RealtimeRankingAlignment.bottom, markNeedSetState: true);
                  break;
                case RealtimeRankingAlignment.center:
                  _disposeTimer();
                  _timer = Timer.periodic(Duration(milliseconds: widget.duration.inMilliseconds * 4), (timer) {
                    timer.cancel();
                    _updateAlignment(RealtimeRankingAlignment.top, markNeedSetState: true);
                  });
                  break;
                case RealtimeRankingAlignment.bottom:
                  _updateAlignment(RealtimeRankingAlignment.center, markNeedSetState: true);
                  break;
              }
            },
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: _duration,
              child: widget.children[_current],
            ),
          ),
        ],
      ),
    );
  }
}

abstract class RealtimeRankingBaseHeader<T extends RealtimeRankingItem> extends StatelessWidget {
  final T item;
  final double height;
  final EdgeInsetsGeometry contentPadding;
  final VoidCallback? onTap;

  RealtimeRankingBaseHeader({
    Key? key,
    required this.item,
    double? height,
    EdgeInsetsGeometry? contentPadding,
    this.onTap,
  })  : height = height ?? kDefaultRealtimeRankingHeaderHeight,
        contentPadding = contentPadding ?? const EdgeInsets.symmetric(horizontal: 12.0),
        super(key: key);
}

class RealtimeRankingNormalHeader extends RealtimeRankingBaseHeader<RealtimeRankingNormalItem> {
  RealtimeRankingNormalHeader({
    Key? key,
    required RealtimeRankingNormalItem item,
    double? height,
    EdgeInsetsGeometry? contentPadding,
    VoidCallback? onTap,
  }) : super(
          key: key,
          item: item,
          height: height,
          contentPadding: contentPadding,
          onTap: onTap,
        );

  @override
  Widget build(BuildContext context) {
    final TextStyle titleTextStyle = Theme.of(context).textTheme.titleMedium ??
        TextStyle(
          fontSize: 12.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        );

    Widget child = Text(
      item.title,
      style: titleTextStyle,
      strutStyle: StrutStyle.fromTextStyle(
        titleTextStyle,
        forceStrutHeight: true,
      ),
      maxLines: 1,
      overflow: titleTextStyle.overflow ?? TextOverflow.ellipsis,
    );

    if (item.subtitle != null) {
      final TextStyle subtitleTextStyle = Theme.of(context).textTheme.labelMedium ??
          TextStyle(
            fontSize: 10.0,
            color: Colors.grey,
          );

      child = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
          SizedBox(
            height: Theme.of(context).dividerTheme.space ?? 4,
          ),
          Flexible(
            child: Text(
              item.subtitle!,
              style: subtitleTextStyle,
              strutStyle: StrutStyle.fromTextStyle(
                subtitleTextStyle,
                forceStrutHeight: true,
              ),
              maxLines: 1,
              overflow: subtitleTextStyle.overflow ?? TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    child = Container(
      height: height,
      padding: contentPadding,
      alignment: Alignment.centerLeft,
      child: child,
    );

    if (onTap != null) {
      child = InkWell(
        onTap: () => onTap!.call(),
        child: child,
      );
    }

    return Semantics(
      label: [item.title, if (item.subtitle != null && item.subtitle!.isNotEmpty) item.subtitle].join(' '),
      excludeSemantics: true,
      button: onTap != null,
      enabled: true,
      child: child,
    );
  }
}

class RealtimeRankingIndexHeader extends RealtimeRankingBaseHeader<RealtimeRankingIndexItem> {
  RealtimeRankingIndexHeader({
    Key? key,
    required RealtimeRankingIndexItem item,
    double? height,
    EdgeInsetsGeometry? contentPadding,
    VoidCallback? onTap,
  }) : super(
          key: key,
          item: item,
          height: height,
          contentPadding: contentPadding,
          onTap: onTap,
        );

  @override
  Widget build(BuildContext context) {
    final TextStyle indexTextStyle = Theme.of(context).textTheme.subtitle1 ??
        TextStyle(
          fontSize: 14.0,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        );

    final TextStyle titleTextStyle = Theme.of(context).textTheme.subtitle2 ??
        TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        );

    Widget child = Container(
      height: height,
      padding: contentPadding,
      child: Row(
        children: [
          Text(
            item.index.toString(),
            style: indexTextStyle,
            strutStyle: StrutStyle.fromTextStyle(
              indexTextStyle,
              forceStrutHeight: true,
            ),
            maxLines: 1,
            overflow: indexTextStyle.overflow ?? TextOverflow.ellipsis,
          ),
          SizedBox(
            width: Theme.of(context).dividerTheme.space ?? 8,
          ),
          Expanded(
            child: Text(
              item.title,
              style: titleTextStyle,
              strutStyle: StrutStyle.fromTextStyle(
                titleTextStyle,
                forceStrutHeight: true,
              ),
              maxLines: 1,
              overflow: titleTextStyle.overflow ?? TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      child = InkWell(
        onTap: () => onTap!.call(),
        child: child,
      );
    }

    return Semantics(
      label: [item.index.toString(), item.title].join('. '),
      excludeSemantics: true,
      button: onTap != null,
      enabled: true,
      child: child,
    );
  }
}

class RealtimeRankingWidgetHeader extends RealtimeRankingBaseHeader<RealtimeRankingWidgetItem> {
  RealtimeRankingWidgetHeader({
    Key? key,
    required RealtimeRankingWidgetItem item,
    double? height,
    EdgeInsetsGeometry? contentPadding,
    VoidCallback? onTap,
  }) : super(
          key: key,
          item: item,
          height: height,
          contentPadding: contentPadding,
          onTap: onTap,
        );

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      height: height,
      padding: contentPadding,
      child: item.child,
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
