import 'dart:async';

void main() {
  // Create a StreamController
  final controller = StreamController<String>(); // Single-subscription stream controller
  final stream = controller.stream; // Get the stream from the controller
  final sink = controller.sink; // Get the sink to add data to the stream
  
  // Listen to the stream
  stream.listen(
    (value) => print(value), // onData handler
    onError: (Object error) => print(error), // onError handler
    onDone: () => print('Sink closed'), // onDone handler
  );
  
  // Add data and an error to the stream
  sink.add('grape');
  sink.add('orange');
  sink.add('apple');
  sink.addError(Exception('tomato'));
  sink.add('banana');
  sink.close(); // Close the sink when done
}
