Future<String> fetchUsername() async {
  // Simulating a network delay
  await Future.delayed(Duration(seconds: 2));
  return "Alice_2025";
}

void main() async {
  print("Requesting data...");

  // Convert the Future into a Stream
  Stream<String> userStream = Stream.fromFuture(fetchUsername());

  // Listen to the stream
  userStream.listen(
    (data) {
      print("Received from stream: $data"); 
    },
    onDone: () {
      print("Stream is now closed.");
    },
    onError: (e) {
      print("An error occurred: $e");
    },
  );
}