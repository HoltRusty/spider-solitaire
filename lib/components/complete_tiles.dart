import 'package:flutter/material.dart';

class CompleteTiles extends StatelessWidget {
  final int straightsComplete;
  const CompleteTiles({required this.straightsComplete, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> cardList = [];
    for (int i = 0; i < 6; i++)
      cardList.add(
        i < straightsComplete
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                width: 45,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.all(
                    Radius.circular(4.0),
                  ),
                ),
              )
            : SizedBox.shrink(),
      );

    return Row(
      children: cardList,
    );
  }
}
