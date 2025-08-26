

String getImageUrlWithTimestamp(String originalImageUrl) {
  // Extracting the base URL and query parameters
  Uri originalUri = Uri.parse(originalImageUrl);
  String baseUrl = originalUri.origin + originalUri.path;
  Map<String, String> queryParams = Map.from(originalUri.queryParameters);

  // Appending timestamp to the query parameters
  queryParams['timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();

  // Constructing the new URL with updated query parameters
  Uri updatedUri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
  return updatedUri.toString();
}

//date Format
DateTime parseDateTime(String createdOn) {
  DateTime createdTime = DateTime.parse(createdOn);
  return createdTime;
}
