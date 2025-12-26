Future<String> fetchName() async {
  await Future.delayed(Duration(seconds: 2));
  return "John Doe";
}

Future<String> fetchPicture() async {
  await Future.delayed(Duration(seconds: 1));
  return "image_url_here";
}

void main() async {
  print("Loading profile...");

  // Future.wait takes a list of futures and returns a Future<List>
  try {
    List<String> results = await Future.wait([
      fetchName(),
      fetchPicture(),
    ]);

    // results[0] is the name, results[1] is the picture
    print("Profile Loaded: Name: ${results[0]}, Pic: ${results[1]}");
  } catch (e) {
    print("Failed to load profile because one of the requests failed.");
  }
}