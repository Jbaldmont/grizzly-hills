import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/dimens.dart';
import '../../core/money.dart';
import '../../core/strings.dart';
import '../../core/widgets/sheet_padding.dart';
import '../expenses/expense_repository.dart';
import '../monthly_budget/month_repository.dart';
import 'savings_repository.dart';

class TransferDestination {
  const TransferDestination.group(BudgetGroup this.group) : location = null;

  const TransferDestination.savings(SavingsLocation this.location)
      : group = null;

  final BudgetGroup? group;
  final SavingsLocation? location;

  String get label => group?.name ?? location!.name;
}

void showTransferSheet(
  BuildContext context, {
  required ActiveMonth activeMonth,
  required List<SavingsLocation> locations,
  required SavingsRepository savingsRepository,
  required MonthRepository monthRepository,
  required ExpenseRepository expenseRepository,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => TransferSheet(
      activeMonth: activeMonth,
      locations: locations,
      savingsRepository: savingsRepository,
      monthRepository: monthRepository,
      expenseRepository: expenseRepository,
    ),
  );
}

class TransferSheet extends StatefulWidget {
  const TransferSheet({
    super.key,
    required this.activeMonth,
    required this.locations,
    required this.savingsRepository,
    required this.monthRepository,
    required this.expenseRepository,
  });

  final ActiveMonth activeMonth;
  final List<SavingsLocation> locations;
  final SavingsRepository savingsRepository;
  final MonthRepository monthRepository;
  final ExpenseRepository expenseRepository;

  @override
  State<TransferSheet> createState() => _TransferSheetState();
}

class _TransferSheetState extends State<TransferSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  late final Future<List<Expense>> _expenses = widget.expenseRepository
      .loadExpenses(widget.activeMonth.month.id);

  BudgetGroup? _source;
  TransferDestination? _destination;
  bool _saving = false;
  bool _sourceMissing = false;
  bool _destinationMissing = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Expense>>(
      future: _expenses,
      builder: (context, snapshot) {
        final expenses = snapshot.data;
        if (expenses == null) {
          return const Padding(
            padding: EdgeInsets.all(Dimens.spacingLg),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return _buildForm(context, expenses);
      },
    );
  }

  Widget _buildForm(BuildContext context, List<Expense> expenses) {
    final theme = Theme.of(context);
    return SheetPadding(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(Strings.transferTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: Dimens.spacingMd),
            _buildSourceChips(theme, expenses),
            const SizedBox(height: Dimens.spacingMd),
            _buildDestinationChips(theme),
            const SizedBox(height: Dimens.spacingMd),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: Strings.amountLabel,
                prefixText: '${Strings.currency} ',
                border: OutlineInputBorder(),
              ),
              validator: _validateAmount,
            ),
            const SizedBox(height: Dimens.spacingMd),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: const Text(Strings.transferCta),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceChips(ThemeData theme, List<Expense> expenses) {
    final source = _source;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.transferSourceLabel, style: theme.textTheme.titleSmall),
        const SizedBox(height: Dimens.spacingSm),
        Wrap(
          spacing: Dimens.spacingSm,
          runSpacing: Dimens.spacingXs,
          children: [
            for (final group in widget.activeMonth.groups)
              ChoiceChip(
                label: Text(group.name),
                selected: _source?.id == group.id,
                onSelected: (_) => _selectSource(group),
              ),
          ],
        ),
        if (source != null) ...[
          const SizedBox(height: Dimens.spacingXs),
          Text(
            '${Strings.groupAvailableLabel}: '
            '${formatBs(_remainingCents(source, expenses))}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        if (_sourceMissing)
          _buildMissingError(theme, Strings.transferSourceRequiredError),
      ],
    );
  }

  Widget _buildDestinationChips(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.transferDestinationLabel,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: Dimens.spacingSm),
        Wrap(
          spacing: Dimens.spacingSm,
          runSpacing: Dimens.spacingXs,
          children: [
            for (final group in widget.activeMonth.groups)
              if (group.id != _source?.id)
                ChoiceChip(
                  label: Text(group.name),
                  selected: _destination?.group?.id == group.id,
                  onSelected: (_) => setState(() {
                    _destination = TransferDestination.group(group);
                    _destinationMissing = false;
                  }),
                ),
            for (final location in widget.locations)
              ChoiceChip(
                avatar: const Icon(Icons.savings_outlined),
                label: Text(location.name),
                selected: _destination?.location?.id == location.id,
                onSelected: (_) => setState(() {
                  _destination = TransferDestination.savings(location);
                  _destinationMissing = false;
                }),
              ),
          ],
        ),
        if (_destinationMissing)
          _buildMissingError(theme, Strings.destinationRequiredError),
      ],
    );
  }

  Widget _buildMissingError(ThemeData theme, String message) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimens.spacingXs),
      child: Text(
        message,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
    );
  }

  void _selectSource(BudgetGroup group) {
    setState(() {
      _source = group;
      _sourceMissing = false;
      if (_destination?.group?.id == group.id) {
        _destination = null;
      }
    });
  }

  int _remainingCents(BudgetGroup group, List<Expense> expenses) {
    final spentCents = expenses.fold<int>(0, (sum, expense) {
      return expense.groupId == group.id ? sum + expense.amountCents : sum;
    });
    return group.budgetCents - spentCents;
  }

  String? _validateAmount(String? value) {
    final cents = parseBsToCents(value ?? '');
    if (cents == null || cents <= 0) {
      return Strings.invalidAmountError;
    }
    return null;
  }

  Future<void> _save() async {
    final source = _source;
    final destination = _destination;
    final amountValid = _formKey.currentState!.validate();
    setState(() {
      _sourceMissing = source == null;
      _destinationMissing = destination == null;
    });
    if (source == null || destination == null || !amountValid) {
      return;
    }
    final amountCents = parseBsToCents(_amountController.text)!;
    setState(() => _saving = true);
    try {
      final transferred = await _transfer(source, destination, amountCents);
      if (!mounted) {
        return;
      }
      if (!transferred) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(Strings.transferExceedsRemainingError)),
        );
        return;
      }
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(Strings.transferDoneMessage)),
      );
    } on Exception {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(Strings.errorGeneric)));
      }
    }
  }

  Future<bool> _transfer(
    BudgetGroup source,
    TransferDestination destination,
    int amountCents,
  ) async {
    final expenses = await widget.expenseRepository.loadExpenses(
      widget.activeMonth.month.id,
    );
    if (amountCents > _remainingCents(source, expenses)) {
      return false;
    }
    final targetGroup = destination.group;
    if (targetGroup != null) {
      await widget.monthRepository.transferBetweenGroups(
        sourceGroupId: source.id,
        targetGroupId: targetGroup.id,
        amountCents: amountCents,
      );
      return true;
    }
    final location = destination.location!;
    await widget.savingsRepository.transferGroupToSavings(
      monthId: widget.activeMonth.month.id,
      groupId: source.id,
      locationId: location.id,
      description: '${Strings.transferToSavingsDescription}: ${location.name}',
      amountCents: amountCents,
    );
    return true;
  }
}
