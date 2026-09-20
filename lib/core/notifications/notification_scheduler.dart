import '../db/app_database.dart';

abstract interface class NotificationScheduler {
  Future<void> notifyGroupThreshold({
    required int groupId,
    required String groupName,
    required int thresholdPercent,
  });

  Future<void> scheduleLoanDueReminder(Loan loan);

  Future<void> cancelLoanDueReminder(int loanId);

  Future<void> scheduleMonthCloseReminder({required int year, required int month});

  Future<void> cancelMonthCloseReminder();
}

class NoopNotificationScheduler implements NotificationScheduler {
  const NoopNotificationScheduler();

  @override
  Future<void> notifyGroupThreshold({
    required int groupId,
    required String groupName,
    required int thresholdPercent,
  }) async {}

  @override
  Future<void> scheduleLoanDueReminder(Loan loan) async {}

  @override
  Future<void> cancelLoanDueReminder(int loanId) async {}

  @override
  Future<void> scheduleMonthCloseReminder({
    required int year,
    required int month,
  }) async {}

  @override
  Future<void> cancelMonthCloseReminder() async {}
}
