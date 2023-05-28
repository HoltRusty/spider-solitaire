import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

class Deck with ChangeNotifier {
  List<AnimatedContainer> deck = [];

  void initializeDeck() {
    List<PlayingCard> d = standardFiftyTwoCardDeck();
    d.shuffle();
    d.map((e) => deck.add(AnimatedContainer(
          duration: Duration(
            milliseconds: 300,
          ),
          child: (e! as Widget),
        )));
  }
}
