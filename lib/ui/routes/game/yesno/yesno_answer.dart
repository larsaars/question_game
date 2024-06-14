/// Represents an answer in a Yes/No game.
///
/// This class holds the information about a player's answer in a Yes/No game.
/// It includes the player's answer, whether the player has answered, and the player's guess.
class YesNoAnswer {
  /// The player's answer. It is `false` by default.
  bool answer = false;

  /// Indicates whether the player has answered. It is `false` by default.
  bool hasAnswered = false;

  /// The player's guess. It is `0` by default.
  int guess = 0;
}