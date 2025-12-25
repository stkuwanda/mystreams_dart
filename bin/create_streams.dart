// Creates a periodic stream that emits integers every second and prints them.
void runPeriodicStream() async {
  // The named constructor takes two parameters a duration and a computation function.
  // The computation function receives an integer value that starts at 0 and increments by 1 for each event.
  Stream<int> streamInts = Stream.periodic(
    Duration(seconds: 1),
    (value) => value,
  ).take(10);

  // Listen to the stream and print each emitted integer
  await for (final data in streamInts) {
    print(data);
  }
}

void runEmptyStream() {
  var emptyStream = Stream.empty();

  emptyStream.listen(
    (data) => print("This will never print: $data"),
    onDone: () => print("Stream reached the end immediately!"),
  );
}

// The most common use for Stream.empty() is in functions that must return a Stream, but where you sometimes
// have no data to provide based on a certain condition.
// Imagine a search function that only searches if the query is at least 3 characters long:
Stream<String> searchDatabase(String query) {
  if (query.length < 3) {
    // We must return a Stream, but we have no results to give.
    return Stream.empty();
  }

  // Otherwise, return a real stream of data
  return Stream.fromIterable(["Result 1", "Result 2"]);
}

void runConditionalWithStream() {
  Stream<String> stream = searchDatabase('we');

  stream.listen(
    (data) => print("Data: $data"),
    onDone: () => print("Stream reached the end."),
  );
}

void main() {
  // runPeriodicStream();
  // runEmptyStream();
  runConditionalWithStream();
}
