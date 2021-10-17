import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pp_lightning/views/table_vw.dart';

class HomeVw extends StatelessWidget {
  const HomeVw({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OpenContainer(
            openBuilder: (BuildContext context, void Function({Object? returnValue}) action) {
              return const TableVw();
            },
            closedBuilder: (BuildContext context, void Function() action) {
              return TextButton(
                onPressed: action,
                child: const Center(child: Text('START GAME')),
              );
            },
          ),
        ],
      ),
    );
  }
}
