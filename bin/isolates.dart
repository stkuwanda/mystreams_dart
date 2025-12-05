void main() {
  print('isolates');

  // Simulate a long-running task.
  print(playHideAndSeekTheLongVersion());
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
