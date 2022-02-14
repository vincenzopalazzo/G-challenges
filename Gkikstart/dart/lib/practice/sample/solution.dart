import 'package:kikstartd/core/iterator.dart';
import 'package:kikstartd/core/solution.dart';
import 'package:kikstartd/practice/sample/model.dart';

class SampleSolution extends Solution<CandyDistributor> {
  @override
  IteratorSolution<CandyDistributor> parse(
      IteratorSolution<CandyDistributor> inputs) {
    inputs.tests = input!.readInt();
    log("Tests: ${inputs.tests}");
    for (var test = 0; test < inputs.tests; test++) {
      var distributor = CandyDistributor();
      var inputSize = input!.readInts(2);
      var candyBags = inputSize[0];
      distributor.kidsSize = inputSize[1];
      var candyInBags = input!.readInts(candyBags);
      for (var candyInBag in candyInBags) {
        distributor.candyBags.add(CandyBag(candyContained: candyInBag));
      }
      inputs.input.add(distributor);
    }

    return inputs;
  }

  @override
  solve(CandyDistributor input) {
    return 0;
  }

  @override
  void store(int test, result) {
    output!.writeLine("Case #$test: $result");
  }
}
