enum TopicType {
  essay,
  short;

  String get label {
    switch (this) {
      case TopicType.essay:
        return 'Essay';
      case TopicType.short:
        return 'Short Answer';
    }
  }
}
