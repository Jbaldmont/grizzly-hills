import 'package:drift/drift.dart';

import '../../core/dates.dart';
import '../../core/db/app_database.dart';

class SavingsRepository {
  SavingsRepository(this._db);

  final AppDatabase _db;

  Stream<List<SavingsLocation>> watchLocations() {
    final query = _db.select(_db.savingsLocations)
      ..orderBy([(location) => OrderingTerm.asc(location.position)]);
    return query.watch();
  }

  Future<List<SavingsLocation>> loadLocations() {
    final query = _db.select(_db.savingsLocations)
      ..orderBy([(location) => OrderingTerm.asc(location.position)]);
    return query.get();
  }

  Future<void> addLocation(String name) async {
    final maxPosition = await _loadMaxPosition();
    await _db.into(_db.savingsLocations).insert(
          SavingsLocationsCompanion.insert(
            name: name,
            position: maxPosition + 1,
          ),
        );
  }

  Future<void> renameLocation({required int id, required String name}) {
    return (_db.update(_db.savingsLocations)
          ..where((location) => location.id.equals(id)))
        .write(SavingsLocationsCompanion(name: Value(name)));
  }

  Future<bool> deleteLocation(int id) {
    return _db.transaction(() async {
      final location = await (_db.select(_db.savingsLocations)
            ..where((row) => row.id.equals(id)))
          .getSingle();
      if (location.balanceCents != 0) {
        return false;
      }
      await (_db.delete(_db.savingsLocations)
            ..where((row) => row.id.equals(id)))
          .go();
      return true;
    });
  }

  Future<void> adjustBalance({required int id, required int deltaCents}) {
    return _db.transaction(() async {
      final location = await (_db.select(_db.savingsLocations)
            ..where((row) => row.id.equals(id)))
          .getSingle();
      await (_db.update(_db.savingsLocations)
            ..where((row) => row.id.equals(id)))
          .write(
        SavingsLocationsCompanion(
          balanceCents: Value(location.balanceCents + deltaCents),
        ),
      );
    });
  }

  Future<void> transferGroupToSavings({
    required int monthId,
    required int groupId,
    required int locationId,
    required String description,
    required int amountCents,
  }) {
    return _db.transaction(() async {
      await _db.into(_db.expenses).insert(
            ExpensesCompanion.insert(
              monthId: monthId,
              groupId: Value(groupId),
              kind: ExpenseKind.savingsTransfer,
              description: description,
              amountCents: amountCents,
              date: dateOnly(DateTime.now()),
            ),
          );
      await adjustBalance(id: locationId, deltaCents: amountCents);
    });
  }

  Future<int> _loadMaxPosition() async {
    final locations = await loadLocations();
    return locations.fold<int>(0, (max, location) {
      return location.position > max ? location.position : max;
    });
  }
}
