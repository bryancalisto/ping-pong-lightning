import 'package:flutter/cupertino.dart';

class Racket extends StatelessWidget {
  final double x;
  final double y;
  final double width;

  const Racket({Key? key, required this.x, required this.y, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((x * 2 + width) / (2 - width), y),
      // alignment: Alignment(x, y),
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
