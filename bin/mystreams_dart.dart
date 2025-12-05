import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  // await readFileUsingFutures();
  // readFileUsingCallbackStreams();
  // readFileUsingCallbackStreamsAndCancelStreamSubscriptions();
  // readFileUsingStreamsWithAsyncForInLoop();
  // runTransformStream();
  // runAPeriodicStream();
  // runCustomStreamsFromFeatures();
  // runCustomStreamsFromAsyncGenerator();
  runCustomStreamsUsingStreamController();
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
      // print(data.length);
      print(data);
    },
    onDone: () {
      // The onDone callback is executed when the stream has finished sending all its data.
      print('File reading completed.');
    },
    onError: (e) {
      // The onError callback is executed if an error occurs while reading the file.
      print('Error: $e');
    },
    cancelOnError:
        false, // If set to true, the subscription will be canceled upon encountering an error.
  );
}

void readFileUsingCallbackStreamsAndCancelStreamSubscriptions() {
  final file = File('assets/text_long.txt');
  final stream = file
      .openRead(); // openRead , which returns an object of type Stream<List<int>>. This creates a readable stream of the file's content. // by default, this stream is a single-subscription stream.
  // final broadcastStream = stream.asBroadcastStream(); // Convert the single-subscription stream to a broadcast stream.

  StreamSubscription<List<int>>?
  subscription; // Declare a StreamSubscription variable to hold the subscription.
  subscription = stream.listen(
    (List<int> data) {
      // // The listen method is used to listen for data events from the stream. Each time a chunk of data is available, the provided callback function is executed with that chunk.
      // final contents = String.fromCharCodes(data); // Convert the List<int> to a String using String.fromCharCodes.
      // print(contents); // Print the contents of the chunk to the console.
      print(data.length);
      subscription
          ?.cancel(); // Cancel the subscription after receiving the first chunk of data.
    },
    onDone: () {
      // The onDone callback is executed when the stream has finished sending all its data.
      print('File reading completed.');
    },
    onError: (e) {
      // The onError callback is executed if an error occurs while reading the file.
      print('Error: $e');
    },
    cancelOnError:
        false, // If set to true, the subscription will be canceled upon encountering an error.
  );
}

Future<void> readFileUsingStreamsWithAsyncForInLoop() async {
  try {
    final file = File('assets/text_long.txt');
    final stream = file.openRead();

    // The await for loop is used to asynchronously iterate over each chunk of data emitted by the stream.
    await for (final data in stream) {
      print(data.length);
    }
  } on Exception catch (e) {
    print(e);
  } finally {
    print('All finished.');
  }
}

// Transform Streams
Future<void> runTransformStream() async {
  final file = File('assets/text.txt');
  final byteStream = file
      .openRead(); // This creates a stream of bytes (List<int>).
  final stringStream = byteStream.transform(
    utf8.decoder,
  ); // utf8.decoder is a built-in transformer that converts a stream of bytes (List<int>) into a stream of strings (String) from the dart:convert library.

  // use an await for loop to read the transformed string stream.
  await for (var data in stringStream) {
    print(data);
  }
}

Future<void> runAPeriodicStream() async {
  final stream = Stream<int>.periodic(
    Duration(seconds: 1),
    (value) => value,
  ).take(10); // Stream that emits an integer every second, up to 10 values.

  await for (var data in stream) {
    print(data);
  }
}

void runCustomStreamsFromFeatures() {
  // Create a stream from multiple futures using Stream.fromFutures
  final first = Future(() => 'Row');
  final second = Future(() => 'row');
  final third = Future(() => 'row');
  final fourth = Future.delayed(Duration(milliseconds: 300), () => 'your boat');

  // Stream.fromFutures takes a list of futures and returns a stream that emits the results of those futures as they complete.
  final stream = Stream<String>.fromFutures([first, second, third, fourth]);
  stream.listen(
    print,
  ); // Listen to the stream and print each value as it is emitted.
}

void runCustomStreamsFromAsyncGenerator() {
  final stream =
      consciousnessAsyncGenerator(); // Call the custom async generator function to create the stream.

  stream.listen(
    print,
  ); // Listen to the stream and print each value as it is emitted.
}

// Custom Stream using Async Generator
Stream<String> consciousnessAsyncGenerator() async* {
  const data = ['con', 'scious', 'ness'];

  for (final part in data) {
    // Simulate some asynchronous operation with a delay.
    await Future<void>.delayed(Duration(microseconds: 300));
    yield part; // Yield each part of the data to the stream.
  }
}

// Custom Stream using StreamController
void runCustomStreamsUsingStreamController() {
  final controller =
      StreamController<
        String
      >(); // Create a StreamController to manage the stream and sink.
  final stream = controller.stream; // Get the stream from the controller.
  final sink = controller.sink; // Get the sink from the controller.

  // Listen to the stream and handle data, errors, and completion.
  stream.listen(
    (value) => print(value),
    onError: (Object error) => print(error),
    onDone: () => print('Sink closed'),
  );

  // Add data and errors to the sink.
  sink.add('grape');
  sink.add('grape');
  sink.add('grape');
  sink.addError(Exception('cherry'));
  sink.add('grape');
  sink.close();
}
