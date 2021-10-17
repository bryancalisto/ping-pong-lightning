import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_lightning/widgets/ball.dart';
import 'package:pp_lightning/widgets/racket.dart';

class TableVw extends StatefulWidget {
  const TableVw({Key? key}) : super(key: key);

  @override
  _TableVwState createState() => _TableVwState();
}

class _TableVwState extends State<TableVw> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Racket(x: 0, y: -0.9),
            Ball(x: 0, y: 0),
            Racket(x: 0, y: 0.9),
          ],
        ),
      ),
    );
  }
}
