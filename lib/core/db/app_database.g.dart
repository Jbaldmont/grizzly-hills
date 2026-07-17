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

class $FixedExpenseTemplatesTable extends FixedExpenseTemplates
    with TableInfo<$FixedExpenseTemplatesTable, FixedExpenseTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FixedExpenseTemplatesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _lastAmountCentsMeta = const VerificationMeta(
    'lastAmountCents',
  );
  @override
  late final GeneratedColumn<int> lastAmountCents = GeneratedColumn<int>(
    'last_amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  List<GeneratedColumn> get $columns => [id, name, lastAmountCents, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fixed_expense_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<FixedExpenseTemplate> instance, {
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
    if (data.containsKey('last_amount_cents')) {
      context.handle(
        _lastAmountCentsMeta,
        lastAmountCents.isAcceptableOrUnknown(
          data['last_amount_cents']!,
          _lastAmountCentsMeta,
        ),
      );
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
  FixedExpenseTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FixedExpenseTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      lastAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_amount_cents'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $FixedExpenseTemplatesTable createAlias(String alias) {
    return $FixedExpenseTemplatesTable(attachedDatabase, alias);
  }
}

class FixedExpenseTemplate extends DataClass
    implements Insertable<FixedExpenseTemplate> {
  final int id;
  final String name;
  final int lastAmountCents;
  final int position;
  const FixedExpenseTemplate({
    required this.id,
    required this.name,
    required this.lastAmountCents,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['last_amount_cents'] = Variable<int>(lastAmountCents);
    map['position'] = Variable<int>(position);
    return map;
  }

  FixedExpenseTemplatesCompanion toCompanion(bool nullToAbsent) {
    return FixedExpenseTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      lastAmountCents: Value(lastAmountCents),
      position: Value(position),
    );
  }

  factory FixedExpenseTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FixedExpenseTemplate(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      lastAmountCents: serializer.fromJson<int>(json['lastAmountCents']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'lastAmountCents': serializer.toJson<int>(lastAmountCents),
      'position': serializer.toJson<int>(position),
    };
  }

  FixedExpenseTemplate copyWith({
    int? id,
    String? name,
    int? lastAmountCents,
    int? position,
  }) => FixedExpenseTemplate(
    id: id ?? this.id,
    name: name ?? this.name,
    lastAmountCents: lastAmountCents ?? this.lastAmountCents,
    position: position ?? this.position,
  );
  FixedExpenseTemplate copyWithCompanion(FixedExpenseTemplatesCompanion data) {
    return FixedExpenseTemplate(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      lastAmountCents: data.lastAmountCents.present
          ? data.lastAmountCents.value
          : this.lastAmountCents,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FixedExpenseTemplate(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lastAmountCents: $lastAmountCents, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, lastAmountCents, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FixedExpenseTemplate &&
          other.id == this.id &&
          other.name == this.name &&
          other.lastAmountCents == this.lastAmountCents &&
          other.position == this.position);
}

class FixedExpenseTemplatesCompanion
    extends UpdateCompanion<FixedExpenseTemplate> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> lastAmountCents;
  final Value<int> position;
  const FixedExpenseTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.lastAmountCents = const Value.absent(),
    this.position = const Value.absent(),
  });
  FixedExpenseTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.lastAmountCents = const Value.absent(),
    required int position,
  }) : name = Value(name),
       position = Value(position);
  static Insertable<FixedExpenseTemplate> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? lastAmountCents,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (lastAmountCents != null) 'last_amount_cents': lastAmountCents,
      if (position != null) 'position': position,
    });
  }

  FixedExpenseTemplatesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? lastAmountCents,
    Value<int>? position,
  }) {
    return FixedExpenseTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      lastAmountCents: lastAmountCents ?? this.lastAmountCents,
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
    if (lastAmountCents.present) {
      map['last_amount_cents'] = Variable<int>(lastAmountCents.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FixedExpenseTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lastAmountCents: $lastAmountCents, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
    'group_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES budget_groups (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _fixedTemplateIdMeta = const VerificationMeta(
    'fixedTemplateId',
  );
  @override
  late final GeneratedColumn<int> fixedTemplateId = GeneratedColumn<int>(
    'fixed_template_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES fixed_expense_templates (id) ON DELETE SET NULL',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ExpenseKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ExpenseKind>($ExpensesTable.$converterkind);
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    monthId,
    groupId,
    fixedTemplateId,
    kind,
    description,
    amountCents,
    date,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
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
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    }
    if (data.containsKey('fixed_template_id')) {
      context.handle(
        _fixedTemplateIdMeta,
        fixedTemplateId.isAcceptableOrUnknown(
          data['fixed_template_id']!,
          _fixedTemplateIdMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      monthId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month_id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      ),
      fixedTemplateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fixed_template_id'],
      ),
      kind: $ExpensesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ExpenseKind, String, String> $converterkind =
      const EnumNameConverter<ExpenseKind>(ExpenseKind.values);
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final int monthId;
  final int? groupId;
  final int? fixedTemplateId;
  final ExpenseKind kind;
  final String description;
  final int amountCents;
  final DateTime date;
  const Expense({
    required this.id,
    required this.monthId,
    this.groupId,
    this.fixedTemplateId,
    required this.kind,
    required this.description,
    required this.amountCents,
    required this.date,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['month_id'] = Variable<int>(monthId);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<int>(groupId);
    }
    if (!nullToAbsent || fixedTemplateId != null) {
      map['fixed_template_id'] = Variable<int>(fixedTemplateId);
    }
    {
      map['kind'] = Variable<String>($ExpensesTable.$converterkind.toSql(kind));
    }
    map['description'] = Variable<String>(description);
    map['amount_cents'] = Variable<int>(amountCents);
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      monthId: Value(monthId),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      fixedTemplateId: fixedTemplateId == null && nullToAbsent
          ? const Value.absent()
          : Value(fixedTemplateId),
      kind: Value(kind),
      description: Value(description),
      amountCents: Value(amountCents),
      date: Value(date),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      monthId: serializer.fromJson<int>(json['monthId']),
      groupId: serializer.fromJson<int?>(json['groupId']),
      fixedTemplateId: serializer.fromJson<int?>(json['fixedTemplateId']),
      kind: $ExpensesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      description: serializer.fromJson<String>(json['description']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'monthId': serializer.toJson<int>(monthId),
      'groupId': serializer.toJson<int?>(groupId),
      'fixedTemplateId': serializer.toJson<int?>(fixedTemplateId),
      'kind': serializer.toJson<String>(
        $ExpensesTable.$converterkind.toJson(kind),
      ),
      'description': serializer.toJson<String>(description),
      'amountCents': serializer.toJson<int>(amountCents),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  Expense copyWith({
    int? id,
    int? monthId,
    Value<int?> groupId = const Value.absent(),
    Value<int?> fixedTemplateId = const Value.absent(),
    ExpenseKind? kind,
    String? description,
    int? amountCents,
    DateTime? date,
  }) => Expense(
    id: id ?? this.id,
    monthId: monthId ?? this.monthId,
    groupId: groupId.present ? groupId.value : this.groupId,
    fixedTemplateId: fixedTemplateId.present
        ? fixedTemplateId.value
        : this.fixedTemplateId,
    kind: kind ?? this.kind,
    description: description ?? this.description,
    amountCents: amountCents ?? this.amountCents,
    date: date ?? this.date,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      monthId: data.monthId.present ? data.monthId.value : this.monthId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      fixedTemplateId: data.fixedTemplateId.present
          ? data.fixedTemplateId.value
          : this.fixedTemplateId,
      kind: data.kind.present ? data.kind.value : this.kind,
      description: data.description.present
          ? data.description.value
          : this.description,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('monthId: $monthId, ')
          ..write('groupId: $groupId, ')
          ..write('fixedTemplateId: $fixedTemplateId, ')
          ..write('kind: $kind, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    monthId,
    groupId,
    fixedTemplateId,
    kind,
    description,
    amountCents,
    date,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.monthId == this.monthId &&
          other.groupId == this.groupId &&
          other.fixedTemplateId == this.fixedTemplateId &&
          other.kind == this.kind &&
          other.description == this.description &&
          other.amountCents == this.amountCents &&
          other.date == this.date);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<int> monthId;
  final Value<int?> groupId;
  final Value<int?> fixedTemplateId;
  final Value<ExpenseKind> kind;
  final Value<String> description;
  final Value<int> amountCents;
  final Value<DateTime> date;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.monthId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.fixedTemplateId = const Value.absent(),
    this.kind = const Value.absent(),
    this.description = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.date = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required int monthId,
    this.groupId = const Value.absent(),
    this.fixedTemplateId = const Value.absent(),
    required ExpenseKind kind,
    required String description,
    required int amountCents,
    required DateTime date,
  }) : monthId = Value(monthId),
       kind = Value(kind),
       description = Value(description),
       amountCents = Value(amountCents),
       date = Value(date);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<int>? monthId,
    Expression<int>? groupId,
    Expression<int>? fixedTemplateId,
    Expression<String>? kind,
    Expression<String>? description,
    Expression<int>? amountCents,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (monthId != null) 'month_id': monthId,
      if (groupId != null) 'group_id': groupId,
      if (fixedTemplateId != null) 'fixed_template_id': fixedTemplateId,
      if (kind != null) 'kind': kind,
      if (description != null) 'description': description,
      if (amountCents != null) 'amount_cents': amountCents,
      if (date != null) 'date': date,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<int>? monthId,
    Value<int?>? groupId,
    Value<int?>? fixedTemplateId,
    Value<ExpenseKind>? kind,
    Value<String>? description,
    Value<int>? amountCents,
    Value<DateTime>? date,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      monthId: monthId ?? this.monthId,
      groupId: groupId ?? this.groupId,
      fixedTemplateId: fixedTemplateId ?? this.fixedTemplateId,
      kind: kind ?? this.kind,
      description: description ?? this.description,
      amountCents: amountCents ?? this.amountCents,
      date: date ?? this.date,
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
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (fixedTemplateId.present) {
      map['fixed_template_id'] = Variable<int>(fixedTemplateId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $ExpensesTable.$converterkind.toSql(kind.value),
      );
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('monthId: $monthId, ')
          ..write('groupId: $groupId, ')
          ..write('fixedTemplateId: $fixedTemplateId, ')
          ..write('kind: $kind, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $SavingsLocationsTable extends SavingsLocations
    with TableInfo<$SavingsLocationsTable, SavingsLocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsLocationsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _balanceCentsMeta = const VerificationMeta(
    'balanceCents',
  );
  @override
  late final GeneratedColumn<int> balanceCents = GeneratedColumn<int>(
    'balance_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  List<GeneratedColumn> get $columns => [id, name, balanceCents, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsLocation> instance, {
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
    if (data.containsKey('balance_cents')) {
      context.handle(
        _balanceCentsMeta,
        balanceCents.isAcceptableOrUnknown(
          data['balance_cents']!,
          _balanceCentsMeta,
        ),
      );
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
  SavingsLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsLocation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      balanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance_cents'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $SavingsLocationsTable createAlias(String alias) {
    return $SavingsLocationsTable(attachedDatabase, alias);
  }
}

class SavingsLocation extends DataClass implements Insertable<SavingsLocation> {
  final int id;
  final String name;
  final int balanceCents;
  final int position;
  const SavingsLocation({
    required this.id,
    required this.name,
    required this.balanceCents,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['balance_cents'] = Variable<int>(balanceCents);
    map['position'] = Variable<int>(position);
    return map;
  }

  SavingsLocationsCompanion toCompanion(bool nullToAbsent) {
    return SavingsLocationsCompanion(
      id: Value(id),
      name: Value(name),
      balanceCents: Value(balanceCents),
      position: Value(position),
    );
  }

  factory SavingsLocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsLocation(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      balanceCents: serializer.fromJson<int>(json['balanceCents']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'balanceCents': serializer.toJson<int>(balanceCents),
      'position': serializer.toJson<int>(position),
    };
  }

  SavingsLocation copyWith({
    int? id,
    String? name,
    int? balanceCents,
    int? position,
  }) => SavingsLocation(
    id: id ?? this.id,
    name: name ?? this.name,
    balanceCents: balanceCents ?? this.balanceCents,
    position: position ?? this.position,
  );
  SavingsLocation copyWithCompanion(SavingsLocationsCompanion data) {
    return SavingsLocation(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      balanceCents: data.balanceCents.present
          ? data.balanceCents.value
          : this.balanceCents,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsLocation(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, balanceCents, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsLocation &&
          other.id == this.id &&
          other.name == this.name &&
          other.balanceCents == this.balanceCents &&
          other.position == this.position);
}

class SavingsLocationsCompanion extends UpdateCompanion<SavingsLocation> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> balanceCents;
  final Value<int> position;
  const SavingsLocationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.balanceCents = const Value.absent(),
    this.position = const Value.absent(),
  });
  SavingsLocationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.balanceCents = const Value.absent(),
    required int position,
  }) : name = Value(name),
       position = Value(position);
  static Insertable<SavingsLocation> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? balanceCents,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (balanceCents != null) 'balance_cents': balanceCents,
      if (position != null) 'position': position,
    });
  }

  SavingsLocationsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? balanceCents,
    Value<int>? position,
  }) {
    return SavingsLocationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      balanceCents: balanceCents ?? this.balanceCents,
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
    if (balanceCents.present) {
      map['balance_cents'] = Variable<int>(balanceCents.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsLocationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $LoansTable extends Loans with TableInfo<$LoansTable, Loan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoansTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _debtorNameMeta = const VerificationMeta(
    'debtorName',
  );
  @override
  late final GeneratedColumn<String> debtorName = GeneratedColumn<String>(
    'debtor_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _principalCentsMeta = const VerificationMeta(
    'principalCents',
  );
  @override
  late final GeneratedColumn<int> principalCents = GeneratedColumn<int>(
    'principal_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loanDateMeta = const VerificationMeta(
    'loanDate',
  );
  @override
  late final GeneratedColumn<DateTime> loanDate = GeneratedColumn<DateTime>(
    'loan_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _interestStartDateMeta = const VerificationMeta(
    'interestStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> interestStartDate =
      GeneratedColumn<DateTime>(
        'interest_start_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    debtorName,
    principalCents,
    loanDate,
    interestStartDate,
    dueDate,
    closedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loans';
  @override
  VerificationContext validateIntegrity(
    Insertable<Loan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('debtor_name')) {
      context.handle(
        _debtorNameMeta,
        debtorName.isAcceptableOrUnknown(data['debtor_name']!, _debtorNameMeta),
      );
    } else if (isInserting) {
      context.missing(_debtorNameMeta);
    }
    if (data.containsKey('principal_cents')) {
      context.handle(
        _principalCentsMeta,
        principalCents.isAcceptableOrUnknown(
          data['principal_cents']!,
          _principalCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_principalCentsMeta);
    }
    if (data.containsKey('loan_date')) {
      context.handle(
        _loanDateMeta,
        loanDate.isAcceptableOrUnknown(data['loan_date']!, _loanDateMeta),
      );
    } else if (isInserting) {
      context.missing(_loanDateMeta);
    }
    if (data.containsKey('interest_start_date')) {
      context.handle(
        _interestStartDateMeta,
        interestStartDate.isAcceptableOrUnknown(
          data['interest_start_date']!,
          _interestStartDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_interestStartDateMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Loan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Loan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      debtorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}debtor_name'],
      )!,
      principalCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}principal_cents'],
      )!,
      loanDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}loan_date'],
      )!,
      interestStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}interest_start_date'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}closed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LoansTable createAlias(String alias) {
    return $LoansTable(attachedDatabase, alias);
  }
}

