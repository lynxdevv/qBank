class IdUtils {
  static String extractSubjectFromId(String id) {
    final parts = id.split('_');
    if (parts.length >= 2) return parts[1];
    return '';
  }

  static String formatBookCode(String code) {
    final mapping = <String, String>{
      'PH-kdtemp': 'KDT',
      'PH-tarav': 'Tara',
      'PA-kdtemp': 'KDT',
      'PA-tarav': 'Tara',
      'MB-kdtemp': 'KDT',
      'MB-tarav': 'Tara',
    };
    return mapping[code] ?? code;
  }
}
