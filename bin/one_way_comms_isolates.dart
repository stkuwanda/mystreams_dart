import 'dart:isolate';

// entry-point of the new isolate
// this is the code that runs in the new isolate
// it takes a SendPort as an argument to communicate back to the main isolate
void playHideAndSeekTheLongVersionSingleMessage(SendPort sendPort) {
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

// entry-point
// this runs in new isolate
void playHideAndSeekTheLongVersionMultipleMessages(SendPort sendPort) {
  sendPort.send("OK, I'm counting..."); // send an initial message
  var counting = 0;

  for (var i = 1; i <= 1000000000; i++) {
    counting = i;
  }

  sendPort.send(
    '$counting! Ready or not, here I come!',
  ); // send the final message

  sendPort.send(null); // send null to indicate completion
}

// entry-point
// this runs in a new isolate
// the entry-point function/method must alway have one argument so using
// a list is a way to allow more arguments into the function
void playHideAndSeekTheLongVersionArgumentList(List<Object> args) {
  final sendPort = args[0] as SendPort;
  final countTo = args[1] as int;
  var counting = 0;

  sendPort.send("OK, I'm counting..."); // send an initial message

  for (var i = 1; i <= countTo; i++) {
    counting = i;
  }

  sendPort.send(
    '$counting! Ready or not, here I come!',
  ); // send the final message

  sendPort.send(null); // send null to indicate completion
}

// entry-point
// this runs in a new isolate
// the entry-point function/method must alway have one argument so using
// a Map is a way to allow more arguments into the function
void playHideAndSeekTheLongVersionArgumentMap(Map<String, Object> args) {
  final sendPort = args['sendPort'] as SendPort;
  final countTo = args['countTo'] as int;
  var counting = 0;

  sendPort.send("OK, I'm counting..."); // send an initial message

  for (var i = 1; i <= countTo; i++) {
    counting = i;
  }

  sendPort.send(
    '$counting! Ready or not, here I come!',
  ); // send the final message

  sendPort.send(null); // send null to indicate completion
}

Future<void> runOneWaySingleMessageIsolate(ReceivePort receivePort) async {
  // Spawn a new isolate, passing the entry-point function and the SendPort of the ReceivePort.
  // Specifying SendPort as the generic type parameter tells Dart the type of the entry-point function parameter.
  // This is a worker isolate being spawned.
  await Isolate.spawn<SendPort>(
    playHideAndSeekTheLongVersionSingleMessage, // The first argument of Isolate.spawn is the entry-point function. That function must be a top-level or static function. It must also take a single argument.
    receivePort
        .sendPort, // The second argument of Isolate.spawn is the argument for the entry-point function. In this case, it’s a SendPort object.
  );

  // ReceivePort implements the Stream interface, so you can treat it like a stream. Calling await
  // receivePort.first waits for the first message coming in the stream and then cancels the stream subscription.
  // playHideAndSeekTheLongVersion only sends a single message; all we need to wait for.
  final message = await receivePort.first as String;
  print(message);
}

Future<void> runOnewWayMultiMessageIsolate(ReceivePort receivePort) async {
  // Spawn a new isolate, passing the entry-point function and the SendPort of the ReceivePort.
  final isolate = await Isolate.spawn<SendPort>(
    playHideAndSeekTheLongVersionMultipleMessages,
    receivePort.sendPort,
  );

  // Listen for messages from the new isolate.
  // Because receivePort is a stream, you can listen to it like any other stream
  receivePort.listen((Object? message) {
    // If the message is a string, you just print it. But if the message is null,
    // that’s the signal to close the receive port and shut down the isolate.
    if (message is String) {
      print(message);
    } else if (message == null) {
      receivePort.close(); // Close the receive port
      isolate.kill(); // Terminate the isolate
    }
  });
}

Future<void> runOnewWayMultiMessageIsolateArgumentList(
  ReceivePort receivePort,
) async {
  // Spawn a new isolate, passing the entry-point function and the SendPort of the ReceivePort.
  final isolate = await Isolate.spawn<List<Object>>(
    playHideAndSeekTheLongVersionArgumentList,
    [receivePort.sendPort, 999999999],
  );

  // Listen for messages from the new isolate.
  // Because receivePort is a stream, you can listen to it like any other stream
  receivePort.listen((Object? message) {
    // If the message is a string, you just print it. But if the message is null,
    // that’s the signal to close the receive port and shut down the isolate.
    if (message is String) {
      print(message);
    } else if (message == null) {
      receivePort.close(); // Close the receive port
      isolate.kill(); // Terminate the isolate
    }
  });
}

Future<void> runOnewWayMultiMessageIsolateArgumentMap(
  ReceivePort receivePort,
) async {
  // Spawn a new isolate, passing the entry-point function and the SendPort of the ReceivePort.
  final isolate = await Isolate.spawn<Map<String, Object>>(
    playHideAndSeekTheLongVersionArgumentMap,
    {'sendPort': receivePort.sendPort, 'countTo': 999999999},
  );

  // Listen for messages from the new isolate.
  // Because receivePort is a stream, you can listen to it like any other stream
  receivePort.listen((Object? message) {
    // If the message is a string, you just print it. But if the message is null,
    // that’s the signal to close the receive port and shut down the isolate.
    if (message is String) {
      print(message);
    } else if (message == null) {
      receivePort.close(); // Close the receive port
      isolate.kill(); // Terminate the isolate
    }
  });
}

void main() {
  final receivePort =
      ReceivePort(); // Create a ReceivePort to receive messages from the new isolate.
  // runOneWaySingleMessageIsolate(receivePort);
  // runOnewWayMultiMessageIsolate(receivePort);
  // runOnewWayMultiMessageIsolateArgumentList(receivePort);
  runOnewWayMultiMessageIsolateArgumentMap(receivePort);
}
