import 'dart:async';

/// A simple StreamTransformer that doubles each integer
class DoubleTransformer extends StreamTransformerBase<int, int> {
  @override
  Stream<int> bind(Stream<int> stream) {
    // Use map to transform each event
    return stream.map((value) => value * 2);
  }
}

class CustomIntDoubler {
  final StreamTransformerBase<int, int> doubler;

  const CustomIntDoubler(this.doubler);
}

void main() async {
  // Original stream of integers
  Stream<int> numbers = Stream.fromIterable([1, 2, 3, 4]);

  //
  var by2doubler = CustomIntDoubler(DoubleTransformer());

  // Apply our custom transformer
  Stream<int> doubledNumbers = numbers.transform(by2doubler.doubler); // or numbers.transform(DoubleTransformer());

  // Consume the transformed stream
  await for (var n in doubledNumbers) {
    print(n); // prints 2, 4, 6, 8
  }
}
