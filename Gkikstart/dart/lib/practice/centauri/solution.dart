import 'package:kikstartd/core/iterator.dart';
import 'package:kikstartd/core/solution.dart';
import 'package:kikstartd/practice/centauri/model.dart';

class CentauriSol extends Solution<Kingdom> {
  @override
  IteratorSolution<Kingdom> parse(IteratorSolution<Kingdom> inputs) {
    inputs.tests = input.readInt();
    for (var test = 1; test <= inputs.tests; test++) {
      var name = input.splitRawLine().first.trim();
      inputs.input.add(Kingdom(name));
    }
    return inputs;
  }

  @override
  solve(Kingdom input) {
    var last = input.name[input.name.length - 1].toLowerCase();
    if (input.vowels.contains(last)) {
      return "${input.name} is ruled by Alice.";
    } else if (last == 'y') {
      return "${input.name} is ruled by nobody.";
    }
    return "${input.name} is ruled by Bob.";
  }

  @override
  void store(int test, result) {
    output.writeLine("Case #$test: $result");
  }
}
