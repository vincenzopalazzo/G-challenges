import 'dart:convert';
import 'dart:io';

class Input {
  final String inputPath;
  late List<String>? lines;

  Input(this.inputPath);

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
    lines = await readLines().toList();
  }

  /// Generic function to take a integer value from the
  /// top of the input stream
  int readInt() {
    var topLine = lines!.first;
    lines = lines!.getRange(1, lines!.length).toList();
    var value = topLine.toString().trim();
    return int.parse(value);
  }

  /// Read a sequence of integer of integer in the same line
  List<int> readInts(int size, {String pattern = " "}) {
    var list = <int>[];
    var topLine = lines!.first.toString();
    lines = lines!.getRange(1, lines!.length).toList();
    topLine.split(pattern).forEach((element) {
      list.add(int.parse(element));
    });
    return list;
  }

  List<String> splitRawLine({String pattern = " "}) {
    var topLine = lines!.first.toString();
    lines = lines!.getRange(1, lines!.length).toList();
    return topLine.split(pattern);
  }
}

class Output {
  final String outPath;
  late final File? file;

  Output(this.outPath);

  void init() {
    file = File(outPath);
    file!.exists().then((value) {
      if (value) {
        file!.delete();
        file!.create();
      }
    });
  }

  void writeLine(dynamic value) {
    file!.writeAsStringSync(value + "\n", mode: FileMode.append, flush: true);
  }
}
