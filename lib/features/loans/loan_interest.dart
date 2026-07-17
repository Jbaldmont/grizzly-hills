import '../../core/dates.dart';
import '../../core/db/app_database.dart';

const int _daysPerWeek = 7;
const int _weeklyRatePercent = 1;

int interestDays(DateTime from, DateTime to) {
  return dateOnly(to).difference(dateOnly(from)).inDays;
}

int interestCents({required int principalCents, required int days}) {
  if (days <= 0) {
    return 0;
  }
  return (principalCents * _weeklyRatePercent * days / (100 * _daysPerWeek))
      .round();
}

int accruedInterestCents(Loan loan, DateTime onDate) {
  return interestCents(
    principalCents: loan.principalCents,
    days: interestDays(loan.interestStartDate, onDate),
  );
}

int totalOwedCents(Loan loan, DateTime onDate) {
  return loan.principalCents + accruedInterestCents(loan, onDate);
}

bool isOverdue(Loan loan, DateTime onDate) {
  return dateOnly(onDate).isAfter(dateOnly(loan.dueDate));
}
