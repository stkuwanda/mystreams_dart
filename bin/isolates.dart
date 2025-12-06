import 'dart:isolate';

// entry-point of the new isolate
// this is the code that runs in the new isolate
// it takes a SendPort as an argument to communicate back to the main isolate
void playHideAndSeekTheLongVersion(SendPort sendPort) {
  var counting = 0;

  for (var i = 1; i <= 1000000000; i++) {
    counting = i;
  }

  // set a message for the main isolate
  final message = '$counting! Ready or not, here I come!';

  Isolate.exit(
    sendPort,
    message,
  ); // Send a message back to the main isolate and terminate isolate
}

Future<void> main() async {
  final receivePort = ReceivePort(); // Create a ReceivePort to receive messages from the new isolate.

  // Spawn a new isolate, passing the entry-point function and the SendPort of the ReceivePort.
  // Specifying SendPort as the generic type parameter tells Dart the type of the entry-point function parameter.
  await Isolate.spawn<SendPort>(
    playHideAndSeekTheLongVersion, // The first argument of Isolate.spawn is the entry-point function. That function must be a top-level or static function. It must also take a single argument.
    receivePort.sendPort, // The second argument of Isolate.spawn is the argument for the entry-point function. In this case, it’s a SendPort object.
  );

  // ReceivePort implements the Stream interface, so you can treat it like a stream. Calling await
  // receivePort.first waits for the first message coming in the stream and then cancels the stream subscription.
  // playHideAndSeekTheLongVersion only sends a single message; all we need to wait for.
  final message = await receivePort.first as String;
  print(message);
}
