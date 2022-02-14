/// The iterator solution is the concept to help
/// to parse the input in a class and make
/// easy the iteration
///
/// Author: https://github.com/vincenzopalazzo
class IteratorSolution<T> {
  /// The number of test to run in the problem
  int tests;

  /// The list of the input for each test
  List<T> input = List.empty(growable: true);

  IteratorSolution({this.tests = 0});
}
