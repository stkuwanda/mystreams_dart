Future<String> fetchFromCache() async {
  await Future.delayed(Duration(milliseconds: 500));
  return "  alice_smith  ";
}

Future<String> fetchFromDatabase() async {
  await Future.delayed(Duration(seconds: 1));
  return "BOB_JONES";
}

Future<String> fetchFromLegacyApi() async {
  await Future.delayed(Duration(seconds: 2));
  return "  ChArLiE_bRoWn  ";
}

void main() {
  final List<Future<String>> sources = [
    fetchFromCache(),
    fetchFromDatabase(),
    fetchFromLegacyApi(),
  ];

  // 1. Combine them.
  // 2. Apply UNIFIED transformation logic using .map()
  final cleanedNamesStream = Stream.fromFutures(sources).map((name) {
    print("--- Processing raw data: '$name' ---");
    return name.trim().toLowerCase().replaceAll('_', ' ');
  });

  // 3. Listen to the final result
  cleanedNamesStream.listen((cleanName) {
    print("Clean Result: $cleanName");
  });
}