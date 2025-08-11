/// Represents the different figures existing in the Yahtzee game
enum YahtzeeFigure {
  /// 3 identical dice and 2 more identical dice
  fullHouse,
  /// 4 identical dice
  fourOfAKind,
  /// 5 consecutive dice (1,2,3,4,5 or 2,3,4,5,6)
  longStraight,
  /// 4 consecutive dice (1,2,3,4,5 or 2,3,4,5,6)
  smallStraight,
  /// 3 identical dice
  threeOfAKind,
  /// 5 identical dice
  yahtzee,
}