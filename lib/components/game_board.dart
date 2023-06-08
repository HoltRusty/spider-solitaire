import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:spider_solitaire/components/DragCard.dart';
import 'package:spider_solitaire/components/add_button.dart';
import 'package:spider_solitaire/components/win_screen.dart';

import 'complete_tiles.dart';
import 'game_card.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<PlayingCard> cards = standardFiftyTwoCardDeck();
  List<GameCard> deck = [];
  int remainingDeals = 5;
  int straightsComplete = 0;
  List<List<GameCard>> cardGrid = [];

  void initState() {
    startGame();

    super.initState();
  }

  updateChildren(List<GameCard> cardColumn, int index, List<GameCard> children,
      bool isDraggable) {
    if (index < 0) return;
    print("Past 0 check because value is $index");
    if (cardColumn[index].showBack) return;
    print("past showBack");
    if (!cardColumn[index].isDraggable) return;
    print("Past Is Draggable");
    if (cardColumn[index].isDraggable != isDraggable) {
      print("Checking is Draggable: ${cardColumn[index].isDraggable}");
      cardColumn[index].isDraggable = isDraggable;
      updateChildren(cardColumn, index - 1, children, isDraggable);
      return;
    }
    print("Past mismatch check");

    if (cardColumn[index].value - 1 != children[0].value ||
        cardColumn[index].suit != children[0].suit) {
      if (cardColumn[index].isDraggable) {
        isDraggable = false;
        cardColumn[index].isDraggable = isDraggable;
        updateChildren(cardColumn, index - 1, children, isDraggable);
      }
      return;
    }
    print("Values are equal: ${cardColumn[index].value} ${children[0].value}");

    cardColumn[index].children = [];
    cardColumn[index].children.addAll(children);
    print("Adding to ${cardColumn[index].value} these values:");
    cardColumn[index].children.forEach((element) {
      print(element.value);
    });
    children.insert(0, cardColumn[index]);
    if (cardColumn[index].value == 13 && children.length == 13) {
      print("Should never happen in children update");
      removeStraight(cardColumn, index);
      return;
    }
    print("Going again");
    updateChildren(cardColumn, index - 1, children, isDraggable);
  }

  removeChildren(List<GameCard> cardColumn, int index, List<GameCard> children,
      bool isDraggable) {
    if (index < 0) return;
    if (cardColumn[index].showBack) return;
    if (!cardColumn[index].isDraggable) return;
    //todo -- update remove children function
    //if the card doesn't have children, return
    // if the list of children is not contained in the card's children list, return
    // Otherwise remove the list of children from the card's list of children
  }

  removeStraight(List<GameCard> cardColumn, int index) {
    cardColumn.removeRange(index, index + 13);
    straightsComplete++;
    validateRemove(cardColumn);
  }

  // Enables next cards to be dragged
  freeChildren(List<GameCard> cardColumn, index, childValue) {
    if (index < 0) return;
    if (cardColumn[index].value - 1 != childValue) return;

    cardColumn[index].isDraggable = true;
    freeChildren(cardColumn, index - 1, cardColumn[index].value);
  }

  validateRemove(List<GameCard> cardColumn) {
    if (!cardColumn.isEmpty) {
      int newTop = cardColumn.length! - 1;
      if (cardColumn[newTop].showBack!) cardColumn[newTop].showBack = false;
      if (!cardColumn[newTop].isDraggable)
        freeChildren(cardColumn, newTop, cardColumn[newTop].value - 1);
    }
  }

  startGame() {
    setState(() {
      remainingDeals = 5;
      straightsComplete = 0;
      cardGrid = [];
      deck = [];
      List<GameCard> cards = [];
      int currentCard = 0;
      int cardLimit = 6;

      // create Decks of cards
      for (int i = 0; i < 8; i++) {
        for (int j = 1; j < 14; j++) {
          cards.add(
            GameCard(
              suit: "H",
              value: j,
              children: [],
            ),
          );
        }
      }

      cards.shuffle();
      // print("I have created ${cards.length} cards");

      // Deals cards to all columns
      for (int i = 0; i < 10; i++) {
        List<GameCard> tempColumn = [];

        // toggles deal from 6 cards to 5
        if (i == 4) cardLimit--;
        for (int j = 0; j < cardLimit; j++) {
          tempColumn.add(cards[currentCard]);
          tempColumn[j].showBack = j == cardLimit - 1 ? false : true;
          tempColumn[j].isDraggable = j == cardLimit - 1 ? true : false;
          tempColumn[j].currentColumn = i;
          currentCard++;
        }
        cardGrid.add(tempColumn);
      }

      // print(
      //     "After all the dealing, we have ${cards.length - currentCard} cards remainng");

      //puts the rest of the cards in the deck
      for (int i = currentCard; i < cards.length; i++) {
        // todo -- change Code here
        deck.add(cards[i]);
        // deck.add(cards[currentCard]);
      }
    });
    print("Number of straights is now: $straightsComplete");
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    List<Widget> children = straightsComplete == 8
        ? [
            GameTable(width, height),
            WinScreen(
              restart: startGame,
            ),
          ]
        : [
            GameTable(width, height),
          ];

    return Stack(children: children);
  }

  Widget GameTable(double width, double height) {
    return Column(
      children: [
        Container(
          width: width,
          height: height / 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Add Button
              AddButton(
                remainingDeals: remainingDeals,
                height: height / 10,
                onClick: () {
                  for (int i = 0; i < cardGrid.length; i++) {
                    deck[0].currentColumn = i;
                    cardGrid[i].add(deck[0]);
                    updateChildren(
                        cardGrid[i], cardGrid[i].length - 2, [deck[0]], true);
                    deck.removeAt(0);
                  }
                  remainingDeals--;

                  setState(() {});
                },
              ),
              CompleteTiles(
                straightsComplete: straightsComplete,
              ),

              // Complete Decks
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: cardGrid
              .map(
                (e) => Container(
                    // todo -- height needs to be height of container, not of screen
                    width: width / 10,
                    height: 7 * height / 10 - 20,
                    child: buildColumn(e, updateChildren)),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget buildColumn(List<GameCard> columnCards, Function updateChildren) {
    MoveCard(GameCard selectedCard) {
      setState(() {
        int oldColumn = selectedCard.currentColumn;

        // add selected card
        cardGrid[oldColumn].remove(selectedCard);
        selectedCard.currentColumn = cardGrid.indexOf(columnCards);
        columnCards.add(selectedCard);

        // If has Children, Loops through and deletes every card from the list
        if (selectedCard.children.isNotEmpty) {
          selectedCard.children.forEach((card) {
            cardGrid[oldColumn].remove(card);
            card.currentColumn = cardGrid.indexOf(columnCards);
            columnCards.add(card);
          });
        }
        updateChildren(columnCards, columnCards.indexOf(selectedCard) - 1,
            [selectedCard, ...?selectedCard?.children], true);
        if (cardGrid[oldColumn].isNotEmpty) {
          // Update old column's top card
          validateRemove(cardGrid[oldColumn]);

          //todo -- update children list after move

          // Update old column with new children
          int oldLength = cardGrid[oldColumn].length;
          GameCard oldTop = cardGrid[oldColumn][oldLength - 1];
          oldTop.children = [];
          print("Updating Old Column");
          updateChildren(cardGrid[oldColumn], oldLength - 2, [oldTop], true);
        }
      });
    }

    return DragTarget<GameCard>(
      onWillAccept: (selectedCard) {
        if (columnCards.isEmpty) {
          return true;
        }

        int topIndex = columnCards.length - 1;
        var topCard = columnCards[topIndex];

        if (topCard.value - 1 != selectedCard?.value ||
            topCard.suit != selectedCard?.suit) return false;

        return true;
      },
      onAccept: (selectedCard) {
        setState(() {
          MoveCard(selectedCard);
        });
      },
      builder: (context, cardList, newCards) {
        return Stack(
          children: columnCards.map((c) {
            int index = columnCards.indexOf(c);
            return DragCard(
              c: c,
              index: index.toDouble(),
            );
          }).toList(),
        );
      },
    );
  }
}
