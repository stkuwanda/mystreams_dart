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
  controller.close(); // Always close the controller when done to free resources. This will also close the stream.
}

void main() {
  runBroadcastStreamWithController();
}
