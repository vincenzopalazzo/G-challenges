import 'dart:io';

import 'package:args/args.dart';
import 'package:hashd/core/io_model.dart';
import 'package:hashd/core/solution.dart';
import 'package:hashd/practice_ex/pizzeria_sol.dart';
import 'package:hashd/practice_mia/solution.dart';
import 'package:logger/logger.dart';

const String problemKey = "problem";
const String inputKey = "input";
const String outputKey = "output";
const String silentKey = "silent";

ArgResults configureCommandLine(List<String> args) {
  var parser = ArgParser();
  parser.addOption(problemKey, abbr: "p", help: "Name of the problem");
  parser.addOption(inputKey,
      abbr: "i",
      help: "Input path where the input is located inside the resources");
  parser.addOption(outputKey,
      abbr: "o", help: "Output name where to store the result to upload");
  parser.addFlag(silentKey,
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
        "  Author: Vincenzo Palazzo <vincenzopalazzodev@gmail.com> Hash Code Team: hashcode.dart");
    print("  License: MIT\n");
    parser.options.forEach((String key, Option value) {
      print("\t--$key   -${value.abbr}: ${value.help}");
    });
    print(
        "\n\tCommand Example ./hashd --problem one_pizza --input <path> --output <path>\n\n");
    exit(0);
  });
  return parser.parse(args);
}

Map<String, Solution> problems = {
  "one_pizza": OnePizza(),
  "practice_mia": PracticeMia(),
};

Future<void> main(List<String> arguments) async {
  var logger = Logger();
  var cmd = configureCommandLine(arguments);

  var problem = cmd[problemKey];
  var input = cmd[inputKey];
  var output = cmd[outputKey];

  if (!problems.containsKey(problem)) {
    logger.e("Problem with name $problem is not implemented");
    exit(1);
  }
  var solution = problems[problem]!;
  solution.init(Input(input), Output(output), cmd[silentKey]!);
  await solution.run();
  exit(0);
}
