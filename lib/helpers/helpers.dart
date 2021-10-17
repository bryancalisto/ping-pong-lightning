import 'dart:math';

enum Direction {
  left,
  right,
  up,
  down,
}

class MotionEngine {
  late Direction _ballDirection;
  double ballX = 0;
  double ballY = 0;
  double racketUpX = 0;
  double racketUpY = -0.9;
  double racketDownX = 0;
  double racketDownY = 0.9;
  // total width is 2 (according to aligment). 5 is the factor we are using using to divide screen in widget.
  // 2/5 = 0.4 in Aligment terms
  double racketWidth = 0.4;
  static const xAxisMovementCompensation = 0.1;

  void resetBallPosition() {
    ballX = 0;
    ballY = 0;
  }

  void setRandomBallDirection() {
    _ballDirection = Random().nextInt(2) % 2 == 0 ? Direction.down : Direction.up;
  }

  void moveBall() {
    if (ballY <= racketUpY && ballX >= racketUpX && ballX <= racketUpX + racketWidth) {
      _ballDirection = Direction.down;
    }

    if (ballY >= racketDownY && ballX >= racketDownX && ballX <= racketDownX + racketWidth) {
      _ballDirection = Direction.up;
    }

    switch (_ballDirection) {
      case Direction.left:
        ballX -= 0.01;
        break;
      case Direction.right:
        ballX += 0.01;
        break;
      case Direction.up:
        ballY -= 0.01;
        break;
      case Direction.down:
        ballY += 0.01;
        break;
    }
  }

  void moveRacketUpLeft() {
    if (racketUpX > -1) {
      racketUpX -= 0.05;
    }
  }

  void moveRacketUpRight() {
    if (racketUpX < 1) {
      racketUpX += 0.05;
    }
  }

  void moveRacketDownLeft() {
    if (racketDownX > -1) {
      racketDownX -= 0.05;
    }
  }

  void moveRacketDownRight() {
    if (racketDownX < 1) {
      racketDownX += 0.05;
    }
  }
}
