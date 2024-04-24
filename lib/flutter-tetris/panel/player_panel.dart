import 'package:flutter/material.dart';
import 'package:gaming/flutter-tetris/material/briks.dart';
import 'package:gaming/flutter-tetris/material/images.dart';
import 'package:gaming/flutter-tetris/gamer/gamer.dart';
import 'dart:math' as math;

const _PLAYER_PANEL_PADDING = 7;

Size getBrikSizeForScreenWidth(double playerPanelWidth) {
  final double minDimension = math.min(playerPanelWidth, playerPanelWidth * 2);
  final double blockSize = minDimension / GAME_PAD_MATRIX_W;
  return Size.square(blockSize);
}


///the matrix of player content
class PlayerPanel extends StatelessWidget {
  final Size size;

  PlayerPanel({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size brickSize = getBrikSizeForScreenWidth(size.width);
    return SizedBox.fromSize(
      size: size,
      child: Container(
        padding: EdgeInsets.all(2),
        child: Stack(
          children: <Widget>[
            _PlayerPad(brickSize: brickSize),
            _GameUninitialized(),
          ],
        ),
      ),
    );
  }
}


class _PlayerPad extends StatelessWidget {
  final Size brickSize;

  _PlayerPad({
    required this.brickSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: GameState.of(context).data.map((list) {
        return Row(
          children: list.map((b) {
            return b == 1
                ? SizedBox.fromSize(size: brickSize, child: Brik.normal())
                : b == 2
                ? SizedBox.fromSize(size: brickSize, child: const Brik.highlight())
                : SizedBox.fromSize(size: brickSize, child: const Brik.empty());
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _GameUninitialized extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Container();

  }
}