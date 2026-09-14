import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/dimens.dart';
import '../../core/money.dart';
import '../../core/strings.dart';
import '../../core/widgets/sheet_padding.dart';
import '../expenses/month_overview.dart';
import '../savings/savings_repository.dart';
import 'month_repository.dart';

Future<void> handleCloseMonth(
  BuildContext context, {
  required MonthOverview overview,
  required MonthRepository monthRepository,
  required SavingsRepository savingsRepository,
}) async {
  final surplusCents = overview.closingSurplusCents;
  final monthId = overview.activeMonth.month.id;
  if (surplusCents <= 0) {
    await _confirmDeficitClose(
      context,
      surplusCents: surplusCents,
      monthId: monthId,
      monthRepository: monthRepository,
    );
    return;
  }
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => CloseMonthSheet(
      monthId: monthId,
      surplusCents: surplusCents,
      savingsRepository: savingsRepository,
      monthRepository: monthRepository,
    ),
  );
}

Future<void> _confirmDeficitClose(
  BuildContext context, {
  required int surplusCents,
  required int monthId,
  required MonthRepository monthRepository,
}) async {
  final deficitCents = -surplusCents;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text(Strings.closeMonthTitle),
      content: Text(
        deficitCents > 0
            ? Strings.closeMonthDeficitBody(formatBs(deficitCents))
            : Strings.closeMonthZeroSurplusBody,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text(Strings.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text(Strings.closeMonthCta),
        ),
      ],
    ),
  );
  if ((confirmed ?? false) && context.mounted) {
    await monthRepository.closeMonth(
      monthId: monthId,
      surplusCents: surplusCents,
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(Strings.closeMonthDoneMessage)),
      );
    }
  }
}

class CloseMonthSheet extends StatefulWidget {
  const CloseMonthSheet({
    super.key,
    required this.monthId,
    required this.surplusCents,
    required this.savingsRepository,
    required this.monthRepository,
  });

  final int monthId;
  final int surplusCents;
  final SavingsRepository savingsRepository;
  final MonthRepository monthRepository;

  @override
  State<CloseMonthSheet> createState() => _CloseMonthSheetState();
}

class _CloseMonthSheetState extends State<CloseMonthSheet> {
  late final Future<List<SavingsLocation>> _locations = widget
      .savingsRepository
      .loadLocations();

  SavingsLocation? _location;
  bool _saving = false;
  bool _locationMissing = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SavingsLocation>>(
      future: _locations,
      builder: (context, snapshot) {
        final locations = snapshot.data;
        if (locations == null) {
          return const Padding(
            padding: EdgeInsets.all(Dimens.spacingLg),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return _buildForm(context, locations);
      },
    );
  }

  Widget _buildForm(BuildContext context, List<SavingsLocation> locations) {
    final theme = Theme.of(context);
    return SheetPadding(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.closeMonthTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: Dimens.spacingSm),
          Text(
            '${Strings.closeMonthSurplusLabel}: '
            '${formatBs(widget.surplusCents)}',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: Dimens.spacingMd),
          if (locations.isEmpty)
            Text(
              Strings.closeMonthNoLocationsMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            )
          else
            _buildLocationChips(theme, locations),
          const SizedBox(height: Dimens.spacingMd),
          FilledButton(
            onPressed: locations.isEmpty || _saving ? null : _confirm,
            child: const Text(Strings.closeMonthCta),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationChips(ThemeData theme, List<SavingsLocation> locations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.closeMonthLocationLabel,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: Dimens.spacingSm),
        Wrap(
          spacing: Dimens.spacingSm,
          runSpacing: Dimens.spacingXs,
          children: [
            for (final location in locations)
              ChoiceChip(
                avatar: const Icon(Icons.savings_outlined),
                label: Text(location.name),
                selected: _location?.id == location.id,
                onSelected: (_) => setState(() {
                  _location = location;
                  _locationMissing = false;
                }),
              ),
          ],
        ),
        if (_locationMissing)
          Padding(
            padding: const EdgeInsets.only(top: Dimens.spacingXs),
            child: Text(
              Strings.destinationRequiredError,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _confirm() async {
    final location = _location;
    if (location == null) {
      setState(() => _locationMissing = true);
      return;
    }
    setState(() => _saving = true);
    try {
      await widget.monthRepository.closeMonth(
        monthId: widget.monthId,
        surplusCents: widget.surplusCents,
        savingsLocationId: location.id,
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(Strings.closeMonthDoneMessage)),
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
}
