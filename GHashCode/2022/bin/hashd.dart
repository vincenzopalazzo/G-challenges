import 'dart:io';

import 'package:args/args.dart';
import 'package:hashd/core/io_model.dart';
import 'package:hashd/core/solution.dart';
import 'package:hashd/practice_ex/pizzeria_sol.dart';
import 'package:logger/logger.dart';

final String PROBLEM_KEY = "problem";
final String INPUT_KEY = "input";
final String OUTPUT_KEY = "output";
final String SILENT = "silent";

ArgResults configureCommandLine(List<String> args) {
  var parser = ArgParser();
  parser.addOption(PROBLEM_KEY, abbr: "p", help: "Name of the problem");
  parser.addOption(INPUT_KEY,
      abbr: "i",
      help: "Input path where the input is located inside the resources");
  parser.addOption(OUTPUT_KEY,
      abbr: "o", help: "Output name where to store the result to upload");
  parser.addFlag(SILENT,
      abbr: "s",
      help: "Avoid to print value on the console, useful to make",
      defaultsTo: false);
  parser.addFlag("help", abbr: "h", help: "print the command line help",
      callback: (help) {
    if (!help) {
      return;
    }
    print("\n  Welcome in the Hash Code daemon 2022");
    print(
        "  Author: Vincenzo Palazzo <vincenzopalazzodev@gmail.com> Hash Code Team: <TODO>");
    print("  License: TODO\n");
    parser.options.forEach((String key, Option value) {
      print("\t--$key   -${value.abbr}: ${value.help}");
    });
    print("\n\tCommand Example ./hashd --problem one_pizza --input <path> --output <path>\n\n");
    exit(0);
  });
  return parser.parse(args);
}

Map<String, Solution> PROBLEMS = {
  "one_pizza": OnePizza(),
};

void main(List<String> arguments) {
  var logger = Logger();
  var cmd = configureCommandLine(arguments);

  var problem = cmd[PROBLEM_KEY];
  var input = cmd[INPUT_KEY];
  var output = cmd[OUTPUT_KEY];

  if (!PROBLEMS.containsKey(problem)) {
    logger.e("Problem with name $problem is not implemented");
    exit(1);
  }
  var solution = PROBLEMS[problem]!;
  solution.init(Input(input), Output(output));
  solution.run();
  exit(0);
}
