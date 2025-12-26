Future<String> checkServer(String name, String status, int delay) async {
  await Future.delayed(Duration(seconds: delay));
  return status;
}

void main() async {
  final checks = [
    checkServer("Server A", "Healthy", 1),
    checkServer("Server B", "Healthy", 2),
    checkServer("Server C", "Unhealthy", 3), // This will trigger the stop
    checkServer("Server D", "Healthy", 4),   // This will be ignored
  ];

  print("Starting health checks...");

  final healthyStream = Stream.fromFutures(checks)
      .takeWhile((status) => status == "Healthy");

  healthyStream.listen(
    (status) => print("Result: $status"),
    onDone: () => print("Stream stopped because a non-healthy server was found."),
  );
}