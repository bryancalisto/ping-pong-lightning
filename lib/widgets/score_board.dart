import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  final int points;
  final Alignment alignment;
  final double fontSize;

  const ScoreBoard({Key? key, required this.points, required this.alignment, required this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Text(
        points.toString(),
        style: TextStyle(fontSize: fontSize, color: CupertinoColors.lightBackgroundGray),
      ),
    );
  }
}
