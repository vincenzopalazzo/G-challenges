import 'package:hashd/core/solution.dart';
import 'package:hashd/practice_ex/model.dart';

class OnePizza extends Solution<Restaurant> {
  @override
  List<String> solve(Restaurant input) {
    rawLog("Inputs is: $input");
    return [];
  }

  @override
  Future<Restaurant> parse() async {
    var restaurant = Restaurant(clients: List.empty(growable: true));
    await input!.parse();
    var clients = input!.readInt();
    for (var i = 0; i < clients; i++) {
      var likes = input!.splitRawLine();
      rawLog("Likes: ${likes.toString()}");
      var dislike = input!.splitRawLine();
      rawLog("Dislike: ${dislike.toString()}");
      var client = Client(
          preference: likes.isNotEmpty
              ? likes.getRange(1, likes.length).toList()
              : List.empty(growable: true),
          dislike: dislike.isNotEmpty
              ? dislike.getRange(1, dislike.length).toList()
              : List.empty(growable: true));
      restaurant.clients.add(client);
    }
    return restaurant;
  }

  @override
  void store(result) {
    if (result is! List<String>) {
      throw Exception("Wrong type of the result");
    }
    var lines = result.toSet();
    StringBuffer line = StringBuffer("${lines.length} ");
    for (var element in lines) { line.write("$element ");}
    output!.writeLine(line);
    rawLog(line);
  }
}
