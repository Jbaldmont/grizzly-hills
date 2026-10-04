class SpendingEntry {
  const SpendingEntry({
    required this.monthId,
    required this.amountCents,
    this.groupName,
    this.tagId,
  });

  final int monthId;
  final int amountCents;
  final String? groupName;
  final int? tagId;
}

enum SpendingScopeKind { all, group, unexpected }

class SpendingScope {
  const SpendingScope.all() : kind = SpendingScopeKind.all, groupName = null;

  const SpendingScope.group(String this.groupName)
    : kind = SpendingScopeKind.group;

  const SpendingScope.unexpected()
    : kind = SpendingScopeKind.unexpected,
      groupName = null;

  final SpendingScopeKind kind;
  final String? groupName;

  bool includes(SpendingEntry entry) => switch (kind) {
    SpendingScopeKind.all => true,
    SpendingScopeKind.group => entry.groupName == groupName,
    SpendingScopeKind.unexpected => entry.groupName == null,
  };

  @override
  bool operator ==(Object other) =>
      other is SpendingScope &&
      other.kind == kind &&
      other.groupName == groupName;

  @override
  int get hashCode => Object.hash(kind, groupName);
}

class TagAmount {
  const TagAmount({required this.tagId, required this.amountCents});

  final int tagId;
  final int amountCents;
}

class TagStatistics {
  const TagStatistics(this.entries);

  final List<SpendingEntry> entries;

  List<String> get groupNames =>
      {for (final entry in entries) ?entry.groupName}.toList();

  List<TagAmount> tagBreakdown(int monthId, SpendingScope scope) {
    final totalsByTagId = <int, int>{};
    for (final entry in _entriesIn(monthId, scope)) {
      final tagId = entry.tagId;
      if (tagId != null) {
        totalsByTagId[tagId] = (totalsByTagId[tagId] ?? 0) + entry.amountCents;
      }
    }
    final breakdown = [
      for (final MapEntry(key: tagId, value: amountCents)
          in totalsByTagId.entries)
        TagAmount(tagId: tagId, amountCents: amountCents),
    ];
    breakdown.sort(_largestFirst);
    return breakdown;
  }

  int totalCents(int monthId, SpendingScope scope) =>
      _sum(_entriesIn(monthId, scope));

  int untaggedCents(int monthId, SpendingScope scope) =>
      _sum(_entriesIn(monthId, scope).where((entry) => entry.tagId == null));

  int tagCents(int monthId, int tagId, SpendingScope scope) =>
      _sum(_entriesIn(monthId, scope).where((entry) => entry.tagId == tagId));

  Iterable<SpendingEntry> _entriesIn(int monthId, SpendingScope scope) =>
      entries.where(
        (entry) => entry.monthId == monthId && scope.includes(entry),
      );

  static int _sum(Iterable<SpendingEntry> items) =>
      items.fold(0, (sum, entry) => sum + entry.amountCents);

  static int _largestFirst(TagAmount first, TagAmount second) {
    final byAmount = second.amountCents.compareTo(first.amountCents);
    return byAmount != 0 ? byAmount : first.tagId.compareTo(second.tagId);
  }
}
