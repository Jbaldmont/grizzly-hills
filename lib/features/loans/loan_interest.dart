import '../../core/dates.dart';
import '../../core/db/app_database.dart';

const int _daysPerWeek = 7;
const double defaultWeeklyRatePercent = 1;

int interestDays(DateTime from, DateTime to) {
  return dateOnly(to).difference(dateOnly(from)).inDays;
}

int chargedWeeks(int days) {
  if (days <= 0) {
    return 0;
  }
  return (days / _daysPerWeek).ceil();
}

int interestCents({
  required int principalCents,
  required int days,
  double weeklyRatePercent = defaultWeeklyRatePercent,
}) {
  return (principalCents * weeklyRatePercent * chargedWeeks(days) / 100)
      .round();
}

int accruedInterestCents(Loan loan, DateTime onDate) {
  return interestCents(
    principalCents: loan.principalCents,
    days: interestDays(loan.interestStartDate, onDate),
    weeklyRatePercent: loan.weeklyRatePercent,
  );
}

int totalOwedCents(Loan loan, DateTime onDate) {
  return loan.principalCents + accruedInterestCents(loan, onDate);
}

bool isOverdue(Loan loan, DateTime onDate) {
  return dateOnly(onDate).isAfter(dateOnly(loan.dueDate));
}
