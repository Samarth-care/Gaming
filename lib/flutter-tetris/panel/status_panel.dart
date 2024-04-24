import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaming/flutter-tetris/gamer/gamer.dart';
import 'package:gaming/flutter-tetris/generated/l10n.dart';
import 'package:gaming/flutter-tetris/material/briks.dart';
import 'package:gaming/flutter-tetris/material/images.dart';

import 'package:gaming/flutter-tetris/gamer/block.dart';

class StatusPanel extends StatelessWidget {
  const StatusPanel({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            S.of(context).points,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            color: Colors.white, // Add this line
            child: Number(number: GameState.of(context).points),
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context).cleans,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            color: Colors.white, // Add this line
            child: Number(number: GameState.of(context).cleared),
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context).level,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            color: Colors.white, // Add this line
            child: Number(number: GameState.of(context).level),
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context).next,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          _NextBlock(),
        ],

      ),
    );
  }
}
class _NextBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<List<int>> data = [List.filled(4, 0), List.filled(4, 0)];
    final next = BLOCK_SHAPES[GameState.of(context).next.type]!;
    for (int i = 0; i < next.length; i++) {
      for (int j = 0; j < next[i].length; j++) {
        data[i][j] = next[i][j];
      }
    }
    return Column(
      children: data.map((list) {
        return Row(
          children: list.map((b) {
            return b == 1 ? Brik.normal() : Brik.empty(); // Updated constructor call
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _GameStatus extends StatefulWidget {
  @override
  _GameStatusState createState() {
    return _GameStatusState();
  }
}

class _GameStatusState extends State<_GameStatus> {
  Timer? _timer;

  bool _colonEnable = true;

  int _minute = 0;

  int _hour = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      setState(() {
        _colonEnable = !_colonEnable;
        _minute = now.minute;
        _hour = now.hour;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = MediaQuery.of(context).size.width / 10;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("$_hour", style: TextStyle(fontSize: fontSize, color: Colors.black87)),
        Text(_colonEnable ? ":" : " ", style: TextStyle(fontSize: fontSize, color: Colors.black87)),
        Text("$_minute", style: TextStyle(fontSize: fontSize, color: Colors.black87)),
      ],
    );
  }
}
