import 'package:kikstartd/core/iterator.dart';
import 'package:kikstartd/core/solution.dart';
import 'package:kikstartd/practice/citation/model.dart';

class ArticleCitation extends Solution<RankingCitation> {
  @override
  IteratorSolution<RankingCitation> parse(
      IteratorSolution<RankingCitation> inputs) {
    inputs.tests = input.readInt();
    for (var test = 1; test <= inputs.tests; test++) {
      var papersSize = input.readInt();
      var ranking = RankingCitation(papersSize);
      var citations = input.readInts(papersSize);
      ranking.citation.addAll(citations);
      inputs.input.add(ranking);
    }
    return inputs;
  }

  @override
  List<int> solve(RankingCitation input) {
    input.citation.sort((int a, int b) => -a.compareTo(b));
    var result = List<int>.empty(growable: true);
    result.add(1);
    for (var paper = 1; paper < input.papersSize; paper++) {
      var citation = input.citation[paper];
      if (citation >= paper) {
        result.add(paper);
      } else {
        result.add(result.last);
      }
    }
    return result;
  }

  @override
  void store(int test, result) {
    var line = "";
    var list = result as List<dynamic>;
    for (var element in list) {
      line += "$element ";
    }
    output.writeLine("Case #$test: ${line.trimRight()}");
  }
}
