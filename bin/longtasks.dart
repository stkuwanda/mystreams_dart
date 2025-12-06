Future<void> main() async {
  print('isolates');

  // Simulate a long-running task.
  print(await playHideAndSeekTheLongVersionFutures());
}

// A function that simulates a long-running task.
String playHideAndSeekTheLongVersion() {
  var counting = 0;

  // Simulate a long computation by counting to a large number.
  for (var i = 1; i <= 10000000000; i++) {
    counting = i;
  }

  return '$counting! Ready or not, here I come!';
}

// An asynchronous version of the long-running task using Future.
Future<String> playHideAndSeekTheLongVersionFutures() async {
  var counting = 0;

  // Simulate a long computation by counting to a large number asynchronously.
  await Future(() {
    for (var i = 1; i <= 10000000000; i++) {
      counting = i;
    }
  });

  return '$counting! Ready or not, here I come!';
}
