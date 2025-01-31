List<MapEntry<String, String?>> validAttendance(
    Map<String, String?> attendanceMap) {
  return attendanceMap.entries
      .where((entry) =>
          entry.value != null && (entry.value == 'P' || entry.value == 'A'))
      .toList();
}
