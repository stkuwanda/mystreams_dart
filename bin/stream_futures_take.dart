import 'dart:async';

Future<String> fetchFromServer(String region, int delaySeconds) async {
  await Future.delayed(Duration(seconds: delaySeconds));
  return "Data from $region (took ${delaySeconds}s)";
}

void main() {
  print("Requesting data from all servers...");

  // 1. Define multiple futures with different speeds
  final List<Future<String>> requests = [
    fetchFromServer("Europe", 3), // Slowest
    fetchFromServer("Africa", 1),   // Fastest
    fetchFromServer("US-East", 2), // Medium
  ];

  // 2. Combine them and apply .take(2)
  // This tells the stream: "Give me the first two that finish, then stop."
  final fastestTwoStream = Stream.fromFutures(requests).take(2);

  // 3. Listen to the results
  fastestTwoStream.listen(
    (data) => print("Received: $data"),
    onDone: () => print("Stream closed: We have the 2 fastest responses."),
  );
}