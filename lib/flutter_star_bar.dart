library flutter_star_bar;

import 'package:flutter/material.dart';

class StarBar extends StatefulWidget {
  final int maxStarCount;
  final Color highlightColor;
  final Color normalColor;
  final int starCount;
  final double starSize;
  final Widget? normalStar;
  final Widget? highlightStar;
  final ValueChanged<double>? onStarChanged;
  const StarBar(
      {Key? key,
      required this.maxStarCount,
      this.starCount = 1,
      this.starSize = 25,
      this.highlightStar,
      this.normalStar,
      this.normalColor = const Color(0xFFEBEBEB),
      this.highlightColor = const Color(0xFFF09630),
      this.onStarChanged})
      : assert(
            maxStarCount >= starCount && starCount >= 0,
            (normalStar == null && highlightStar == null) ||
                (normalStar != null && highlightStar != null)),
        super(key: key);

  @override
  _StarBarState createState() => _StarBarState();
}

class _StarBarState extends State<StarBar> {
  late int starCount = widget.starCount;

  Widget _buildStar(int index) {
    if (widget.highlightStar != null && index <= starCount) {
      return Container(
          width: widget.starSize,
          height: widget.starSize,
          child: widget.highlightStar!);
    }

    if (widget.normalStar != null) {
      return Container(
          width: widget.starSize,
          height: widget.starSize,
          child: widget.normalStar!);
    }

    return Icon(
      Icons.star_rate_rounded,
      size: widget.starSize,
      color: index <= starCount ? widget.highlightColor : widget.normalColor,
    );
  }

  int _calculateStarCount(double dx) {
    int star = (dx ~/ widget.starSize) + 1;
    star = star < 1 ? 1 : star;
    return star > widget.maxStarCount ? widget.maxStarCount : star;
  }

  void _refreshStarCount(int newStarCount) {
    if (newStarCount == starCount) return;
    setState(() {
      starCount = newStarCount;
    });
    widget.onStarChanged?.call(starCount.toDouble());
  }

  Widget _buildGestueDetector(Widget child) {
    return GestureDetector(
        onPanUpdate: (details) {
          _refreshStarCount(_calculateStarCount(details.localPosition.dx));
        },
        onPanDown: (details) {
          _refreshStarCount(_calculateStarCount(details.localPosition.dx));
        },
        child: child);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> starList = [];
    for (int i = 1; i <= widget.maxStarCount; i++) {
      starList.add(_buildStar(i));
    }
    Widget child = Container(
        width: widget.starSize * widget.maxStarCount,
        child: Row(children: starList));
    if (widget.onStarChanged != null) {
      return _buildGestueDetector(child);
    }

    return child;
  }
}
