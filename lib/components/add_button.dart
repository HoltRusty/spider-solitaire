import 'package:flutter/material.dart';
import 'package:spider_solitaire/components/DragCard.dart';
import 'package:spider_solitaire/components/game_card.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onClick;
  final int remainingDeals;
  final double height;
  const AddButton(
      {required this.onClick,
      required this.remainingDeals,
      this.height = 75,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> cardList = [];
    for (int i = 0; i < remainingDeals; i++)
      cardList.add(
        Container(
          width: 50,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
        ),
      );

    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: 140,
        height: 100,
        child: Stack(
          children: cardList.map((element) {
            return Positioned(
                left: 20.0 * cardList.indexOf(element), child: element);
          }).toList(),
        ),
      ),
    );
  }
}
