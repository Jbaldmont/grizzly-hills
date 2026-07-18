import 'dart:math';

import 'package:flutter/material.dart';
import '../../core/dimens.dart';
import '../../core/money.dart';
import '../../core/strings.dart';
import '../expenses/expense_repository.dart';
import '../expenses/month_overview.dart';
import 'month_repository.dart';

class _GroupRow {
  _GroupRow({required this.name, required this.controller, this.groupId});

  final String name;
  final TextEditingController controller;

  final int? groupId;
}

class StartMonthScreen extends StatefulWidget {
  const StartMonthScreen({
    super.key,
    required this.repository,
    required this.expenseRepository,
    this.monthToEdit,
  });

  final MonthRepository repository;
  final ExpenseRepository expenseRepository;
  final ActiveMonth? monthToEdit;

  @override
  State<StartMonthScreen> createState() => _StartMonthScreenState();
}

class _StartMonthScreenState extends State<StartMonthScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _salaryController;

  List<_GroupRow>? _rows;
  Map<int, int> _minBudgetByGroupId = const {};
  bool _saving = false;

  bool get _isEditing => widget.monthToEdit != null;

  @override
  void initState() {
    super.initState();
    final monthToEdit = widget.monthToEdit;
    _salaryController = TextEditingController(
      text: monthToEdit == null
          ? ''
          : centsToEditableText(monthToEdit.month.salaryCents),
    );
    if (monthToEdit == null) {
      _loadTemplateRows();
    } else {
      _rows = [
        for (final group in monthToEdit.groups)
          _GroupRow(
            name: group.name,
            groupId: group.id,
            controller: TextEditingController(
              text: centsToEditableText(group.budgetCents),
            ),
          ),
      ];
      _loadMinBudgets(monthToEdit);
    }
  }

  Future<void> _loadMinBudgets(ActiveMonth monthToEdit) async {
    final expenses = await widget.expenseRepository.loadExpenses(
      monthToEdit.month.id,
    );
    if (!mounted) {
      return;
    }
    final overview = MonthOverview(
      activeMonth: monthToEdit,
      expenses: expenses,
    );
    setState(() {
      _minBudgetByGroupId = {
        for (final group in monthToEdit.groups)
          group.id: max(
            0,
            overview.spentInGroupCents(group.id) -
                overview.extensionCentsForGroup(group.id),
          ),
      };
    });
  }

  @override
  void dispose() {
    _salaryController.dispose();
    for (final row in _rows ?? <_GroupRow>[]) {
      row.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? Strings.editMonthTitle : Strings.startMonthTitle,
        ),
      ),
      body: SafeArea(
        top: false,
        child: rows == null
            ? const Center(child: CircularProgressIndicator())
            : _buildForm(rows),
      ),
    );
  }

  Widget _buildForm(List<_GroupRow> rows) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(Dimens.spacingMd),
        children: [
          TextFormField(
            controller: _salaryController,
            autofocus: !_isEditing,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: Strings.salaryLabel,
              prefixText: '${Strings.currency} ',
              border: OutlineInputBorder(),
            ),
            validator: _validateSalary,
          ),
          const SizedBox(height: Dimens.spacingLg),
          Text(
            Strings.groupsSectionTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: Dimens.spacingSm),
          for (final row in rows)
            _GroupAmountField(
              name: row.name,
              controller: row.controller,
              minCents: _minBudgetByGroupId[row.groupId] ?? 0,
            ),
          const SizedBox(height: Dimens.spacingMd),
          _TotalsSummary(
            salaryController: _salaryController,
            groupControllers: [for (final row in rows) row.controller],
          ),
          const SizedBox(height: Dimens.spacingLg),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(
              _isEditing ? Strings.saveChanges : Strings.startMonthConfirm,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadTemplateRows() async {
    final templates = await widget.repository.loadTemplates();
    if (!mounted) {
      return;
    }
    setState(() {
      _rows = [
        for (final template in templates)
          _GroupRow(
            name: template.name,
            controller: TextEditingController(
              text: centsToEditableText(template.budgetCents),
            ),
          ),
      ];
    });
  }

  String? _validateSalary(String? value) {
    if (value == null || value.trim().isEmpty) {
      return Strings.salaryRequiredError;
    }
    final cents = parseBsToCents(value);
    if (cents == null || cents <= 0) {
      return Strings.invalidAmountError;
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final rows = _rows!;
    final salaryCents = parseBsToCents(_salaryController.text)!;
    final assignedCents = rows.fold(
      0,
      (sum, row) => sum + parseBsToCents(row.controller.text)!,
    );
    if (assignedCents > salaryCents && !await _confirmOverAssigned()) {
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() => _saving = true);
    try {
      await _persist(rows, salaryCents);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } on Exception {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(Strings.errorGeneric)));
      }
    }
  }

  Future<void> _persist(List<_GroupRow> rows, int salaryCents) {
    final monthToEdit = widget.monthToEdit;
    if (monthToEdit == null) {
      return widget.repository.startMonth(
        date: DateTime.now(),
        salaryCents: salaryCents,
        groups: [
          for (final row in rows)
            GroupDraft(
              name: row.name,
              budgetCents: parseBsToCents(row.controller.text)!,
            ),
        ],
      );
    }
    return widget.repository.updateMonth(
      monthId: monthToEdit.month.id,
      salaryCents: salaryCents,
      groupBudgetsCents: {
        for (final row in rows)
          row.groupId!: parseBsToCents(row.controller.text)!,
      },
    );
  }

  Future<bool> _confirmOverAssigned() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(Strings.overAssignedDialogTitle),
        content: const Text(Strings.overAssignedDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(Strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(Strings.continueAnyway),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}

class _GroupAmountField extends StatelessWidget {
  const _GroupAmountField({
    required this.name,
    required this.controller,
    this.minCents = 0,
  });

  final String name;
  final TextEditingController controller;
  final int minCents;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.spacingSm),
      child: Row(
        children: [
          Expanded(child: Text(name)),
          SizedBox(
            width: Dimens.amountFieldWidth,
            child: TextFormField(
              controller: controller,
              textAlign: TextAlign.end,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                prefixText: '${Strings.currency} ',
                border: OutlineInputBorder(),
                isDense: true,
                errorMaxLines: 2,
              ),
              validator: _validateAmount,
            ),
          ),
        ],
      ),
    );
  }

  String? _validateAmount(String? value) {
    final cents = parseBsToCents(value ?? '');
    if (cents == null) {
      return Strings.invalidAmountError;
    }
    if (cents < minCents) {
      return Strings.budgetBelowSpentError(formatBs(minCents));
    }
    return null;
  }
}

