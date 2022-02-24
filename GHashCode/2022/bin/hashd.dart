import 'dart:io';
import 'dart:isolate';

import 'package:args/args.dart';
import 'package:hashd/2022/solution.dart';
import 'package:hashd/core/io_model.dart';
import 'package:hashd/core/solution.dart';
import 'package:hashd/practice_ex/pizzeria_sol.dart';
import 'package:hashd/practice_mia/solution.dart';
import 'package:hashd/2022/solution.dart';
import 'package:logger/logger.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';

const String problemKey = "problem";
const String inputKey = "input";
const String outputKey = "output";
const String silentKey = "silent";
const String inputPathKey = "input_path";
const String outputPathKey = "output_path";

ArgResults configureCommandLine(List<String> args) {
  var parser = ArgParser();
  parser.addOption(problemKey, abbr: "p", help: "Name of the problem");
  parser.addOption(inputKey,
      abbr: "i",
      help: "Input path where the input is located inside the resources",
      defaultsTo: null);
  parser.addOption(outputKey,
      abbr: "o",
      help: "Output name where to store the result to upload",
      defaultsTo: null);
  parser.addOption(inputPathKey,
      abbr: "f",
      help: "Root directory path from read the input files.",
      defaultsTo: null);
  parser.addOption(outputPathKey,
      abbr: "t",
      help: "Root directory path to store the result files.",
      defaultsTo: null);
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
  "2022": SolutionProject(),
};

Future<void> runWorker(
    {required Solution solution,
    required String inputFile,
    required String outputFile,
    bool silentMode = false}) async {
  solution.init(Input(inputFile), Output(outputFile), silentMode);
  await solution.run();
}

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

  var inputPath = cmd[inputPathKey];
  var outputPath = cmd[outputPathKey];
  var parallel = inputPath != null && outputPath != null;
  var solution = problems[problem]!;
  if (parallel) {
    // Dart bug https://github.com/dart-lang/sdk/issues/36983
    final inputsFile = Glob("$inputPath/**.in");
    var receivePort = ReceivePort();
    for (var fileItem in inputsFile.listSync()) {
      output = "$outputPath/${fileItem.basename.split('.')[0]}.out";
      print("Input: ${fileItem.uri}");
      print("Store: $output");
      Isolate.spawn((SendPort port) async {
        await runWorker(
            solution: solution,
            inputFile: fileItem.uri.toString(),
            outputFile: output,
            silentMode: cmd[silentKey]!);
        port.send(true);
        Isolate.exit();
      }, receivePort.sendPort);
    }
    await for (var _ in receivePort) {}
    exit(0);
  }

  await runWorker(
      solution: solution,
      inputFile: input,
      outputFile: output,
      silentMode: cmd[silentKey]!);
  exit(0);
}
