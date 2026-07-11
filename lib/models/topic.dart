import 'topic_type.dart';

class Reference {
  final String bookCode;
  final int? edition;
  final int? volume;
  final int? page;

  const Reference({
    required this.bookCode,
    this.edition,
    this.volume,
    this.page,
  });

  String get displayName {
    final parts = <String>[bookCode];
    if (edition != null) parts.add('${edition}th Ed');
    if (page != null) parts.add('p.$page');
    return parts.join(', ');
  }

  static Reference parse(String raw) {
    final cleaned = raw.trim();
    String bookCode = '';
    int? edition;
    int? volume;
    int? page;

    if (cleaned.startsWith('@book?')) {
      final params = cleaned.substring(6);
      final segments = params.split('&');
      for (final seg in segments) {
        if (seg.startsWith('n=')) {
          bookCode = seg.substring(2);
        } else if (seg.startsWith('ed=')) {
          edition = int.tryParse(seg.substring(3));
        } else if (seg.startsWith('vol=')) {
          volume = int.tryParse(seg.substring(4));
        }
      }
    } else {
      bookCode = cleaned;
    }

    final hashIndex = cleaned.indexOf('#');
    if (hashIndex != -1) {
      page = int.tryParse(cleaned.substring(hashIndex + 1));
    }

    return Reference(
      bookCode: bookCode,
      edition: edition,
      volume: volume,
      page: page,
    );
  }
}

class Topic {
  final String id;
  final String title;
  final String? descriptions;
  final bool hasPreviouslyBeenAsked;
  final int importance;
  final List<String> yearsAsked;
  final String? probableCases;
  final List<Reference> references;
  final TopicType type;

  const Topic({
    required this.id,
    required this.title,
    this.descriptions,
    required this.hasPreviouslyBeenAsked,
    required this.importance,
    required this.yearsAsked,
    this.probableCases,
    required this.references,
    required this.type,
  });

  int get timesAsked => yearsAsked.length;

  List<String> get parsedDescriptionLines {
    if (descriptions == null || descriptions!.isEmpty) return [];
    return descriptions!
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .map((l) => l.startsWith('- ') ? l.substring(2) : l)
        .toList();
  }

  factory Topic.fromCsvRow(Map<String, String> row) {
    String lookup(String key) {
      return row[key] ?? row[key.toLowerCase()] ?? row[key.replaceAll(RegExp(r'[^A-Za-z]'), '')] ?? '';
    }

    final rawId = lookup('Id');
    final type = rawId.startsWith('E_') ? TopicType.essay : TopicType.short;

    final yearsRaw = lookup('YearsAsked');
    final years = yearsRaw
        .split(';')
        .map((y) => y.trim())
        .where((y) => y.isNotEmpty)
        .toList();

    final refsRaw = lookup('References');
    final refs = refsRaw
        .split(';')
        .map((r) => r.trim())
        .where((r) => r.isNotEmpty)
        .map(Reference.parse)
        .toList();

    return Topic(
      id: rawId,
      title: lookup('Title'),
      descriptions: lookup('Descriptions').isEmpty ? null : lookup('Descriptions'),
      hasPreviouslyBeenAsked: lookup('HasPreviouslyBeenAsked').toLowerCase() == 'true',
      importance: int.tryParse(lookup('Importance')) ?? 0,
      yearsAsked: years,
      probableCases: lookup('ProbableCases').isEmpty ? null : lookup('ProbableCases'),
      references: refs,
      type: type,
    );
  }
}
