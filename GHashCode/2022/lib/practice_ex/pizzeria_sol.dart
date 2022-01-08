import 'package:hashd/core/solution.dart';
import 'package:hashd/practice_ex/model.dart';

/// Implementation Solution of Hash code 2022
/// https://codingcompetitions.withgoogle.com/hashcode/round/00000000008f5ca9/00000000008f6f33
///
/// Author: https://github.com/vincenzopalazzo
class OnePizza extends Solution<Restaurant> {
  @override
  Set<String> solve(Restaurant input) {
    // Make the pizza
    var pizza = <String>{};
    var dislikeStatistic = <String>{};
    for (var element in input.clients) {
      pizza.addAll(element.preference);
      dislikeStatistic.addAll(element.dislike);
    }
    /* Set<Statistic> dislikeStatistic = {};
    // O(C * D * LOG D)
    for (var element in input.clients) {
      for (var element in element.dislike) {
        var elem = dislikeStatistic.lookup(element);
        if (elem != null) {
          elem.increase();
        } else {
          dislikeStatistic.add(Statistic(ingridiend: element));
        }
      }
    }*/
    // O(N)
    return pizza.difference(dislikeStatistic);
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
    if (result is! Set<String>) {
      throw Exception("Wrong type of the result");
    }
    StringBuffer line = StringBuffer("${result.length} ");
    for (var element in result) {
      line.write("$element ");
    }
    output!.writeLine(line.toString());
    rawLog(line);
  }
}
