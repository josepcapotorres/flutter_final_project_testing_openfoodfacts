Map<String, dynamic> deepCast(Map<dynamic, dynamic> source) {
  return source.map((key, value) {
    return MapEntry(
      key.toString(),
      value is Map ? deepCast(value) : value,
    );
  });
}
