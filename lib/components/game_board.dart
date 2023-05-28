import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

import 'game_card.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<PlayingCard> cards = standardFiftyTwoCardDeck();
  List<GameCard> deck = [];

  List<List<GameCard>> cardGrid = [];
  final cardSuits = {
    "H": "♥",
    "S": "♠",
    "C": "♣",
    "D": "♦",
  };
  final cardValues = {
    "1": "A",
    "2": "2",
    "3": "3",
    "4": "4",
    "5": "5",
    "6": "6",
    "7": "7",
    "8": "8",
    "9": "9",
    "10": "10",
    "11": "J",
    "12": "Q",
    "13": "K",
  };

  void initState() {
    startGame();
    super.initState();
  }

  startGame() {
    List<GameCard> cards = [];
    int currentCard = 0;
    int cardLimit = 6;

    // create Decks of cards
    for (int i = 0; i < 8; i++) {
      for (int j = 1; j < 14; j++) {
        cards.add(
          GameCard(
            suit: "H",
            value: "$j",
          ),
        );
      }
    }

    cards.shuffle();

    // Deals cards to all columns
    for (int i = 0; i < 10; i++) {
      List<GameCard> tempColumn = [];

      // toggles deal from 6 cards to 5
      if (i == 4) cardLimit--;
      for (int j = 0; j < cardLimit; j++) {
        tempColumn.add(cards[currentCard]);
        tempColumn[j].showBack = j == cardLimit - 1 ? false : true;
        tempColumn[j].currentColumn = i;
        currentCard++;
      }
      cardGrid.add(tempColumn);
    }

    //puts the rest of the cards in the deck
    for (int i = currentCard; i < cards.length; i++) {
      deck.add(cards[currentCard]);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Text("Top Menu Cards and completed decks"),
        Row(
          children: cardGrid
              .map(
                (e) => e.isEmpty
                    ? SizedBox.shrink()
                    : Container(
                        // todo -- height needs to be height of container, not of screen
                        width: width / 10,
                        height: height,
                        child: buildColumn(e)),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget buildColumn(List<GameCard> e) {
    return DragTarget<GameCard>(
      onAccept: (c) {
        setState(() {
          cardGrid[c.currentColumn].remove(c);

          if (c?.currentColumn != null) {
            if (cardGrid[c.currentColumn][cardGrid[c.currentColumn].length! - 1]
                .showBack!)
              cardGrid[c.currentColumn][cardGrid[c.currentColumn].length! - 1]
                  .showBack = false;
            c.currentColumn = cardGrid.indexOf(e);
            e.add(c);
          }
        });
      },
      builder: (context, cardList, newCards) {
        return Stack(
          children: e.map((c) {
            int index = e.indexOf(c);
            return buildCard(c, index.toDouble());
          }).toList(),
        );
      },
    );
  }

  Widget buildCard(GameCard c, double index) {
    const offset = 15.0;
    final gameCard = c.showBack
        ? Container(
            width: 100,
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
            child: Text("${cardValues[c.value]} ${cardSuits[c.suit]}"),
          );

    return Transform(
      transform: Matrix4.identity()
        ..translate(
          0.0,
          index * offset,
          0.0,
        ),
      child: Draggable<GameCard>(
        data: c,
        child: gameCard,
        feedback: gameCard,
        childWhenDragging: SizedBox(
          width: 50,
          height: 80,
        ),
      ),
    );
  }
}
