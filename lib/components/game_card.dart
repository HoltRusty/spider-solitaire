class GameCard {
  bool showBack;
  bool isDraggable;
  String suit;
  int value;
  int currentColumn;
  List<GameCard> children;
  GameCard({
    this.showBack = false,
    this.isDraggable = true,
    required this.suit,
    required this.value,
    this.currentColumn = 0,
    required this.children,
  });
}
