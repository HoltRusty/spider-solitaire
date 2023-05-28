import 'package:flutter/material.dart';

import 'game_card.dart';

class DisplayCard extends StatefulWidget {
  final GameCard card;

  //calculates offset
  final double transformDistance;

  //Positional Arguments
  final int columnIndex;
  final int rowIndex;
  final List<GameCard> attachedCards;

  const DisplayCard({
    super.key,
    required this.card,
    required this.transformDistance,
    required this.rowIndex,
    required this.columnIndex,
    required this.attachedCards,
  });

  @override
  State<DisplayCard> createState() => _DisplayCardState();
}

class _DisplayCardState extends State<DisplayCard> {
  _buildCard() {
    return widget.card.showBack
        ? Container(
            height: 60.0,
            width: 40.0,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8.0),
            ),
          )
        : Draggable<Map>(
            child: _buildFaceUpCard(),
            feedback: CardColumn(
              cards: widget.attachedCards,
            ),
            childWhenDragging: _buildFaceUpCard(),
            data: {
              "cards": widget.attachedCards,
              "fromIndex": widget.columnIndex,
            },
          );
  }

  _buildFaceUpCard() {}

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(
          0.0,
          widget.rowIndex * widget.transformDistance,
          0.0,
        ),
      child: _buildCard(),
    );
  }
}
