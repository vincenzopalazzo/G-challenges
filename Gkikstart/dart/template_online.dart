// @dart=2.10
import 'dart:convert';
import 'dart:io';

class Input {
  final String inputPath;
  List<String> lines;
  bool isStd = false;

  Input(this.inputPath) {
    if (inputPath.isEmpty) {
      isStd = true;
      // Not include this line inside the kikstart env
      // stdin.pipe(stdout);
    }
  }

  /// low level method to read the lines in the file
  /// useful for not standard input file
  Stream<String> readLines() {
    return File(inputPath)
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter());
  }

  /// Top method to parse the input file
  Future<void> parse() async {
    if (!isStd) {
      lines = await readLines().toList();
    }
  }

  /// Generic function to take a integer value from the
  /// top of the input stream
  int readInt() {
    var line = stdin.readLineSync().trim();
    return int.parse(line);
  }

  /// Read a sequence of integer of integer in the same line
  List<int> readInts(int size, {String pattern = " "}) {
    var list = <int>[];

    var line = stdin.readLineSync();
    line.split(pattern).forEach((element) => list.add(int.parse(element)));
    return list;
  }

  List<String> splitRawLine({String pattern = " "}) {
    var line = stdin.readLineSync();
    return line.split(pattern);
  }
}

class Output {
  final String outPath;
  bool isStd = false;

  Output(this.outPath) {
    isStd = outPath.isEmpty;
  }

  void init() {}

  void writeLine(dynamic value) {
    print(value);
  }
}

class IteratorSolution<T> {
  /// The number of test to run in the problem
  int tests;

  /// The list of the input for each test
  List<T> input = List.empty(growable: true);

  IteratorSolution({this.tests = 0});
}

// Generic Solution wrapper of the Hash Code daemon
///
/// Author: https://github.com/vincenzopalazzo
abstract class SolutionLocal<T> {
  bool silent = false;
  // Input Wrapper that contains all the information
  // to split the file input
  Input input;
  // Output wrapper that contains all the information
  // to store the result on the in a file
  Output output;

  /// write a informal and well format log message
  void log(dynamic message, {dynamic options}) {
    if (silent) {
      return;
    }
    if (options != null) {
      rawLog("$message -> $options");
    } else {
      rawLog(message);
    }
  }

  /// write a well format message log for debug
  void debug(dynamic message, {dynamic options}) {
    if (silent) {
      return;
    }
    if (options != null) {
      rawLog("$message -> $options");
    } else {
      rawLog(message);
    }
  }

  /// print message in a raw format with the dart print function
  void rawLog(dynamic message) {
    if (!silent) {
      print(message);
    }
  }

  /// method that must implement the logic to parse the input file
  IteratorSolution<T> parse(IteratorSolution<T> inputs);

  /// method that need to implement the logic to solve the problem
  dynamic solve(T input);

  /// method that implement the logic to store the result
  void store(int test, dynamic result);

  // Internal method that run all the code to run
  // the problem and call the method in the correct order.
  Future<void> run() async {
    if (input == null) {
      throw Exception("Input need to be initialized");
    }
    if (output == null) {
      throw Exception("Output need to be initialized");
    }
    await input.parse();
    output.init();
    var fromInput = parse(IteratorSolution());
    for (var test = 1; test <= fromInput.tests; test++) {
      var result = solve(fromInput.input[test - 1]);
      store(test, result);
    }
    exit(0);
  }

  void init(Input input, Output output, bool silent) {
    this.input = input;
    this.output = output;
    this.silent = silent;
  }
}

void main() {
  var solution = SampleSolution();
  solution.init(Input(''), Output(''), true);
  solution.run();
}

/// Put your solution implementation
class CandyDistributor {
  int kidsSize = 0;
  int totCandy = 0;
  List<CandyBag> candyBags = List.empty(growable: true);
}

class CandyBag {
  int candyContained;

  CandyBag(this.candyContained);
}

class SampleSolution extends SolutionLocal<CandyDistributor> {
  @override
  IteratorSolution<CandyDistributor> parse(
      IteratorSolution<CandyDistributor> inputs) {
    inputs.tests = input.readInt();
    log("Tests: ${inputs.tests}");
    for (var test = 0; test < inputs.tests; test++) {
      var distributor = CandyDistributor();
      var inputSize = input.readInts(2);
      var candyBags = inputSize[0];
      distributor.kidsSize = inputSize[1];
      var candyInBags = input.readInts(candyBags);
      for (var candyInBag in candyInBags) {
        distributor.totCandy += candyInBag;
        //distributor.candyBags.add(CandyBag(candyInBag));
      }
      inputs.input.add(distributor);
    }

    return inputs;
  }

  @override
  solve(CandyDistributor input) {
    if (input.kidsSize == 0) {
      return 0;
    }
    var totCandy = input.totCandy;
    var forEachKids = totCandy ~/ input.kidsSize;
    log("For each kids: $forEachKids");
    log("Tot candy: $totCandy");
    return totCandy - (input.kidsSize * forEachKids);
  }

  @override
  void store(int test, result) {
    output.writeLine("Case #$test: $result");
  }
}
