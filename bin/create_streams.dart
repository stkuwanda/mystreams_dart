

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

void main() {
  runPeriodicStream();
}