class _TotalsSummary extends StatelessWidget {
  const _TotalsSummary({
    required this.salaryController,
    required this.groupControllers,
  });

  final TextEditingController salaryController;
  final List<TextEditingController> groupControllers;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([salaryController, ...groupControllers]),
      builder: (context, _) {
        final salaryCents = parseBsToCents(salaryController.text) ?? 0;
        final assignedCents = groupControllers.fold(
          0,
          (sum, controller) => sum + (parseBsToCents(controller.text) ?? 0),
        );
        final generalCents = salaryCents - assignedCents;
        final theme = Theme.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SummaryRow(
              label: Strings.assignedRowLabel,
              amountCents: assignedCents,
            ),
            const SizedBox(height: Dimens.spacingXs),
            _SummaryRow(
              label: Strings.generalBudgetRowLabel,
              amountCents: generalCents,
              emphasized: true,
            ),
            if (generalCents < 0) ...[
              const SizedBox(height: Dimens.spacingXs),
              Text(
                Strings.overAssignedWarning,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.amountCents,
    this.emphasized = false,
  });

  final String label;
  final int amountCents;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = emphasized
        ? theme.textTheme.titleMedium?.copyWith(
            color: amountCents < 0
                ? theme.colorScheme.error
                : theme.colorScheme.primary,
          )
        : theme.textTheme.bodyMedium;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(formatBs(amountCents), style: style),
      ],
    );
  }
}
