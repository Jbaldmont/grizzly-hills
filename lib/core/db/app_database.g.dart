// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MonthsTable extends Months with TableInfo<$MonthsTable, Month> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salaryCentsMeta = const VerificationMeta(
    'salaryCents',
  );
  @override
  late final GeneratedColumn<int> salaryCents = GeneratedColumn<int>(
    'salary_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
    'closed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    year,
    month,
    salaryCents,
    createdAt,
    closedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'months';
  @override
  VerificationContext validateIntegrity(
    Insertable<Month> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('salary_cents')) {
      context.handle(
        _salaryCentsMeta,
        salaryCents.isAcceptableOrUnknown(
          data['salary_cents']!,
          _salaryCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_salaryCentsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {year, month},
  ];
  @override
  Month map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Month(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      salaryCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}salary_cents'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}closed_at'],
      ),
    );
  }

  @override
  $MonthsTable createAlias(String alias) {
    return $MonthsTable(attachedDatabase, alias);
  }
}

class Month extends DataClass implements Insertable<Month> {
  final int id;
  final int year;
  final int month;
  final int salaryCents;
  final DateTime createdAt;
  final DateTime? closedAt;
  const Month({
    required this.id,
    required this.year,
    required this.month,
    required this.salaryCents,
    required this.createdAt,
    this.closedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['salary_cents'] = Variable<int>(salaryCents);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    return map;
  }

  MonthsCompanion toCompanion(bool nullToAbsent) {
    return MonthsCompanion(
      id: Value(id),
      year: Value(year),
      month: Value(month),
      salaryCents: Value(salaryCents),
      createdAt: Value(createdAt),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
    );
  }

  factory Month.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Month(
      id: serializer.fromJson<int>(json['id']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      salaryCents: serializer.fromJson<int>(json['salaryCents']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'salaryCents': serializer.toJson<int>(salaryCents),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
    };
  }

  Month copyWith({
    int? id,
    int? year,
    int? month,
    int? salaryCents,
    DateTime? createdAt,
    Value<DateTime?> closedAt = const Value.absent(),
  }) => Month(
    id: id ?? this.id,
    year: year ?? this.year,
    month: month ?? this.month,
    salaryCents: salaryCents ?? this.salaryCents,
    createdAt: createdAt ?? this.createdAt,
    closedAt: closedAt.present ? closedAt.value : this.closedAt,
  );
  Month copyWithCompanion(MonthsCompanion data) {
    return Month(
      id: data.id.present ? data.id.value : this.id,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      salaryCents: data.salaryCents.present
          ? data.salaryCents.value
          : this.salaryCents,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Month(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('salaryCents: $salaryCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('closedAt: $closedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, year, month, salaryCents, createdAt, closedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Month &&
          other.id == this.id &&
          other.year == this.year &&
          other.month == this.month &&
          other.salaryCents == this.salaryCents &&
          other.createdAt == this.createdAt &&
          other.closedAt == this.closedAt);
}

class MonthsCompanion extends UpdateCompanion<Month> {
  final Value<int> id;
  final Value<int> year;
  final Value<int> month;
  final Value<int> salaryCents;
  final Value<DateTime> createdAt;
  final Value<DateTime?> closedAt;
  const MonthsCompanion({
    this.id = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.salaryCents = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.closedAt = const Value.absent(),
  });
  MonthsCompanion.insert({
    this.id = const Value.absent(),
    required int year,
    required int month,
    required int salaryCents,
    this.createdAt = const Value.absent(),
    this.closedAt = const Value.absent(),
  }) : year = Value(year),
       month = Value(month),
       salaryCents = Value(salaryCents);
  static Insertable<Month> custom({
    Expression<int>? id,
    Expression<int>? year,
    Expression<int>? month,
    Expression<int>? salaryCents,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? closedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (salaryCents != null) 'salary_cents': salaryCents,
      if (createdAt != null) 'created_at': createdAt,
      if (closedAt != null) 'closed_at': closedAt,
    });
  }

  MonthsCompanion copyWith({
    Value<int>? id,
    Value<int>? year,
    Value<int>? month,
    Value<int>? salaryCents,
    Value<DateTime>? createdAt,
    Value<DateTime?>? closedAt,
  }) {
    return MonthsCompanion(
      id: id ?? this.id,
      year: year ?? this.year,
      month: month ?? this.month,
      salaryCents: salaryCents ?? this.salaryCents,
      createdAt: createdAt ?? this.createdAt,
      closedAt: closedAt ?? this.closedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (salaryCents.present) {
      map['salary_cents'] = Variable<int>(salaryCents.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthsCompanion(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('salaryCents: $salaryCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('closedAt: $closedAt')
          ..write(')'))
        .toString();
  }
}

class $BudgetGroupsTable extends BudgetGroups
    with TableInfo<$BudgetGroupsTable, BudgetGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _monthIdMeta = const VerificationMeta(
    'monthId',
  );
  @override
  late final GeneratedColumn<int> monthId = GeneratedColumn<int>(
    'month_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES months (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetCentsMeta = const VerificationMeta(
    'budgetCents',
  );
  @override
  late final GeneratedColumn<int> budgetCents = GeneratedColumn<int>(
    'budget_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    monthId,
    name,
    budgetCents,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('month_id')) {
      context.handle(
        _monthIdMeta,
        monthId.isAcceptableOrUnknown(data['month_id']!, _monthIdMeta),
      );
    } else if (isInserting) {
      context.missing(_monthIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('budget_cents')) {
      context.handle(
        _budgetCentsMeta,
        budgetCents.isAcceptableOrUnknown(
          data['budget_cents']!,
          _budgetCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_budgetCentsMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      monthId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      budgetCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}budget_cents'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $BudgetGroupsTable createAlias(String alias) {
    return $BudgetGroupsTable(attachedDatabase, alias);
  }
}

class BudgetGroup extends DataClass implements Insertable<BudgetGroup> {
  final int id;
  final int monthId;
  final String name;
  final int budgetCents;
  final int position;
  const BudgetGroup({
    required this.id,
    required this.monthId,
    required this.name,
    required this.budgetCents,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['month_id'] = Variable<int>(monthId);
    map['name'] = Variable<String>(name);
    map['budget_cents'] = Variable<int>(budgetCents);
    map['position'] = Variable<int>(position);
    return map;
  }

  BudgetGroupsCompanion toCompanion(bool nullToAbsent) {
    return BudgetGroupsCompanion(
      id: Value(id),
      monthId: Value(monthId),
      name: Value(name),
      budgetCents: Value(budgetCents),
      position: Value(position),
    );
  }

  factory BudgetGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetGroup(
      id: serializer.fromJson<int>(json['id']),
      monthId: serializer.fromJson<int>(json['monthId']),
      name: serializer.fromJson<String>(json['name']),
      budgetCents: serializer.fromJson<int>(json['budgetCents']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'monthId': serializer.toJson<int>(monthId),
      'name': serializer.toJson<String>(name),
      'budgetCents': serializer.toJson<int>(budgetCents),
      'position': serializer.toJson<int>(position),
    };
  }

  BudgetGroup copyWith({
    int? id,
    int? monthId,
    String? name,
    int? budgetCents,
    int? position,
  }) => BudgetGroup(
    id: id ?? this.id,
    monthId: monthId ?? this.monthId,
    name: name ?? this.name,
    budgetCents: budgetCents ?? this.budgetCents,
    position: position ?? this.position,
  );
  BudgetGroup copyWithCompanion(BudgetGroupsCompanion data) {
    return BudgetGroup(
      id: data.id.present ? data.id.value : this.id,
      monthId: data.monthId.present ? data.monthId.value : this.monthId,
      name: data.name.present ? data.name.value : this.name,
      budgetCents: data.budgetCents.present
          ? data.budgetCents.value
          : this.budgetCents,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetGroup(')
          ..write('id: $id, ')
          ..write('monthId: $monthId, ')
          ..write('name: $name, ')
          ..write('budgetCents: $budgetCents, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, monthId, name, budgetCents, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetGroup &&
          other.id == this.id &&
          other.monthId == this.monthId &&
          other.name == this.name &&
          other.budgetCents == this.budgetCents &&
          other.position == this.position);
}

class BudgetGroupsCompanion extends UpdateCompanion<BudgetGroup> {
  final Value<int> id;
  final Value<int> monthId;
  final Value<String> name;
  final Value<int> budgetCents;
  final Value<int> position;
  const BudgetGroupsCompanion({
    this.id = const Value.absent(),
    this.monthId = const Value.absent(),
    this.name = const Value.absent(),
    this.budgetCents = const Value.absent(),
    this.position = const Value.absent(),
  });
  BudgetGroupsCompanion.insert({
    this.id = const Value.absent(),
    required int monthId,
    required String name,
    required int budgetCents,
    required int position,
  }) : monthId = Value(monthId),
       name = Value(name),
       budgetCents = Value(budgetCents),
       position = Value(position);
  static Insertable<BudgetGroup> custom({
    Expression<int>? id,
    Expression<int>? monthId,
    Expression<String>? name,
    Expression<int>? budgetCents,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (monthId != null) 'month_id': monthId,
      if (name != null) 'name': name,
      if (budgetCents != null) 'budget_cents': budgetCents,
      if (position != null) 'position': position,
    });
  }

  BudgetGroupsCompanion copyWith({
    Value<int>? id,
    Value<int>? monthId,
    Value<String>? name,
    Value<int>? budgetCents,
    Value<int>? position,
  }) {
    return BudgetGroupsCompanion(
      id: id ?? this.id,
      monthId: monthId ?? this.monthId,
      name: name ?? this.name,
      budgetCents: budgetCents ?? this.budgetCents,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (monthId.present) {
      map['month_id'] = Variable<int>(monthId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (budgetCents.present) {
      map['budget_cents'] = Variable<int>(budgetCents.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetGroupsCompanion(')
          ..write('id: $id, ')
          ..write('monthId: $monthId, ')
          ..write('name: $name, ')
          ..write('budgetCents: $budgetCents, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $GroupTemplatesTable extends GroupTemplates
    with TableInfo<$GroupTemplatesTable, GroupTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetCentsMeta = const VerificationMeta(
    'budgetCents',
  );
  @override
  late final GeneratedColumn<int> budgetCents = GeneratedColumn<int>(
    'budget_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, budgetCents, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('budget_cents')) {
      context.handle(
        _budgetCentsMeta,
        budgetCents.isAcceptableOrUnknown(
          data['budget_cents']!,
          _budgetCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_budgetCentsMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      budgetCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}budget_cents'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $GroupTemplatesTable createAlias(String alias) {
    return $GroupTemplatesTable(attachedDatabase, alias);
  }
}

class GroupTemplate extends DataClass implements Insertable<GroupTemplate> {
  final int id;
  final String name;
  final int budgetCents;
  final int position;
  const GroupTemplate({
    required this.id,
    required this.name,
    required this.budgetCents,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['budget_cents'] = Variable<int>(budgetCents);
    map['position'] = Variable<int>(position);
    return map;
  }

  GroupTemplatesCompanion toCompanion(bool nullToAbsent) {
    return GroupTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      budgetCents: Value(budgetCents),
      position: Value(position),
    );
  }

  factory GroupTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupTemplate(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      budgetCents: serializer.fromJson<int>(json['budgetCents']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'budgetCents': serializer.toJson<int>(budgetCents),
      'position': serializer.toJson<int>(position),
    };
  }

  GroupTemplate copyWith({
    int? id,
    String? name,
    int? budgetCents,
    int? position,
  }) => GroupTemplate(
    id: id ?? this.id,
    name: name ?? this.name,
    budgetCents: budgetCents ?? this.budgetCents,
    position: position ?? this.position,
  );
  GroupTemplate copyWithCompanion(GroupTemplatesCompanion data) {
    return GroupTemplate(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      budgetCents: data.budgetCents.present
          ? data.budgetCents.value
          : this.budgetCents,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupTemplate(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('budgetCents: $budgetCents, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, budgetCents, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupTemplate &&
          other.id == this.id &&
          other.name == this.name &&
          other.budgetCents == this.budgetCents &&
          other.position == this.position);
}

class GroupTemplatesCompanion extends UpdateCompanion<GroupTemplate> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> budgetCents;
  final Value<int> position;
  const GroupTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.budgetCents = const Value.absent(),
    this.position = const Value.absent(),
  });
  GroupTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int budgetCents,
    required int position,
  }) : name = Value(name),
       budgetCents = Value(budgetCents),
       position = Value(position);
  static Insertable<GroupTemplate> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? budgetCents,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (budgetCents != null) 'budget_cents': budgetCents,
      if (position != null) 'position': position,
    });
  }

  GroupTemplatesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? budgetCents,
    Value<int>? position,
  }) {
    return GroupTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      budgetCents: budgetCents ?? this.budgetCents,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (budgetCents.present) {
      map['budget_cents'] = Variable<int>(budgetCents.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('budgetCents: $budgetCents, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MonthsTable months = $MonthsTable(this);
  late final $BudgetGroupsTable budgetGroups = $BudgetGroupsTable(this);
  late final $GroupTemplatesTable groupTemplates = $GroupTemplatesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    months,
    budgetGroups,
    groupTemplates,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'months',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budget_groups', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$MonthsTableCreateCompanionBuilder =
    MonthsCompanion Function({
      Value<int> id,
      required int year,
      required int month,
      required int salaryCents,
      Value<DateTime> createdAt,
      Value<DateTime?> closedAt,
    });
typedef $$MonthsTableUpdateCompanionBuilder =
    MonthsCompanion Function({
      Value<int> id,
      Value<int> year,
      Value<int> month,
      Value<int> salaryCents,
      Value<DateTime> createdAt,
      Value<DateTime?> closedAt,
    });

final class $$MonthsTableReferences
    extends BaseReferences<_$AppDatabase, $MonthsTable, Month> {
  $$MonthsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BudgetGroupsTable, List<BudgetGroup>>
  _budgetGroupsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetGroups,
    aliasName: 'months__id__budget_groups__month_id',
  );

  $$BudgetGroupsTableProcessedTableManager get budgetGroupsRefs {
    final manager = $$BudgetGroupsTableTableManager(
      $_db,
      $_db.budgetGroups,
    ).filter((f) => f.monthId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetGroupsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MonthsTableFilterComposer
    extends Composer<_$AppDatabase, $MonthsTable> {
  $$MonthsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get salaryCents => $composableBuilder(
    column: $table.salaryCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> budgetGroupsRefs(
    Expression<bool> Function($$BudgetGroupsTableFilterComposer f) f,
  ) {
    final $$BudgetGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetGroups,
      getReferencedColumn: (t) => t.monthId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetGroupsTableFilterComposer(
            $db: $db,
            $table: $db.budgetGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MonthsTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthsTable> {
  $$MonthsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get salaryCents => $composableBuilder(
    column: $table.salaryCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MonthsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthsTable> {
  $$MonthsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get salaryCents => $composableBuilder(
    column: $table.salaryCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  Expression<T> budgetGroupsRefs<T extends Object>(
    Expression<T> Function($$BudgetGroupsTableAnnotationComposer a) f,
  ) {
    final $$BudgetGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetGroups,
      getReferencedColumn: (t) => t.monthId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MonthsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MonthsTable,
          Month,
          $$MonthsTableFilterComposer,
          $$MonthsTableOrderingComposer,
          $$MonthsTableAnnotationComposer,
          $$MonthsTableCreateCompanionBuilder,
          $$MonthsTableUpdateCompanionBuilder,
          (Month, $$MonthsTableReferences),
          Month,
          PrefetchHooks Function({bool budgetGroupsRefs})
        > {
  $$MonthsTableTableManager(_$AppDatabase db, $MonthsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonthsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonthsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<int> salaryCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> closedAt = const Value.absent(),
              }) => MonthsCompanion(
                id: id,
                year: year,
                month: month,
                salaryCents: salaryCents,
                createdAt: createdAt,
                closedAt: closedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int year,
                required int month,
                required int salaryCents,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> closedAt = const Value.absent(),
              }) => MonthsCompanion.insert(
                id: id,
                year: year,
                month: month,
                salaryCents: salaryCents,
                createdAt: createdAt,
                closedAt: closedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$MonthsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({budgetGroupsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (budgetGroupsRefs) db.budgetGroups],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (budgetGroupsRefs)
                    await $_getPrefetchedData<Month, $MonthsTable, BudgetGroup>(
                      currentTable: table,
                      referencedTable: $$MonthsTableReferences
                          ._budgetGroupsRefsTable(db),
                      managerFromTypedResult: (p0) => $$MonthsTableReferences(
                        db,
                        table,
                        p0,
                      ).budgetGroupsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.monthId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MonthsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MonthsTable,
      Month,
      $$MonthsTableFilterComposer,
      $$MonthsTableOrderingComposer,
      $$MonthsTableAnnotationComposer,
      $$MonthsTableCreateCompanionBuilder,
      $$MonthsTableUpdateCompanionBuilder,
      (Month, $$MonthsTableReferences),
      Month,
      PrefetchHooks Function({bool budgetGroupsRefs})
    >;
typedef $$BudgetGroupsTableCreateCompanionBuilder =
    BudgetGroupsCompanion Function({
      Value<int> id,
      required int monthId,
      required String name,
      required int budgetCents,
      required int position,
    });
typedef $$BudgetGroupsTableUpdateCompanionBuilder =
    BudgetGroupsCompanion Function({
      Value<int> id,
      Value<int> monthId,
      Value<String> name,
      Value<int> budgetCents,
      Value<int> position,
    });

final class $$BudgetGroupsTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetGroupsTable, BudgetGroup> {
  $$BudgetGroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MonthsTable _monthIdTable(_$AppDatabase db) =>
      db.months.createAlias('budget_groups__month_id__months__id');

  $$MonthsTableProcessedTableManager get monthId {
    final $_column = $_itemColumn<int>('month_id')!;

    final manager = $$MonthsTableTableManager(
      $_db,
      $_db.months,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_monthIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BudgetGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetGroupsTable> {
  $$BudgetGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get budgetCents => $composableBuilder(
    column: $table.budgetCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$MonthsTableFilterComposer get monthId {
    final $$MonthsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.monthId,
      referencedTable: $db.months,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthsTableFilterComposer(
            $db: $db,
            $table: $db.months,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetGroupsTable> {
  $$BudgetGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get budgetCents => $composableBuilder(
    column: $table.budgetCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$MonthsTableOrderingComposer get monthId {
    final $$MonthsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.monthId,
      referencedTable: $db.months,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthsTableOrderingComposer(
            $db: $db,
            $table: $db.months,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetGroupsTable> {
  $$BudgetGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get budgetCents => $composableBuilder(
    column: $table.budgetCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$MonthsTableAnnotationComposer get monthId {
    final $$MonthsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.monthId,
      referencedTable: $db.months,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MonthsTableAnnotationComposer(
            $db: $db,
            $table: $db.months,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetGroupsTable,
          BudgetGroup,
          $$BudgetGroupsTableFilterComposer,
          $$BudgetGroupsTableOrderingComposer,
          $$BudgetGroupsTableAnnotationComposer,
          $$BudgetGroupsTableCreateCompanionBuilder,
          $$BudgetGroupsTableUpdateCompanionBuilder,
          (BudgetGroup, $$BudgetGroupsTableReferences),
          BudgetGroup,
          PrefetchHooks Function({bool monthId})
        > {
  $$BudgetGroupsTableTableManager(_$AppDatabase db, $BudgetGroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> monthId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> budgetCents = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => BudgetGroupsCompanion(
                id: id,
                monthId: monthId,
                name: name,
                budgetCents: budgetCents,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int monthId,
                required String name,
                required int budgetCents,
                required int position,
              }) => BudgetGroupsCompanion.insert(
                id: id,
                monthId: monthId,
                name: name,
                budgetCents: budgetCents,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BudgetGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({monthId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (monthId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.monthId,
                                referencedTable: $$BudgetGroupsTableReferences
                                    ._monthIdTable(db),
                                referencedColumn: $$BudgetGroupsTableReferences
                                    ._monthIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BudgetGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetGroupsTable,
      BudgetGroup,
      $$BudgetGroupsTableFilterComposer,
      $$BudgetGroupsTableOrderingComposer,
      $$BudgetGroupsTableAnnotationComposer,
      $$BudgetGroupsTableCreateCompanionBuilder,
      $$BudgetGroupsTableUpdateCompanionBuilder,
      (BudgetGroup, $$BudgetGroupsTableReferences),
      BudgetGroup,
      PrefetchHooks Function({bool monthId})
    >;
typedef $$GroupTemplatesTableCreateCompanionBuilder =
    GroupTemplatesCompanion Function({
      Value<int> id,
      required String name,
      required int budgetCents,
      required int position,
    });
typedef $$GroupTemplatesTableUpdateCompanionBuilder =
    GroupTemplatesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> budgetCents,
      Value<int> position,
    });

class $$GroupTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $GroupTemplatesTable> {
  $$GroupTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get budgetCents => $composableBuilder(
    column: $table.budgetCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GroupTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupTemplatesTable> {
  $$GroupTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get budgetCents => $composableBuilder(
    column: $table.budgetCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroupTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupTemplatesTable> {
  $$GroupTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get budgetCents => $composableBuilder(
    column: $table.budgetCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$GroupTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupTemplatesTable,
          GroupTemplate,
          $$GroupTemplatesTableFilterComposer,
          $$GroupTemplatesTableOrderingComposer,
          $$GroupTemplatesTableAnnotationComposer,
          $$GroupTemplatesTableCreateCompanionBuilder,
          $$GroupTemplatesTableUpdateCompanionBuilder,
          (
            GroupTemplate,
            BaseReferences<_$AppDatabase, $GroupTemplatesTable, GroupTemplate>,
          ),
          GroupTemplate,
          PrefetchHooks Function()
        > {
  $$GroupTemplatesTableTableManager(
    _$AppDatabase db,
    $GroupTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> budgetCents = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => GroupTemplatesCompanion(
                id: id,
                name: name,
                budgetCents: budgetCents,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int budgetCents,
                required int position,
              }) => GroupTemplatesCompanion.insert(
                id: id,
                name: name,
                budgetCents: budgetCents,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GroupTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupTemplatesTable,
      GroupTemplate,
      $$GroupTemplatesTableFilterComposer,
      $$GroupTemplatesTableOrderingComposer,
      $$GroupTemplatesTableAnnotationComposer,
      $$GroupTemplatesTableCreateCompanionBuilder,
      $$GroupTemplatesTableUpdateCompanionBuilder,
      (
        GroupTemplate,
        BaseReferences<_$AppDatabase, $GroupTemplatesTable, GroupTemplate>,
      ),
      GroupTemplate,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MonthsTableTableManager get months =>
      $$MonthsTableTableManager(_db, _db.months);
  $$BudgetGroupsTableTableManager get budgetGroups =>
      $$BudgetGroupsTableTableManager(_db, _db.budgetGroups);
  $$GroupTemplatesTableTableManager get groupTemplates =>
      $$GroupTemplatesTableTableManager(_db, _db.groupTemplates);
}
