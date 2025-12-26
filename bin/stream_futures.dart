Future<String> getProfile() async {
  await Future.delayed(Duration(seconds: 3));
  return "Profile Data";
}

Future<String> getPosts() async {
  await Future.delayed(Duration(seconds: 1));
  return "Post List";
}

Future<String> getSettings() async {
  await Future.delayed(Duration(seconds: 2));
  return "Settings Object";
}

void main() {
  print("Fetching all data in parallel...");

  // We pass a list of futures to the stream
  Stream<String> dashboardStream = Stream.fromFutures([
    getProfile(),
    getPosts(),
    getSettings(),
  ]);

  dashboardStream.listen((data) {
    print("Received: $data");
  }, onDone: () {
    print("All data fetched!");
  });
}