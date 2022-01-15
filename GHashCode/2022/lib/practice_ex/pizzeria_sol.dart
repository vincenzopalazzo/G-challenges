import 'package:hashd/core/solution.dart';
import 'package:hashd/practice_ex/model.dart';

/// Implementation Solution of Hash code 2022
/// https://codingcompetitions.withgoogle.com/hashcode/round/00000000008f5ca9/00000000008f6f33
///
/// Author: https://github.com/vincenzopalazzo
class OnePizza extends Solution<Restaurant> {
  Map<String, int> likeCounter = {};
  Map<String, int> dislikeCounter = {};
  int totLikeIngredient = 0;
  int totDislikeIngredient = 0;

  void addLikeIngredient(String ingredient) {
    if (likeCounter.containsKey(ingredient)) {
      var counter = likeCounter[ingredient]!;
      likeCounter[ingredient] = counter + 1;
      return;
    }
    totLikeIngredient++;
    likeCounter[ingredient] = 1;
  }

  void addDislikeIngredient(String ingredient) {
    if (dislikeCounter.containsKey(ingredient)) {
      var counter = dislikeCounter[ingredient]!;
      dislikeCounter[ingredient] = counter + 1;
      return;
    }
    totDislikeIngredient++;
    dislikeCounter[ingredient] = 1;
  }

  /// First step of the algorithm
  /// fill the map to take into count the number of ingredients
  /// TODO: we can avoid to feel the map? but we can just count the
  /// unique ingredient?
  /// Time Complexity O(N)
  void fillCounterMaps(Restaurant restaurant) {
    for (var client in restaurant.clients) {
      for (var element in client.preference) {
        addLikeIngredient(element);
      }
      for (var element in client.dislike) {
        addDislikeIngredient(element);
      }
    }
  }

  /// Second and third step of the solution, we
  /// calculate the rank of the client from the following formula
  /// like_rank = client_like / tot_like
  /// dislike_rank = -(client_dislike / tot_dislike) + 1
  /// user_rank = like_rank + dislike_rank
  ///
  /// And at the end sort the List of client by rank
  /// Time complexity O(N log N)
  void rankingUserByLike(List<Client> clients) {
    for (var client in clients) {
      client.likeRank = client.preference.length / totLikeIngredient;
      client.dislikeRank = -(client.dislike.length / totDislikeIngredient) + 1;
      client.rank = client.likeRank + client.dislikeRank;
    }
    // Sort by rank
    clients.sort();
    rawLog(clients);
  }

  /// The last step is to make the pizza with the rank result
  /// so we give more important to people with a high rank
  /// due the sorting list of client by rank.
  ///
  /// Time complexity O(Clients * Ingredient)
  void makePizza(Pizza pizza, List<Client> clients) {
    for (var client in clients) {
      pizza.addClientChoice(client);
    }
  }

  @override
  Pizza solve(Restaurant input) {
    fillCounterMaps(input);
    rankingUserByLike(input.clients);
    var pizza = Pizza();
    makePizza(pizza, input.clients);
    return pizza;
  }

  @override
  Restaurant parse() {
    var restaurant = Restaurant(clients: List.empty(growable: true));
    var clients = input!.readInt();
    for (var i = 0; i < clients; i++) {
      var likes = input!.splitRawLine();
      rawLog("Likes: ${likes.toString()}");
      var dislike = input!.splitRawLine();
      rawLog("Dislike: ${dislike.toString()}");
      var client = Client(
          preference:
              likes.isNotEmpty ? likes.getRange(1, likes.length).toSet() : {},
          dislike: dislike.isNotEmpty
              ? dislike.getRange(1, dislike.length).toSet()
              : {});
      restaurant.clients.add(client);
    }
    return restaurant;
  }

  @override
  void store(result) {
    if (result is! Pizza) {
      throw Exception("Wrong type of the result");
    }
    output!.writeLine(result.toString());
    rawLog(result.toString());
  }
}
