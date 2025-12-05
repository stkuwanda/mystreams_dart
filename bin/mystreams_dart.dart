import 'dart:io';

Future<void> main() async {
  // await readFileUsingFutures();
  // readFileUsingCallbackStreams();
  readFileUsingStreamsWithAsyncForInLoop();
}

Future<void> readFileUsingFutures() async {
  final file = File(
    'assets/text.txt',
  ); // File takes the relative path to your text file as the argument.
  final contents = await file
      .readAsString(); // readAsString returns Future<String> , but by using await , you’ll receive the string itself when it’s ready.
  print(contents);
}

void readFileUsingCallbackStreams() {
  final file = File('assets/text_long.txt');
  final stream = file
      .openRead(); // openRead , which returns an object of type Stream<List<int>>. This creates a readable stream of the file's content. // by default, this stream is a single-subscription stream.
  // final broadcastStream = stream.asBroadcastStream(); // Convert the single-subscription stream to a broadcast stream.

  stream.listen(
    (List<int> data) {
      // // The listen method is used to listen for data events from the stream. Each time a chunk of data is available, the provided callback function is executed with that chunk.
      // final contents = String.fromCharCodes(data); // Convert the List<int> to a String using String.fromCharCodes.
      // print(contents); // Print the contents of the chunk to the console.
      print(data.length);
    },
    onDone: () {
      // The onDone callback is executed when the stream has finished sending all its data.
      print('File reading completed.');
    },
    onError: (e) {
      // The onError callback is executed if an error occurs while reading the file.
      print('Error: $e');
    },
  );
}

Future<void> readFileUsingStreamsWithAsyncForInLoop() async {
  final file = File('assets/text_long.txt');
  final stream = file.openRead();

  await for (final data in stream) {
    print(data.length);
  }
}
