import 'dart:io';

Future<void> main() async {
  final file = File(
    'assets/text.txt',
  ); // File takes the relative path to your text file as the argument.
  final contents = await file
      .readAsString(); // readAsString returns Future<String> , but by using await , you’ll receive the string itself when it’s ready.
  print(contents);
}
