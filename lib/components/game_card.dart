class GameCard {
  bool showBack;
  String suit;
  String value;
  int currentColumn;
  GameCard({
    this.showBack = false,
    required this.suit,
    required this.value,
    this.currentColumn = 0,
  });
}
