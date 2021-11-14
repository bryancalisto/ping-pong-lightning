import 'dart:async';
import 'dart:math';

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
  late Direction _ballDirectionVertical = Direction.down;
  late Direction _ballDirectionHorizontal = Direction.left;
  double _ballX = 0;
  double _ballY = 0;
  // ball width is 20 DP. Converted to aligment
  // final double _ballDiameter = 0.02;
  double _racketUpX = -0.2;
  final double _racketUpY = -0.95;
  double racketDownX = -0.2;
  final double _racketDownY = 0.95;
  // total width is 2 (according to Aligment class measurements). 5 is the factor we are using using to divide screen in widget.
  // 2/5 = 0.4 in Aligment terms
  final double _racketWidth = 0.4;
  static const _racketMovementStep = 0.08;
  Timer? _timer;
  int _pointsRacketUp = 0;
  int _pointsRacketDown = 0;

  void resetBallPosition() {
    _ballX = 0;
    _ballY = 0;
  }

  void setRandomBallDirection() {
    _ballDirectionVertical = Random.secure().nextInt(2) % 2 == 0 ? Direction.down : Direction.up;
    _ballDirectionHorizontal = Random.secure().nextInt(2) % 2 == 0 ? Direction.left : Direction.right;
  }

  void moveBall() {
    // Toggle vertical direction
    if (_ballY <= _racketUpY && _ballX >= _racketUpX && _ballX <= _racketUpX + _racketWidth) {
      _ballDirectionVertical = Direction.down;
    } else if (_ballY >= _racketDownY && _ballX >= racketDownX && _ballX <= racketDownX + _racketWidth) {
      _ballDirectionVertical = Direction.up;
    }

    // Alternate LEFT/RIGHT direction according to walls position
    if (_ballX <= -1) {
      _ballDirectionHorizontal = Direction.right;
    } else if (_ballX >= 1) {
      _ballDirectionHorizontal = Direction.left;
    }

    // Vertical
    if (_ballDirectionVertical == Direction.up) {
      _ballY -= 0.01;
    } else {
      // down
      _ballY += 0.01;
    }

    // Horizontal
    if (_ballDirectionHorizontal == Direction.left) {
      _ballX -= 0.01;
    } else {
      // right
      _ballX += 0.01;
    }
  }

  bool ballPassedRacket() {
    return _ballY < -1 || _ballY > 1;
  }

  void moveRacketUpLeft() {
    if (_racketUpX >= -1 + _racketMovementStep) {
      _racketUpX -= _racketMovementStep;
    }
  }

  void moveRacketUpRight() {
    if (_racketUpX < 1 - _racketWidth) {
      _racketUpX += _racketMovementStep;
    }
  }

  void moveRacketDownLeft() {
    if (racketDownX >= -1 + _racketMovementStep) {
      racketDownX -= _racketMovementStep;
    }
  }

  void moveRacketDownRight() {
    if (racketDownX < 1 - _racketWidth) {
      racketDownX += _racketMovementStep;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer?.cancel();
    }
    super.dispose();
  }

  void endGame() {
    if (_timer != null) {
      _timer?.cancel();
    }
    _pointsRacketDown = 0;
    _pointsRacketUp = 0;
    racketDownX = -0.2;
    _racketUpX = -0.2;
    resetBallPosition();
  }

  void throwBall() async {
    setRandomBallDirection();
  }

  Timer startGame() {
    throwBall();

    return Timer.periodic(const Duration(milliseconds: 5), (timer) {
      if (ballPassedRacket()) {
        if (_ballDirectionVertical == Direction.down) {
          setState(() {
            _pointsRacketDown += 1;
          });
        } else {
          setState(() {
            _pointsRacketUp += 1;
          });
        }

        if (_pointsRacketUp > 4 || _pointsRacketDown > 4) {
          setState(() {
            endGame();
          });
        } else {
          setState(() {
            resetBallPosition();
          });
        }
      }

      setState(() {
        moveBall();
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
            // Just consider key down, not key up
            if (ev.runtimeType != RawKeyDownEvent) {
              return;
            }

            if (ev.logicalKey == LogicalKeyboardKey.arrowLeft) {
              setState(() {
                moveRacketDownLeft();
              });
            } else if (ev.logicalKey == LogicalKeyboardKey.arrowRight) {
              setState(() {
                moveRacketDownRight();
              });
            } else if (ev.logicalKey == LogicalKeyboardKey.keyA) {
              setState(() {
                moveRacketUpLeft();
              });
            } else if (ev.logicalKey == LogicalKeyboardKey.keyD) {
              setState(() {
                moveRacketUpRight();
              });
            } else if (ev.logicalKey == LogicalKeyboardKey.space) {
              _timer = startGame();
            }
          },
          child: Stack(
            children: [
              // Container(alignment: Alignment(0, _racketHeight), color: Colors.red, height: 10),
              ScoreBoard(points: _pointsRacketUp, alignment: const Alignment(-0.8, -0.8), fontSize: 35),
              Racket(x: _racketUpX, y: _racketUpY, width: _racketWidth),
              Ball(x: _ballX, y: _ballY),
              Racket(x: racketDownX, y: _racketDownY, width: _racketWidth),
              ScoreBoard(points: _pointsRacketDown, alignment: const Alignment(0.8, 0.8), fontSize: 35),
            ],
          ),
        ),
      ),
    );
  }
}
