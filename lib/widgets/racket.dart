import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Racket extends StatelessWidget {
  final double x;
  final double y;

  const Racket({Key? key, required this.x, required this.y}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(x, y),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 20,
          width: MediaQuery.of(context).size.width / 5,
          color: CupertinoColors.black,
        ),
      ),
    );
  }
}
