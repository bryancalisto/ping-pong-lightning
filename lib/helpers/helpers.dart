import 'dart:math';

enum Direction {
  left,
  right,
  up,
  down,
}

class MotionEngine {
  late Direction ballDirectionVertical = Direction.down;
  late Direction ballDirectionHorizontal = Direction.left;
  double ballX = 0;
  double ballY = 0;
  // ball width is 20 DP. Converted to aligment
  double ballDiameter = 0.02;
  double racketUpX = -0.2;
  double racketUpY = -0.9;
  double racketDownX = -0.2;
  double racketDownY = 0.9;
  // total width is 2 (according to Aligment class measurements). 5 is the factor we are using using to divide screen in widget.
  // 2/5 = 0.4 in Aligment terms
  final double racketWidth = 0.4;
  static const xAxisMovementCompensation = 0.1;

  void resetBallPosition() {
    ballX = 0;
    ballY = 0;
  }

  void setRandomBallDirection() {
    ballDirectionVertical = Random.secure().nextInt(2) % 2 == 0 ? Direction.down : Direction.up;
    ballDirectionHorizontal = Random.secure().nextInt(2) % 2 == 0 ? Direction.left : Direction.right;
  }

  void moveBall() {
    if (ballY <= racketUpY && ballX >= racketUpX && ballX <= racketUpX + racketWidth) {
      ballDirectionVertical = Direction.down;
    }

    if (ballY >= racketDownY && ballX >= racketDownX && ballX <= racketDownX + racketWidth) {
      ballDirectionVertical = Direction.up;
    }

    // Alternate LEFT/RIGHT direction according to walls position
    if (ballX <= -1) {
      ballDirectionHorizontal = Direction.right;
    }

    if (ballX >= 1) {
      ballDirectionHorizontal = Direction.left;
    }

    // Vertical
    if (ballDirectionVertical == Direction.up) {
      ballY -= 0.01;
    } else if (ballDirectionVertical == Direction.down) {
      ballY += 0.01;
    }

    // Horizontal
    if (ballDirectionHorizontal == Direction.left) {
      ballX -= 0.01;
    } else if (ballDirectionHorizontal == Direction.right) {
      ballX += 0.01;
    }
  }

  bool ballPassedRacket() {
    return ballY < -1 || ballY > 1;
  }

  void moveRacketUpLeft() {
    if (racketUpX >= -0.9) {
      racketUpX -= 0.1;
    }
  }

  void moveRacketUpRight() {
    if (racketUpX < 1 - racketWidth) {
      racketUpX += 0.1;
    }
  }

  void moveRacketDownLeft() {
    if (racketDownX >= -0.9) {
      racketDownX -= 0.1;
    }
  }

  void moveRacketDownRight() {
    if (racketDownX < 1 - racketWidth) {
      racketDownX += 0.1;
    }
  }
}
