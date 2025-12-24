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

// Example of pseudo-broadcast Stream with async/await and cancellation
// This is a more advanced example demonstrating multiple listeners,
// but is not a genuine example of a broadcast stream since it uses async/await.
// However, it shows how to manage multiple listeners with cancellation.
void runBroadcastStreamWithAsyncAwait() async {
  // Create a single-subscription stream
  Stream<int> numbers = Stream.fromIterable([1, 2, 3]);

  // Convert to broadcast stream with callbacks
  Stream<int> broadcastNumbers = numbers;

  // Convert to broadcast stream with callbacks
  // Stream<int> broadcastNumbers = numbers.asBroadcastStream(
  //   onListen: (subscription) {
  //     print('A listener subscribed!');
  //   }, // Callback when a listener subscribes
  //   onCancel: (subscription) {
  //     print('A listener unsubscribed!');
  //   }, // Callback when a listener unsubscribes
  // );

  // Listener 1: consumes the entire stream using await for
  Future<void> listener1() async {
    await for (final n in broadcastNumbers) {
      print('Listener 1 got: $n');
    }

    print('Listener 1 completed');
  }

  // Listener 2: subscribes, consumes two events, then unsubscribes (cancel)
  // StreamIterator gives us explicit control and a cancel() method while still using async/await.
  Future<void> listener2() async {
    final it = StreamIterator(
      broadcastNumbers,
    ); // Create a StreamIterator to manage the subscription
    var count = 0; // Count of events received

    while (await it.moveNext()) {
      print('Listener 2 got: ${it.current}');
      count++;
      if (count == 2) {
        await it.cancel(); // Triggers onCancel
        print('Listener 2 cancelled after two events');
        break;
      }
    }
  }

  // Second async listener
  Future<void> listener3() async {
    await for (var n in broadcastNumbers) {
      print('Listener 3 got: $n');
    }

    print('Listener 3 completed');
  }

  // Run both listeners concurrently
  await Future.wait([
    listener1(),
    listener2(),
    listener3(),
  ]); // Wait for both listeners to complete

  print('All listeners done');
}

// This function demonstrates a genuine broadcast stream with subscription listening and cancellation callbacks.
void runBroadcastWithSubscriptionListeningAndCancellation() {
  // Create a single-subscription stream
  Stream<int> numbers = Stream.fromIterable([1, 2, 3]);

  // Convert to broadcast stream with callbacks
  Stream<int> broadcastNumbers = numbers.asBroadcastStream(
    onListen: (subscription) {
      print('A listener subscribed!');
    },
    onCancel: (subscription) {
      print('A listener unsubscribed!');
    },
  );

  // First listener
  broadcastNumbers.listen(
    (n) {
      print('Listener 1 got: $n');
    },
    onDone: () {
      print('Listener 1 done');
    },
  );

  // Second listener: cancels after receiving 2 events
  StreamSubscription<int>? sub2;
  int count = 0;

  sub2 = broadcastNumbers.listen((n) {
    print('Listener 2 got: $n');
    count++;
    
    if (count == 2) {
      sub2?.cancel(); // triggers onCancel
      print('Listener 2 cancelled after 2 events');
    }
  });
}

void main() {
  // runBroadcastStreamWithController();
  // runConvertSingleSubscripptionStreamToBroadcastStream();
  // runBroadcastStreamWithAsyncAwait();
  runBroadcastWithSubscriptionListeningAndCancellation();
}
