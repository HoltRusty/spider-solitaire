import 'package:flutter/material.dart';
import 'package:spider_solitaire/components/game_card.dart';
import 'package:spider_solitaire/constants.dart';

class DragCard extends StatelessWidget {
  final GameCard c;
  final double index;
  DragCard({required this.c, required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final constants = Constants();
    final offset = 15.0;
    final gameCard = c.showBack
        ? Container(
            width: 50,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
            ),
          )
        : Container(
            width: 50,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
            ),
            child: Text(
                "${constants.cardValues[c.value]} ${constants.cardSuits[c.suit]}"),
          );

    final dragCard = c.isDraggable
        ? Draggable<GameCard>(
            data: c,
            child: gameCard,
            feedback: gameCard,
            childWhenDragging: SizedBox(
              width: 50,
              height: 80,
            ),
          )
        : gameCard;

    return Transform(
      transform: Matrix4.identity()
        ..translate(
          0.0,
          index * offset,
          0.0,
        ),
      child: dragCard,
    );
  }
}
