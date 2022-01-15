class Restaurant {
  List<Client> clients;

  Restaurant({required this.clients});
}

class Client extends Comparable {
  Client({required this.preference, required this.dislike});

  Set<String> preference;
  Set<String> dislike;
  double likeRank = -1;
  double dislikeRank = -1;
  double rank = -1;

  @override
  int compareTo(other) {
    if (rank > other.rank) {
      return -1;
    } else if (rank < other.rank) {
      return 1;
    }
    return 0;
  }

  @override
  String toString() {
    return 'Client{preference: $preference, dislike: $dislike, rank: $rank}';
  }
}

class Pizza {
  Set<String> ingredients = {};
  Set<String> dislikeIngredients = {};

  bool addClientChoice(Client client) {
    for (var ingredient in client.preference) {
      if (dislikeIngredients.contains(ingredient)) {
        return false;
      }
    }
    ingredients.addAll(client.preference);
    dislikeIngredients.addAll(client.dislike);
    return true;
  }

  @override
  String toString() {
    StringBuffer line = StringBuffer("${ingredients.length} ");
    for (var element in ingredients) {
      line.write("$element ");
    }
    return line.toString().trimRight();
  }
}
