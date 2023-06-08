import 'package:flutter/material.dart';

class WinScreen extends StatelessWidget {
  final VoidCallback restart;
  WinScreen({required this.restart, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("You Won!"),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.blue, foregroundColor: Colors.white),
            onPressed: restart,
            child: Text("Restart"),
          ),
        ],
      ),
    );
  }
}
