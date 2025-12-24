import 'dart:async';

// Example of a Broadcast Stream using StreamController
void runBroadcastStreamWithController() {
  // Create a controller with broadcast capability
  var controller = StreamController<int>.broadcast();

  // First listener
  // Broadcast streams allow multiple listeners to subscribe to the same stream.
  controller.stream.listen((data) {
    print('Listener 1 got: $data');
  });

  // Second listener
  controller.stream.listen((data) {
    print('Listener 2 got: $data');
  });

  // Add events
  // Hot stream: Broadcast streams start emitting immediately when events are added,
  // regardless of whether listeners are attached.
  controller.add(1);
  controller.add(2);
  controller.add(3);

  // Close the controller
  controller
      .close(); // Always close the controller when done to free resources. This will also close the stream.
}

void runConvertSingleSubscripptionStreamToBroadcastStream() {
  // Create a single-subscription stream
  Stream<int> numbers = Stream.fromIterable(
    [1, 2, 3],
  ); // Single-subscription streams: Only one listener allowed. A second listener throws a Bad state: Stream has already been listened to.

  // Convert it into a broadcast stream
  Stream<int> broadcastNumbers = numbers
      .asBroadcastStream(); // Broadcast streams: Multiple listeners allowed, each gets the same events.

  // Hot behavior: If you attach listeners after some events have already been emitted,
  // those late listeners won’t receive past events—they only get future ones.

  // First listener
  broadcastNumbers.listen((n) {
    print('Listener 1 got: $n');
  });

  // Second listener
  broadcastNumbers.listen((n) {
    print('Listener 2 got: $n');
  });
}

void main() {
  // runBroadcastStreamWithController();
  runConvertSingleSubscripptionStreamToBroadcastStream();
}
