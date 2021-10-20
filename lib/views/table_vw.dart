import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pp_lightning/helpers/helpers.dart';
import 'package:pp_lightning/widgets/ball.dart';
import 'package:pp_lightning/widgets/racket.dart';
import 'package:pp_lightning/widgets/score_board.dart';

class TableVw extends StatefulWidget {
  const TableVw({Key? key}) : super(key: key);

  @override
  _TableVwState createState() => _TableVwState();
}

class _TableVwState extends State<TableVw> {
  late final MotionEngine me;
  int pointsRacketUp = 0;
  int pointsRacketDown = 0;

  @override
  void initState() {
    me = MotionEngine();
    super.initState();
    startGame();
  }

  void endGame(Timer timer) {
    timer.cancel();
    pointsRacketDown = 0;
    pointsRacketUp = 0;
    me.racketDownX = -0.2;
    me.racketUpX = -0.2;
    me.resetBallPosition();
  }

  void throwBall() async {
    await Future.delayed(const Duration(seconds: 1));
    me.setRandomBallDirection();
  }

  void startGame() {
    throwBall();

    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        if (me.ballPassedRacket()) {
          if (me.ballDirectionVertical == Direction.down) {
            pointsRacketDown += 1;
          } else {
            pointsRacketUp += 1;
          }

          if (pointsRacketUp > 4 || pointsRacketDown > 4) {
            endGame(timer);
          } else {
            me.resetBallPosition();
          }
        }

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

            if (ev.isKeyPressed(LogicalKeyboardKey.space)) {
              startGame();
            }
          },
          child: Stack(
            children: [
              ScoreBoard(points: pointsRacketUp, alignment: const Alignment(-0.8, -0.8), fontSize: 35),
              Racket(x: me.racketUpX, y: me.racketUpY, width: me.racketWidth),
              Ball(x: me.ballX, y: me.ballY),
              Racket(x: me.racketDownX, y: me.racketDownY, width: me.racketWidth),
              ScoreBoard(points: pointsRacketDown, alignment: const Alignment(0.8, 0.8), fontSize: 35),
            ],
          ),
        ),
      ),
    );
  }
}
