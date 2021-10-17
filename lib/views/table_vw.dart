import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pp_lightning/helpers/helpers.dart';
import 'package:pp_lightning/widgets/ball.dart';
import 'package:pp_lightning/widgets/racket.dart';

class TableVw extends StatefulWidget {
  const TableVw({Key? key}) : super(key: key);

  @override
  _TableVwState createState() => _TableVwState();
}

class _TableVwState extends State<TableVw> {
  bool gameRunning = false;
  late final MotionEngine me;

  @override
  void initState() {
    me = MotionEngine();
    super.initState();
    startGame();
  }

  void startGame() {
    gameRunning = true;
    setState(() {
      me.setRandomBallDirection();
    });

    Timer.periodic(const Duration(milliseconds: 1), (timer) {
      setState(() {
        me.moveBall();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKey: (ev) {
            if (ev.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
              setState(() {
                me.moveRacketDownLeft();
              });
            }

            if (ev.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
              setState(() {
                me.moveRacketDownRight();
              });
            }

            if (ev.isKeyPressed(LogicalKeyboardKey.keyA)) {
              setState(() {
                me.moveRacketUpLeft();
              });
            }

            if (ev.isKeyPressed(LogicalKeyboardKey.keyD)) {
              setState(() {
                me.moveRacketUpRight();
              });
            }
          },
          child: Stack(
            children: [
              Racket(x: me.racketUpX, y: me.racketUpY),
              Ball(x: me.ballX, y: me.ballY),
              Racket(x: me.racketDownX, y: me.racketDownY),
            ],
          ),
        ),
      ),
    );
  }
}
