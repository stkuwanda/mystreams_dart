Future<String> fetchValidData() async {
  await Future.delayed(Duration(seconds: 1));
  return "Success Data";
}

Future<String> fetchFailingData() async {
  await Future.delayed(Duration(seconds: 2));
  throw Exception("Server Error!");
}

void main() async {
  print("Fetching data with safety net...");

  // We use .catchError on the specific future that might fail
  List<String?> results = await Future.wait([
    fetchValidData(),
    fetchFailingData().catchError((error) {
      print("Caught internal error: $error");
      return "Default/Fallback Value"; // Return this instead of crashing
    }),
  ]);

  print("Results: $results"); 
  // Output: [Success Data, Default/Fallback Value]
}