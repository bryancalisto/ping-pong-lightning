import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_lightning/views/table_vw.dart';

class HomeVw extends StatelessWidget {
  const HomeVw({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: OpenContainer(
              openBuilder: (BuildContext context, void Function({Object? returnValue}) action) {
                return const TableVw();
              },
              closedBuilder: (BuildContext context, void Function() action) {
                return TextButton(
                  onPressed: action,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'START GAME',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        letterSpacing: MediaQuery.of(context).size.width * 0.008,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
