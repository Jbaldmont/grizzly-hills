import 'package:grizzly_hills/core/db/app_database.dart';
import 'package:grizzly_hills/core/notifications/notification_scheduler.dart';

class FakeNotificationScheduler implements NotificationScheduler {
  final List<({int groupId, String groupName, int thresholdPercent})>
  groupThresholdNotifications = [];
  final List<int> scheduledLoanReminderIds = [];
  final List<int> cancelledLoanReminderIds = [];
  final List<({int year, int month})> scheduledMonthCloseReminders = [];
  int monthCloseCancelCount = 0;

  @override
  Future<void> notifyGroupThreshold({
    required int groupId,
    required String groupName,
    required int thresholdPercent,
  }) async {
    groupThresholdNotifications.add((
      groupId: groupId,
      groupName: groupName,
      thresholdPercent: thresholdPercent,
    ));
  }

  @override
  Future<void> scheduleLoanDueReminder(Loan loan) async {
    scheduledLoanReminderIds.add(loan.id);
  }

  @override
  Future<void> cancelLoanDueReminder(int loanId) async {
    cancelledLoanReminderIds.add(loanId);
  }

  @override
  Future<void> scheduleMonthCloseReminder({
    required int year,
    required int month,
  }) async {
    scheduledMonthCloseReminders.add((year: year, month: month));
  }

  @override
  Future<void> cancelMonthCloseReminder() async {
    monthCloseCancelCount++;
  }
}
