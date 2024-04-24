import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gaming/flutter-tetris/gamer/gamer.dart';
import 'package:gaming/flutter-tetris/material/briks.dart';
import 'package:gaming/flutter-tetris/material/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;
import 'player_panel.dart';
import 'status_panel.dart';

const Color SCREEN_BACKGROUND = Color(0xffffffff);

class Screen extends StatelessWidget {
  final double width;

  const Screen({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerPanelWidth = width * 0.7;
    final statusPanelWidth = width * 0.3;
    return Shake(
      shake: GameState.of(context).states == GameStates.drop,
      child: SizedBox(
        height: (playerPanelWidth - 6) * 2 + 6 + 100,
        width: width + 50,
        child: Container(
          color: SCREEN_BACKGROUND,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SoundButton(),
                  ResetButton(),
                  PauseResumeButton(),
                  GuideButton(), // New button for the guide
                ],
              ),
              SizedBox(height: 20),
              GameMaterial(
                child: BrikSize(
                  size: getBrikSizeForScreenWidth(playerPanelWidth),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: PlayerPanel(size: Size(playerPanelWidth, playerPanelWidth * 2)),
                      ),
                      Expanded(
                        flex: 3,
                        child: StatusPanel(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Shake extends StatefulWidget {
  final Widget child;
  final bool shake;

  const Shake({
    Key? key,
    required this.child,
    required this.shake,
  }) : super(key: key);

  @override
  _ShakeState createState() => _ShakeState();
}

class _ShakeState extends State<Shake> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller =
    AnimationController(vsync: this, duration: Duration(milliseconds: 150))
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void didUpdateWidget(Shake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  v.Vector3 _getTranslation() {
    double progress = _controller.value;
    double offset = sin(progress * pi) * 1.5;
    return v.Vector3(0, offset, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translation(_getTranslation()),
      child: widget.child,
    );
  }
}

class SoundButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        GameState.of(context).muted ? Icons.volume_off : Icons.volume_up,
        color: Colors.blue,
      ),
      onPressed: () {
        Game.of(context).soundSwitch();
      },
    );
  }
}

class ResetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.restore,
        color: Colors.blue,
      ),
      onPressed: () {
        Game.of(context).reset();
      },
    );
  }
}

class PauseResumeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameStates = GameState.of(context).states;
    return IconButton(
      icon: Icon(
        gameStates == GameStates.running ? Icons.pause : Icons.play_arrow,
        color: Colors.blue,
      ),
      onPressed: () {
        Game.of(context).pauseOrResume();
      },
    );
  }
}

class GuideButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.info,
        color: Colors.blue,
      ),
      onPressed: () {
        // Show the guide dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('How to Play'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Basic Rules'),
                  SizedBox(height: 8),
                  Text('1. Move the tiles left or right to create horizontal lines.'),
                  Text('2. Complete horizontal lines to make them disappear.'),
                  Text('3. Try to survive as long as possible by clearing lines and preventing the tiles from reaching the top.'),
                  SizedBox(height: 16),
                  Text('Controls'),
                  SizedBox(height: 8),
                  Text('Left Button: Move the tile to the left.'),
                  Text('Right Button: Move the tile to the right.'),
                  Text('Up Button: Rotate the tile.'),
                  Text('Down Button: Drop the tile.'),
                  Text('Drop Button: Accelerates the dropping of tile.'),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
