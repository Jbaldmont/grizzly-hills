import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../features/loans/loan_repository.dart';
import '../../features/monthly_budget/month_repository.dart';
import '../dates.dart';
import '../db/app_database.dart';
import '../strings.dart';
import 'notification_scheduler.dart';

class NotificationService implements NotificationScheduler {
  NotificationService() : _plugin = FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  static const _reminderHour = 19;

  static const _budgetNoticeChannel = AndroidNotificationChannel(
    'budget_notice',
    'Presupuesto al 75%',
    description: 'Aviso cuando un grupo llega al 75% de su presupuesto',
  );
  static const _budgetImportantChannel = AndroidNotificationChannel(
    'budget_important',
    'Presupuesto al 90%',
    description: 'Aviso importante cuando un grupo llega al 90% de su presupuesto',
    importance: Importance.high,
  );
  static const _loanDueChannel = AndroidNotificationChannel(
    'loan_due_dates',
    'Vencimiento de préstamos',
    description: 'Recordatorio cuando llega la fecha tentativa de devolución',
  );
  static const _monthCloseChannel = AndroidNotificationChannel(
    'month_close_reminder',
    'Cierre de mes',
    description: 'Recordatorio para cerrar el mes el último día',
  );

  static const _groupThreshold75IdOffset = 1000;
  static const _groupThreshold90IdOffset = 2000;
  static const _loanDueIdOffset = 3000;
  static const _monthCloseId = 4000;

  Future<void> initialize() async {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/La_Paz'));

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(_budgetNoticeChannel);
    await androidPlugin?.createNotificationChannel(_budgetImportantChannel);
    await androidPlugin?.createNotificationChannel(_loanDueChannel);
    await androidPlugin?.createNotificationChannel(_monthCloseChannel);
  }

  Future<void> requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> syncScheduledReminders({
    required MonthRepository monthRepository,
    required LoanRepository loanRepository,
  }) async {
    final activeMonth = await monthRepository.loadCurrentActiveMonth();
    if (activeMonth != null) {
      await scheduleMonthCloseReminder(
        year: activeMonth.month.year,
        month: activeMonth.month.month,
      );
    }
    for (final loan in await loanRepository.loadActiveLoans()) {
      await scheduleLoanDueReminder(loan);
    }
  }

  @override
  Future<void> notifyGroupThreshold({
    required int groupId,
    required String groupName,
    required int thresholdPercent,
  }) async {
    final isImportant = thresholdPercent >= 90;
    final channel = isImportant
        ? _budgetImportantChannel
        : _budgetNoticeChannel;
    final id =
        (isImportant ? _groupThreshold90IdOffset : _groupThreshold75IdOffset) +
        groupId;
    await _plugin.show(
      id: id,
      title: Strings.budgetThresholdTitle(thresholdPercent),
      body: Strings.budgetThresholdBody(groupName, thresholdPercent),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: channel.importance,
          priority: isImportant ? Priority.high : Priority.defaultPriority,
        ),
      ),
    );
  }

  @override
  Future<void> scheduleLoanDueReminder(Loan loan) async {
    final id = _loanDueIdOffset + loan.id;
    final scheduledDate = _atReminderHour(loan.dueDate);
    if (!scheduledDate.isAfter(DateTime.now())) {
      await cancelLoanDueReminder(loan.id);
      return;
    }
    await _plugin.zonedSchedule(
      id: id,
      title: Strings.loanDueTitle,
      body: Strings.loanDueBody(loan.debtorName),
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _loanDueChannel.id,
          _loanDueChannel.name,
          channelDescription: _loanDueChannel.description,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancelLoanDueReminder(int loanId) =>
      _plugin.cancel(id: _loanDueIdOffset + loanId);

  @override
  Future<void> scheduleMonthCloseReminder({
    required int year,
    required int month,
  }) async {
    final scheduledDate = _atReminderHour(lastDayOfMonth(year, month));
    if (!scheduledDate.isAfter(DateTime.now())) {
      return;
    }
    await _plugin.zonedSchedule(
      id: _monthCloseId,
      title: Strings.monthCloseReminderTitle,
      body: Strings.monthCloseReminderBody,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _monthCloseChannel.id,
          _monthCloseChannel.name,
          channelDescription: _monthCloseChannel.description,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancelMonthCloseReminder() =>
      _plugin.cancel(id: _monthCloseId);

  DateTime _atReminderHour(DateTime date) =>
      DateTime(date.year, date.month, date.day, _reminderHour);
}
