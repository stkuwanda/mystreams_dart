// this is a simple example of an async generator in Dart
Stream<String> consciousness() async* {
  final data = ['con', 'scious', 'ness'];

  for (final part in data) {
    await Future<void>.delayed(Duration(milliseconds: 500));
    yield part;
  }
}

// Function to run the async generator and print its output
void runAsyncGenStream() async {
  final stream = consciousness();

  // Listen to the stream and print each part as it is yielded
  await for (final part in stream) {
    print(part);
  }
}

void main() {
  runAsyncGenStream();
}
