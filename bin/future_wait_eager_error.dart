Future<String> checkWeather() async {
  await Future.delayed(Duration(seconds: 10)); // Very slow
  return "Weather Clear";
}

Future<String> checkEngine() async {
  await Future.delayed(Duration(seconds: 1)); // Very fast
  throw "ENGINE FAILURE!";
}

void main() async {
  print("Starting mission checks...");
  Stopwatch sw = Stopwatch()..start();

  try {
    await Future.wait([
      checkWeather(),
      checkEngine(),
    ], eagerError: true); // Throw error as soon as checkEngine fails
  } catch (e) {
    print("Aborted mission at ${sw.elapsed.inSeconds}s: $e");
    // This will print at ~1 second because of eagerError: true
  }
}
