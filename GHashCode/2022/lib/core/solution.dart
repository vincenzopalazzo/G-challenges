import 'package:hashd/core/io_model.dart';
import 'package:logger/logger.dart';

/// Generic Solution wrapper of the Hash Code daemon
///
/// Author: https://github.com/vincenzopalazzo
abstract class Solution<T> {
  final _logger = Logger();
  // Input Wrapper that contains all the information
  // to split the file input
  late final Input? input;
  // Output wrapper that contains all the information
  // to store the result on the in a file
  late final Output? output;

  /// write a informal and well format log message
  void log(String message, {dynamic options}) {
    if (options != null) {
      _logger.i("$message -> $options");
    } else {
      _logger.i(message);
    }
  }

  /// write a well format message log for debug
  void debug(String message, {dynamic options}) {
    if (options != null) {
      _logger.d("$message -> $options");
    } else {
      _logger.d(message);
    }
  }

  /// print message in a raw format with the dart print function
  void rawLog(String message) {
    print(message);
  }

  /// method that must implement the logic to parse the input file
  T parse();

  /// method that need to implement the logic to solve the problem
  dynamic solve(T input);

  /// method that implement the logic to store the result
  void store(dynamic result);

  // Internal method that run all the code to run
  // the problem and call the method in the correct order.
  void run() {
    if (input == null) {
      throw Exception("Input need to be initialized");
    }
    if (output == null) {
      throw Exception("Output need to be initialized");
    }
    var fromFile = parse();
    var result = solve(fromFile);
    store(result);
  }

  void init(Input input, Output output) {
    this.input = input;
    this.output = output;
  }
}