class Loan extends DataClass implements Insertable<Loan> {
  final int id;
  final String debtorName;
  final int principalCents;
  final DateTime loanDate;
  final DateTime interestStartDate;
  final DateTime dueDate;
  final DateTime? closedAt;
  final DateTime createdAt;
  const Loan({
    required this.id,
    required this.debtorName,
    required this.principalCents,
    required this.loanDate,
    required this.interestStartDate,
    required this.dueDate,
    this.closedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['debtor_name'] = Variable<String>(debtorName);
    map['principal_cents'] = Variable<int>(principalCents);
    map['loan_date'] = Variable<DateTime>(loanDate);
    map['interest_start_date'] = Variable<DateTime>(interestStartDate);
    map['due_date'] = Variable<DateTime>(dueDate);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LoansCompanion toCompanion(bool nullToAbsent) {
    return LoansCompanion(
      id: Value(id),
      debtorName: Value(debtorName),
      principalCents: Value(principalCents),
      loanDate: Value(loanDate),
      interestStartDate: Value(interestStartDate),
      dueDate: Value(dueDate),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
      createdAt: Value(createdAt),
    );
  }

  factory Loan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Loan(
      id: serializer.fromJson<int>(json['id']),
      debtorName: serializer.fromJson<String>(json['debtorName']),
      principalCents: serializer.fromJson<int>(json['principalCents']),
      loanDate: serializer.fromJson<DateTime>(json['loanDate']),
      interestStartDate: serializer.fromJson<DateTime>(
        json['interestStartDate'],
      ),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'debtorName': serializer.toJson<String>(debtorName),
      'principalCents': serializer.toJson<int>(principalCents),
      'loanDate': serializer.toJson<DateTime>(loanDate),
      'interestStartDate': serializer.toJson<DateTime>(interestStartDate),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Loan copyWith({
    int? id,
    String? debtorName,
    int? principalCents,
    DateTime? loanDate,
    DateTime? interestStartDate,
    DateTime? dueDate,
    Value<DateTime?> closedAt = const Value.absent(),
    DateTime? createdAt,
  }) => Loan(
    id: id ?? this.id,
    debtorName: debtorName ?? this.debtorName,
    principalCents: principalCents ?? this.principalCents,
    loanDate: loanDate ?? this.loanDate,
    interestStartDate: interestStartDate ?? this.interestStartDate,
    dueDate: dueDate ?? this.dueDate,
    closedAt: closedAt.present ? closedAt.value : this.closedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  Loan copyWithCompanion(LoansCompanion data) {
    return Loan(
      id: data.id.present ? data.id.value : this.id,
      debtorName: data.debtorName.present
          ? data.debtorName.value
          : this.debtorName,
      principalCents: data.principalCents.present
          ? data.principalCents.value
          : this.principalCents,
      loanDate: data.loanDate.present ? data.loanDate.value : this.loanDate,
      interestStartDate: data.interestStartDate.present
          ? data.interestStartDate.value
          : this.interestStartDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Loan(')
          ..write('id: $id, ')
          ..write('debtorName: $debtorName, ')
          ..write('principalCents: $principalCents, ')
          ..write('loanDate: $loanDate, ')
          ..write('interestStartDate: $interestStartDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('closedAt: $closedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    debtorName,
    principalCents,
    loanDate,
    interestStartDate,
    dueDate,
    closedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Loan &&
          other.id == this.id &&
          other.debtorName == this.debtorName &&
          other.principalCents == this.principalCents &&
          other.loanDate == this.loanDate &&
          other.interestStartDate == this.interestStartDate &&
          other.dueDate == this.dueDate &&
          other.closedAt == this.closedAt &&
          other.createdAt == this.createdAt);
}

class LoansCompanion extends UpdateCompanion<Loan> {
  final Value<int> id;
  final Value<String> debtorName;
  final Value<int> principalCents;
  final Value<DateTime> loanDate;
  final Value<DateTime> interestStartDate;
  final Value<DateTime> dueDate;
  final Value<DateTime?> closedAt;
  final Value<DateTime> createdAt;
  const LoansCompanion({
    this.id = const Value.absent(),
    this.debtorName = const Value.absent(),
    this.principalCents = const Value.absent(),
    this.loanDate = const Value.absent(),
    this.interestStartDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LoansCompanion.insert({
    this.id = const Value.absent(),
    required String debtorName,
    required int principalCents,
    required DateTime loanDate,
    required DateTime interestStartDate,
    required DateTime dueDate,
    this.closedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : debtorName = Value(debtorName),
       principalCents = Value(principalCents),
       loanDate = Value(loanDate),
       interestStartDate = Value(interestStartDate),
       dueDate = Value(dueDate);
  static Insertable<Loan> custom({
    Expression<int>? id,
    Expression<String>? debtorName,
    Expression<int>? principalCents,
    Expression<DateTime>? loanDate,
    Expression<DateTime>? interestStartDate,
    Expression<DateTime>? dueDate,
    Expression<DateTime>? closedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (debtorName != null) 'debtor_name': debtorName,
      if (principalCents != null) 'principal_cents': principalCents,
      if (loanDate != null) 'loan_date': loanDate,
      if (interestStartDate != null) 'interest_start_date': interestStartDate,
      if (dueDate != null) 'due_date': dueDate,
      if (closedAt != null) 'closed_at': closedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LoansCompanion copyWith({
    Value<int>? id,
    Value<String>? debtorName,
    Value<int>? principalCents,
    Value<DateTime>? loanDate,
    Value<DateTime>? interestStartDate,
    Value<DateTime>? dueDate,
    Value<DateTime?>? closedAt,
    Value<DateTime>? createdAt,
  }) {
    return LoansCompanion(
      id: id ?? this.id,
      debtorName: debtorName ?? this.debtorName,
      principalCents: principalCents ?? this.principalCents,
      loanDate: loanDate ?? this.loanDate,
      interestStartDate: interestStartDate ?? this.interestStartDate,
      dueDate: dueDate ?? this.dueDate,
      closedAt: closedAt ?? this.closedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (debtorName.present) {
      map['debtor_name'] = Variable<String>(debtorName.value);
    }
    if (principalCents.present) {
      map['principal_cents'] = Variable<int>(principalCents.value);
    }
    if (loanDate.present) {
      map['loan_date'] = Variable<DateTime>(loanDate.value);
    }
    if (interestStartDate.present) {
      map['interest_start_date'] = Variable<DateTime>(interestStartDate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoansCompanion(')
          ..write('id: $id, ')
          ..write('debtorName: $debtorName, ')
          ..write('principalCents: $principalCents, ')
          ..write('loanDate: $loanDate, ')
          ..write('interestStartDate: $interestStartDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('closedAt: $closedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LoanPaymentsTable extends LoanPayments
    with TableInfo<$LoanPaymentsTable, LoanPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoanPaymentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _loanIdMeta = const VerificationMeta('loanId');
  @override
  late final GeneratedColumn<int> loanId = GeneratedColumn<int>(
    'loan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES loans (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, loanId, amountCents, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loan_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<LoanPayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('loan_id')) {
      context.handle(
        _loanIdMeta,
        loanId.isAcceptableOrUnknown(data['loan_id']!, _loanIdMeta),
      );
    } else if (isInserting) {
      context.missing(_loanIdMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoanPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoanPayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      loanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}loan_id'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
    );
  }

  @override
  $LoanPaymentsTable createAlias(String alias) {
    return $LoanPaymentsTable(attachedDatabase, alias);
  }
}

class LoanPayment extends DataClass implements Insertable<LoanPayment> {
  final int id;
  final int loanId;
  final int amountCents;
  final DateTime date;
  const LoanPayment({
    required this.id,
    required this.loanId,
    required this.amountCents,
    required this.date,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['loan_id'] = Variable<int>(loanId);
    map['amount_cents'] = Variable<int>(amountCents);
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  LoanPaymentsCompanion toCompanion(bool nullToAbsent) {
    return LoanPaymentsCompanion(
      id: Value(id),
      loanId: Value(loanId),
      amountCents: Value(amountCents),
      date: Value(date),
    );
  }

  factory LoanPayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoanPayment(
      id: serializer.fromJson<int>(json['id']),
      loanId: serializer.fromJson<int>(json['loanId']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'loanId': serializer.toJson<int>(loanId),
      'amountCents': serializer.toJson<int>(amountCents),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  LoanPayment copyWith({
    int? id,
    int? loanId,
    int? amountCents,
    DateTime? date,
  }) => LoanPayment(
    id: id ?? this.id,
    loanId: loanId ?? this.loanId,
    amountCents: amountCents ?? this.amountCents,
    date: date ?? this.date,
  );
  LoanPayment copyWithCompanion(LoanPaymentsCompanion data) {
    return LoanPayment(
      id: data.id.present ? data.id.value : this.id,
      loanId: data.loanId.present ? data.loanId.value : this.loanId,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoanPayment(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('amountCents: $amountCents, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, loanId, amountCents, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoanPayment &&
          other.id == this.id &&
          other.loanId == this.loanId &&
          other.amountCents == this.amountCents &&
          other.date == this.date);
}

class LoanPaymentsCompanion extends UpdateCompanion<LoanPayment> {
  final Value<int> id;
  final Value<int> loanId;
  final Value<int> amountCents;
  final Value<DateTime> date;
  const LoanPaymentsCompanion({
    this.id = const Value.absent(),
    this.loanId = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.date = const Value.absent(),
  });
  LoanPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int loanId,
    required int amountCents,
    required DateTime date,
  }) : loanId = Value(loanId),
       amountCents = Value(amountCents),
       date = Value(date);
  static Insertable<LoanPayment> custom({
    Expression<int>? id,
    Expression<int>? loanId,
    Expression<int>? amountCents,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loanId != null) 'loan_id': loanId,
      if (amountCents != null) 'amount_cents': amountCents,
      if (date != null) 'date': date,
    });
  }

  LoanPaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? loanId,
    Value<int>? amountCents,
    Value<DateTime>? date,
  }) {
    return LoanPaymentsCompanion(
      id: id ?? this.id,
      loanId: loanId ?? this.loanId,
      amountCents: amountCents ?? this.amountCents,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (loanId.present) {
      map['loan_id'] = Variable<int>(loanId.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoanPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('amountCents: $amountCents, ')
          ..write('date: $date')
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
  late final $FixedExpenseTemplatesTable fixedExpenseTemplates =
      $FixedExpenseTemplatesTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $SavingsLocationsTable savingsLocations = $SavingsLocationsTable(
    this,
  );
  late final $LoansTable loans = $LoansTable(this);
  late final $LoanPaymentsTable loanPayments = $LoanPaymentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    months,
    budgetGroups,
    groupTemplates,
    fixedExpenseTemplates,
    expenses,
    savingsLocations,
    loans,
    loanPayments,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'months',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expenses', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'budget_groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expenses', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'fixed_expense_templates',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expenses', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'loans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('loan_payments', kind: UpdateKind.delete)],
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

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: 'months__id__expenses__month_id',
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.monthId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
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

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.monthId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
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

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.monthId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
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
          PrefetchHooks Function({bool budgetGroupsRefs, bool expensesRefs})
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
          prefetchHooksCallback:
              ({budgetGroupsRefs = false, expensesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (budgetGroupsRefs) db.budgetGroups,
                    if (expensesRefs) db.expenses,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (budgetGroupsRefs)
                        await $_getPrefetchedData<
                          Month,
                          $MonthsTable,
                          BudgetGroup
                        >(
                          currentTable: table,
                          referencedTable: $$MonthsTableReferences
                              ._budgetGroupsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MonthsTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetGroupsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.monthId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expensesRefs)
                        await $_getPrefetchedData<Month, $MonthsTable, Expense>(
                          currentTable: table,
                          referencedTable: $$MonthsTableReferences
                              ._expensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MonthsTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.monthId == item.id,
                              ),
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
      PrefetchHooks Function({bool budgetGroupsRefs, bool expensesRefs})
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

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: 'budget_groups__id__expenses__group_id',
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
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

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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
          PrefetchHooks Function({bool monthId, bool expensesRefs})
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
          prefetchHooksCallback: ({monthId = false, expensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (expensesRefs) db.expenses],
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
                return [
                  if (expensesRefs)
                    await $_getPrefetchedData<
                      BudgetGroup,
                      $BudgetGroupsTable,
                      Expense
                    >(
                      currentTable: table,
                      referencedTable: $$BudgetGroupsTableReferences
                          ._expensesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BudgetGroupsTableReferences(
                            db,
                            table,
                            p0,
                          ).expensesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.groupId == item.id),
                      typedResults: items,
                    ),
                ];
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
      PrefetchHooks Function({bool monthId, bool expensesRefs})
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
typedef $$FixedExpenseTemplatesTableCreateCompanionBuilder =
    FixedExpenseTemplatesCompanion Function({
      Value<int> id,
      required String name,
      Value<int> lastAmountCents,
      required int position,
    });
typedef $$FixedExpenseTemplatesTableUpdateCompanionBuilder =
    FixedExpenseTemplatesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> lastAmountCents,
      Value<int> position,
    });

final class $$FixedExpenseTemplatesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FixedExpenseTemplatesTable,
          FixedExpenseTemplate
        > {
  $$FixedExpenseTemplatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: 'fixed_expense_templates__id__expenses__fixed_template_id',
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.fixedTemplateId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FixedExpenseTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $FixedExpenseTemplatesTable> {
  $$FixedExpenseTemplatesTableFilterComposer({
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

  ColumnFilters<int> get lastAmountCents => $composableBuilder(
    column: $table.lastAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.fixedTemplateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FixedExpenseTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $FixedExpenseTemplatesTable> {
  $$FixedExpenseTemplatesTableOrderingComposer({
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

  ColumnOrderings<int> get lastAmountCents => $composableBuilder(
    column: $table.lastAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FixedExpenseTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FixedExpenseTemplatesTable> {
  $$FixedExpenseTemplatesTableAnnotationComposer({
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

  GeneratedColumn<int> get lastAmountCents => $composableBuilder(
    column: $table.lastAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.fixedTemplateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FixedExpenseTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FixedExpenseTemplatesTable,
          FixedExpenseTemplate,
          $$FixedExpenseTemplatesTableFilterComposer,
          $$FixedExpenseTemplatesTableOrderingComposer,
          $$FixedExpenseTemplatesTableAnnotationComposer,
          $$FixedExpenseTemplatesTableCreateCompanionBuilder,
          $$FixedExpenseTemplatesTableUpdateCompanionBuilder,
          (FixedExpenseTemplate, $$FixedExpenseTemplatesTableReferences),
          FixedExpenseTemplate,
          PrefetchHooks Function({bool expensesRefs})
        > {
  $$FixedExpenseTemplatesTableTableManager(
    _$AppDatabase db,
    $FixedExpenseTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FixedExpenseTemplatesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$FixedExpenseTemplatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FixedExpenseTemplatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> lastAmountCents = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => FixedExpenseTemplatesCompanion(
                id: id,
                name: name,
                lastAmountCents: lastAmountCents,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> lastAmountCents = const Value.absent(),
                required int position,
              }) => FixedExpenseTemplatesCompanion.insert(
                id: id,
                name: name,
                lastAmountCents: lastAmountCents,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FixedExpenseTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({expensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (expensesRefs) db.expenses],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expensesRefs)
                    await $_getPrefetchedData<
                      FixedExpenseTemplate,
                      $FixedExpenseTemplatesTable,
                      Expense
                    >(
                      currentTable: table,
                      referencedTable: $$FixedExpenseTemplatesTableReferences
                          ._expensesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FixedExpenseTemplatesTableReferences(
                            db,
                            table,
                            p0,
                          ).expensesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.fixedTemplateId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FixedExpenseTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FixedExpenseTemplatesTable,
      FixedExpenseTemplate,
      $$FixedExpenseTemplatesTableFilterComposer,
      $$FixedExpenseTemplatesTableOrderingComposer,
      $$FixedExpenseTemplatesTableAnnotationComposer,
      $$FixedExpenseTemplatesTableCreateCompanionBuilder,
      $$FixedExpenseTemplatesTableUpdateCompanionBuilder,
      (FixedExpenseTemplate, $$FixedExpenseTemplatesTableReferences),
      FixedExpenseTemplate,
      PrefetchHooks Function({bool expensesRefs})
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      required int monthId,
      Value<int?> groupId,
      Value<int?> fixedTemplateId,
      required ExpenseKind kind,
      required String description,
      required int amountCents,
      required DateTime date,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      Value<int> monthId,
      Value<int?> groupId,
      Value<int?> fixedTemplateId,
      Value<ExpenseKind> kind,
      Value<String> description,
      Value<int> amountCents,
      Value<DateTime> date,
    });

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, Expense> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MonthsTable _monthIdTable(_$AppDatabase db) =>
      db.months.createAlias('expenses__month_id__months__id');

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

  static $BudgetGroupsTable _groupIdTable(_$AppDatabase db) =>
      db.budgetGroups.createAlias('expenses__group_id__budget_groups__id');

  $$BudgetGroupsTableProcessedTableManager? get groupId {
    final $_column = $_itemColumn<int>('group_id');
    if ($_column == null) return null;
    final manager = $$BudgetGroupsTableTableManager(
      $_db,
      $_db.budgetGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FixedExpenseTemplatesTable _fixedTemplateIdTable(_$AppDatabase db) =>
      db.fixedExpenseTemplates.createAlias(
        'expenses__fixed_template_id__fixed_expense_templates__id',
      );

  $$FixedExpenseTemplatesTableProcessedTableManager? get fixedTemplateId {
    final $_column = $_itemColumn<int>('fixed_template_id');
    if ($_column == null) return null;
    final manager = $$FixedExpenseTemplatesTableTableManager(
      $_db,
      $_db.fixedExpenseTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fixedTemplateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<ExpenseKind, ExpenseKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
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

  $$BudgetGroupsTableFilterComposer get groupId {
    final $$BudgetGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.budgetGroups,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }

  $$FixedExpenseTemplatesTableFilterComposer get fixedTemplateId {
    final $$FixedExpenseTemplatesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.fixedTemplateId,
          referencedTable: $db.fixedExpenseTemplates,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FixedExpenseTemplatesTableFilterComposer(
                $db: $db,
                $table: $db.fixedExpenseTemplates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
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

  $$BudgetGroupsTableOrderingComposer get groupId {
    final $$BudgetGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.budgetGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.budgetGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FixedExpenseTemplatesTableOrderingComposer get fixedTemplateId {
    final $$FixedExpenseTemplatesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.fixedTemplateId,
          referencedTable: $db.fixedExpenseTemplates,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FixedExpenseTemplatesTableOrderingComposer(
                $db: $db,
                $table: $db.fixedExpenseTemplates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ExpenseKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

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

  $$BudgetGroupsTableAnnotationComposer get groupId {
    final $$BudgetGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.budgetGroups,
      getReferencedColumn: (t) => t.id,
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
    return composer;
  }

  $$FixedExpenseTemplatesTableAnnotationComposer get fixedTemplateId {
    final $$FixedExpenseTemplatesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.fixedTemplateId,
          referencedTable: $db.fixedExpenseTemplates,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FixedExpenseTemplatesTableAnnotationComposer(
                $db: $db,
                $table: $db.fixedExpenseTemplates,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, $$ExpensesTableReferences),
          Expense,
          PrefetchHooks Function({
            bool monthId,
            bool groupId,
            bool fixedTemplateId,
          })
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> monthId = const Value.absent(),
                Value<int?> groupId = const Value.absent(),
                Value<int?> fixedTemplateId = const Value.absent(),
                Value<ExpenseKind> kind = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                monthId: monthId,
                groupId: groupId,
                fixedTemplateId: fixedTemplateId,
                kind: kind,
                description: description,
                amountCents: amountCents,
                date: date,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int monthId,
                Value<int?> groupId = const Value.absent(),
                Value<int?> fixedTemplateId = const Value.absent(),
                required ExpenseKind kind,
                required String description,
                required int amountCents,
                required DateTime date,
              }) => ExpensesCompanion.insert(
                id: id,
                monthId: monthId,
                groupId: groupId,
                fixedTemplateId: fixedTemplateId,
                kind: kind,
                description: description,
                amountCents: amountCents,
                date: date,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({monthId = false, groupId = false, fixedTemplateId = false}) {
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
                                    referencedTable: $$ExpensesTableReferences
                                        ._monthIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._monthIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (groupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.groupId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._groupIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._groupIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (fixedTemplateId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.fixedTemplateId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._fixedTemplateIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._fixedTemplateIdTable(db)
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

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, $$ExpensesTableReferences),
      Expense,
      PrefetchHooks Function({bool monthId, bool groupId, bool fixedTemplateId})
    >;
typedef $$SavingsLocationsTableCreateCompanionBuilder =
    SavingsLocationsCompanion Function({
      Value<int> id,
      required String name,
      Value<int> balanceCents,
      required int position,
    });
typedef $$SavingsLocationsTableUpdateCompanionBuilder =
    SavingsLocationsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> balanceCents,
      Value<int> position,
    });

class $$SavingsLocationsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsLocationsTable> {
  $$SavingsLocationsTableFilterComposer({
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

  ColumnFilters<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsLocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsLocationsTable> {
  $$SavingsLocationsTableOrderingComposer({
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

  ColumnOrderings<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsLocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsLocationsTable> {
  $$SavingsLocationsTableAnnotationComposer({
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

  GeneratedColumn<int> get balanceCents => $composableBuilder(
    column: $table.balanceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$SavingsLocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsLocationsTable,
          SavingsLocation,
          $$SavingsLocationsTableFilterComposer,
          $$SavingsLocationsTableOrderingComposer,
          $$SavingsLocationsTableAnnotationComposer,
          $$SavingsLocationsTableCreateCompanionBuilder,
          $$SavingsLocationsTableUpdateCompanionBuilder,
          (
            SavingsLocation,
            BaseReferences<
              _$AppDatabase,
              $SavingsLocationsTable,
              SavingsLocation
            >,
          ),
          SavingsLocation,
          PrefetchHooks Function()
        > {
  $$SavingsLocationsTableTableManager(
    _$AppDatabase db,
    $SavingsLocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsLocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsLocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsLocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> balanceCents = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => SavingsLocationsCompanion(
                id: id,
                name: name,
                balanceCents: balanceCents,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> balanceCents = const Value.absent(),
                required int position,
              }) => SavingsLocationsCompanion.insert(
                id: id,
                name: name,
                balanceCents: balanceCents,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsLocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsLocationsTable,
      SavingsLocation,
      $$SavingsLocationsTableFilterComposer,
      $$SavingsLocationsTableOrderingComposer,
      $$SavingsLocationsTableAnnotationComposer,
      $$SavingsLocationsTableCreateCompanionBuilder,
      $$SavingsLocationsTableUpdateCompanionBuilder,
      (
        SavingsLocation,
        BaseReferences<_$AppDatabase, $SavingsLocationsTable, SavingsLocation>,
      ),
      SavingsLocation,
      PrefetchHooks Function()
    >;
typedef $$LoansTableCreateCompanionBuilder =
    LoansCompanion Function({
      Value<int> id,
      required String debtorName,
      required int principalCents,
      required DateTime loanDate,
      required DateTime interestStartDate,
      required DateTime dueDate,
      Value<DateTime?> closedAt,
      Value<DateTime> createdAt,
    });
typedef $$LoansTableUpdateCompanionBuilder =
    LoansCompanion Function({
      Value<int> id,
      Value<String> debtorName,
      Value<int> principalCents,
      Value<DateTime> loanDate,
      Value<DateTime> interestStartDate,
      Value<DateTime> dueDate,
      Value<DateTime?> closedAt,
      Value<DateTime> createdAt,
    });

final class $$LoansTableReferences
    extends BaseReferences<_$AppDatabase, $LoansTable, Loan> {
  $$LoansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LoanPaymentsTable, List<LoanPayment>>
  _loanPaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.loanPayments,
    aliasName: 'loans__id__loan_payments__loan_id',
  );

  $$LoanPaymentsTableProcessedTableManager get loanPaymentsRefs {
    final manager = $$LoanPaymentsTableTableManager(
      $_db,
      $_db.loanPayments,
    ).filter((f) => f.loanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_loanPaymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LoansTableFilterComposer extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableFilterComposer({
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

  ColumnFilters<String> get debtorName => $composableBuilder(
    column: $table.debtorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get principalCents => $composableBuilder(
    column: $table.principalCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loanDate => $composableBuilder(
    column: $table.loanDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get interestStartDate => $composableBuilder(
    column: $table.interestStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> loanPaymentsRefs(
    Expression<bool> Function($$LoanPaymentsTableFilterComposer f) f,
  ) {
    final $$LoanPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loanPayments,
      getReferencedColumn: (t) => t.loanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoanPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.loanPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LoansTableOrderingComposer
    extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableOrderingComposer({
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

  ColumnOrderings<String> get debtorName => $composableBuilder(
    column: $table.debtorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get principalCents => $composableBuilder(
    column: $table.principalCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loanDate => $composableBuilder(
    column: $table.loanDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get interestStartDate => $composableBuilder(
    column: $table.interestStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LoansTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get debtorName => $composableBuilder(
    column: $table.debtorName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get principalCents => $composableBuilder(
    column: $table.principalCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get loanDate =>
      $composableBuilder(column: $table.loanDate, builder: (column) => column);

  GeneratedColumn<DateTime> get interestStartDate => $composableBuilder(
    column: $table.interestStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> loanPaymentsRefs<T extends Object>(
    Expression<T> Function($$LoanPaymentsTableAnnotationComposer a) f,
  ) {
    final $$LoanPaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loanPayments,
      getReferencedColumn: (t) => t.loanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoanPaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.loanPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LoansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoansTable,
          Loan,
          $$LoansTableFilterComposer,
          $$LoansTableOrderingComposer,
          $$LoansTableAnnotationComposer,
          $$LoansTableCreateCompanionBuilder,
          $$LoansTableUpdateCompanionBuilder,
          (Loan, $$LoansTableReferences),
          Loan,
          PrefetchHooks Function({bool loanPaymentsRefs})
        > {
  $$LoansTableTableManager(_$AppDatabase db, $LoansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> debtorName = const Value.absent(),
                Value<int> principalCents = const Value.absent(),
                Value<DateTime> loanDate = const Value.absent(),
                Value<DateTime> interestStartDate = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<DateTime?> closedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LoansCompanion(
                id: id,
                debtorName: debtorName,
                principalCents: principalCents,
                loanDate: loanDate,
                interestStartDate: interestStartDate,
                dueDate: dueDate,
                closedAt: closedAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String debtorName,
                required int principalCents,
                required DateTime loanDate,
                required DateTime interestStartDate,
                required DateTime dueDate,
                Value<DateTime?> closedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LoansCompanion.insert(
                id: id,
                debtorName: debtorName,
                principalCents: principalCents,
                loanDate: loanDate,
                interestStartDate: interestStartDate,
                dueDate: dueDate,
                closedAt: closedAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$LoansTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({loanPaymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (loanPaymentsRefs) db.loanPayments],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (loanPaymentsRefs)
                    await $_getPrefetchedData<Loan, $LoansTable, LoanPayment>(
                      currentTable: table,
                      referencedTable: $$LoansTableReferences
                          ._loanPaymentsRefsTable(db),
                      managerFromTypedResult: (p0) => $$LoansTableReferences(
                        db,
                        table,
                        p0,
                      ).loanPaymentsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.loanId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LoansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoansTable,
      Loan,
      $$LoansTableFilterComposer,
      $$LoansTableOrderingComposer,
      $$LoansTableAnnotationComposer,
      $$LoansTableCreateCompanionBuilder,
      $$LoansTableUpdateCompanionBuilder,
      (Loan, $$LoansTableReferences),
      Loan,
      PrefetchHooks Function({bool loanPaymentsRefs})
    >;
typedef $$LoanPaymentsTableCreateCompanionBuilder =
    LoanPaymentsCompanion Function({
      Value<int> id,
      required int loanId,
      required int amountCents,
      required DateTime date,
    });
typedef $$LoanPaymentsTableUpdateCompanionBuilder =
    LoanPaymentsCompanion Function({
      Value<int> id,
      Value<int> loanId,
      Value<int> amountCents,
      Value<DateTime> date,
    });

final class $$LoanPaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $LoanPaymentsTable, LoanPayment> {
  $$LoanPaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LoansTable _loanIdTable(_$AppDatabase db) =>
      db.loans.createAlias('loan_payments__loan_id__loans__id');

  $$LoansTableProcessedTableManager get loanId {
    final $_column = $_itemColumn<int>('loan_id')!;

    final manager = $$LoansTableTableManager(
      $_db,
      $_db.loans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_loanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LoanPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $LoanPaymentsTable> {
  $$LoanPaymentsTableFilterComposer({
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

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  $$LoansTableFilterComposer get loanId {
    final $$LoansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableFilterComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoanPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LoanPaymentsTable> {
  $$LoanPaymentsTableOrderingComposer({
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

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  $$LoansTableOrderingComposer get loanId {
    final $$LoansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableOrderingComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoanPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoanPaymentsTable> {
  $$LoanPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  $$LoansTableAnnotationComposer get loanId {
    final $$LoansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loanId,
      referencedTable: $db.loans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoansTableAnnotationComposer(
            $db: $db,
            $table: $db.loans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoanPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoanPaymentsTable,
          LoanPayment,
          $$LoanPaymentsTableFilterComposer,
          $$LoanPaymentsTableOrderingComposer,
          $$LoanPaymentsTableAnnotationComposer,
          $$LoanPaymentsTableCreateCompanionBuilder,
          $$LoanPaymentsTableUpdateCompanionBuilder,
          (LoanPayment, $$LoanPaymentsTableReferences),
          LoanPayment,
          PrefetchHooks Function({bool loanId})
        > {
  $$LoanPaymentsTableTableManager(_$AppDatabase db, $LoanPaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoanPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoanPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoanPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> loanId = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
              }) => LoanPaymentsCompanion(
                id: id,
                loanId: loanId,
                amountCents: amountCents,
                date: date,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int loanId,
                required int amountCents,
                required DateTime date,
              }) => LoanPaymentsCompanion.insert(
                id: id,
                loanId: loanId,
                amountCents: amountCents,
                date: date,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LoanPaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({loanId = false}) {
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
                    if (loanId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.loanId,
                                referencedTable: $$LoanPaymentsTableReferences
                                    ._loanIdTable(db),
                                referencedColumn: $$LoanPaymentsTableReferences
                                    ._loanIdTable(db)
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

typedef $$LoanPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoanPaymentsTable,
      LoanPayment,
      $$LoanPaymentsTableFilterComposer,
      $$LoanPaymentsTableOrderingComposer,
      $$LoanPaymentsTableAnnotationComposer,
      $$LoanPaymentsTableCreateCompanionBuilder,
      $$LoanPaymentsTableUpdateCompanionBuilder,
      (LoanPayment, $$LoanPaymentsTableReferences),
      LoanPayment,
      PrefetchHooks Function({bool loanId})
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
  $$FixedExpenseTemplatesTableTableManager get fixedExpenseTemplates =>
      $$FixedExpenseTemplatesTableTableManager(_db, _db.fixedExpenseTemplates);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$SavingsLocationsTableTableManager get savingsLocations =>
      $$SavingsLocationsTableTableManager(_db, _db.savingsLocations);
  $$LoansTableTableManager get loans =>
      $$LoansTableTableManager(_db, _db.loans);
  $$LoanPaymentsTableTableManager get loanPayments =>
      $$LoanPaymentsTableTableManager(_db, _db.loanPayments);
}
