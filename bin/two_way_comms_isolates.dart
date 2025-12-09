import 'dart:io';
import 'dart:isolate';

class Work {
  Future<int> doSomething() async {
    print('doing some work...');
    sleep(Duration(seconds: 1));
    return 42;
  }

  Future<int> doSomethingElse() async {
    print('doing some oher work...');
    sleep(Duration(seconds: 1));
    return 24;
  }
}

// Earth encapsulates all the isolate communication code. It represents the main isolate.
class Earth {
  final _receiveOnEarth = ReceivePort(); // a receive port to listen to messages from the Moon child isolate
  SendPort? _sendToMoonPort; // a send port to send messages back to the Moon. The Moon will give this send port later after the  Moon isolate is spawned
  Isolate? _moonIsolate; // reference to the Moon isolate

  // TODO: create moon isolate

  // When work is finished on the Moon, a call to dispose will shut the isolate down and clean up the resources.
  void dispose() {
    _receiveOnEarth.close(); // Close the receive port
    _moonIsolate?.kill(); // Terminate the isolate
    _moonIsolate = null; // Clear the isolate reference
  }
}

// sendToEarthPort is the send port that belongs to Earth’s receive port.
// The Moon isolate can use this port to send messages back to the Earth isolate.
Future<void> _entryPoint(SendPort sendToEarthPort) async {
  // create a receive port in the child isolate and send its send port back to the parent isolate.
  // Thus, the first “message” you send back to Earth is receiveOnMoonPort.sendPort
  final receiveOnMoonPort = ReceivePort();
  sendToEarthPort.send(receiveOnMoonPort.sendPort);

  // create an instance of Work inside _entryPoint .
  // Now ready to perform the heavy work on the Moon isolate.
  final work = Work();

  receiveOnMoonPort.listen((Object? messageFromEarth) async {
    // The pause simulates the delay in communication between Earth and the Moon
    await Future<void>.delayed(Duration(seconds: 1));
    print('Message from Earth: $messageFromEarth');

    // Respond to Earth messages conditionally
    if (messageFromEarth == 'Hey from Earth') {
      sendToEarthPort.send('Hey from the Moon');
    } else if (messageFromEarth == 'Can you help?') {
      sendToEarthPort.send('sure');
    }
    // Map messages from parent isolate to the work methods
    else if (messageFromEarth == 'doSomething') {
      final result = await work.doSomething();

      // Send back results to earth with result and the instruction/action executed
      sendToEarthPort.send({'method': 'doSomething', 'result': result});
    } else if (messageFromEarth == 'doSomethingElse') {
      final result = await work.doSomethingElse();
      sendToEarthPort.send({'method': 'doSomethingElse', 'result': result});
      sendToEarthPort.send('done');
    }
  });
}

void main() {}
