import 'dart:io';

Future<void> longRunningOperation() async {
  for (int i = 0; i < 5; i++) {
    // Simulate a long-running task by pausing code execution for 1 second.
    // The sleep function blocks the main thread and runs synchronously.
    // Even though this function is marked as async, the sleep call will block because it is synchronous.
    // sleep(
    //   Duration(seconds: 1),
    // ); 

    // This line simulates a non-blocking delay, allowing other code to run.
    await Future.delayed(Duration(seconds: 1)); // Yield to the event loop.
    print("Index: $i");
  }
}

void main() async {
  print("Start of long running operation");
  longRunningOperation(); // Call the long-running operation.
  print("Continuing main body");

  // Simulate other work in the main function.
  for (int i = 10; i < 15; i++) {
    // sleep(Duration(seconds: 1));
    await Future.delayed(Duration(seconds: 1)); // Yield to the event loop.
    print("Index from main: $i");
  }

  print("End of main");
}
