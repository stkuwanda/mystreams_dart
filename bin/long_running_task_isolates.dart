import 'dart:isolate';

// entry-point of the new isolate
// this is the code that runs in the new isolate
Future<void> longRunningOperation(String message) async {
  for (int i = 0; i < 5; i++) {
    await Future.delayed(Duration(seconds: 1));
    print("$message: $i");
  }
}

void main() async {
  print("start of long running operation");
  Isolate.spawn(longRunningOperation, "Hello"); // Call the long-running operation in a new isolate.
  print("Continuing main body");

  for (int i = 10; i < 15; i++) {
    await Future.delayed(Duration(seconds: 1));
    print("Index from main: $i");
  }

  print("End of main");
}
