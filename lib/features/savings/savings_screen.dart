import 'package:flutter/material.dart';

import '../../core/db/app_database.dart';
import '../../core/dimens.dart';
import '../../core/strings.dart';
import '../../core/widgets/error_state.dart';
import '../../core/widgets/total_amount_card.dart';
import '../expenses/expense_repository.dart';
import '../monthly_budget/month_repository.dart';
import 'location_name_dialog.dart';
import 'savings_movement_sheet.dart';
import 'savings_repository.dart';
import 'transfer_sheet.dart';
import 'widgets/savings_location_card.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({
    super.key,
    required this.savingsRepository,
    required this.monthRepository,
    required this.expenseRepository,
  });

  final SavingsRepository savingsRepository;
  final MonthRepository monthRepository;
  final ExpenseRepository expenseRepository;

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  late final Stream<List<SavingsLocation>> _locations = widget
      .savingsRepository
      .watchLocations();
  late final Stream<ActiveMonth?> _activeMonth = widget.monthRepository
      .watchActiveMonth();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SavingsLocation>>(
      stream: _locations,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ErrorState();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final locations = snapshot.data ?? [];
        if (locations.isEmpty) {
          return _EmptyState(onAddLocation: _addLocation);
        }
        return _buildContent(locations);
      },
    );
  }

  Widget _buildContent(List<SavingsLocation> locations) {
    final theme = Theme.of(context);
    final totalCents = locations.fold<int>(
      0,
      (sum, location) => sum + location.balanceCents,
    );
    return StreamBuilder<ActiveMonth?>(
      stream: _activeMonth,
      builder: (context, snapshot) {
        final activeMonth = snapshot.data;
        return ListView(
          padding: const EdgeInsets.all(Dimens.spacingMd),
          children: [
            TotalAmountCard(
              label: Strings.savingsTotalLabel,
              totalCents: totalCents,
            ),
            const SizedBox(height: Dimens.spacingSm),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _addLocation,
                    icon: const Icon(Icons.add),
                    label: const Text(Strings.addLocationCta),
                  ),
                ),
                const SizedBox(width: Dimens.spacingSm),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _openTransfer(activeMonth, locations),
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text(Strings.transferCta),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimens.spacingMd),
            Text(
              Strings.savingsLocationsSectionTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: Dimens.spacingSm),
            for (final location in locations)
              SavingsLocationCard(
                location: location,
                onTap: () => showSavingsMovementSheet(
                  context,
                  location: location,
                  savingsRepository: widget.savingsRepository,
                ),
                onAction: (action) => _handleLocationAction(location, action),
              ),
          ],
        );
      },
    );
  }

  Future<void> _addLocation() async {
    final name = await showLocationNameDialog(context);
    if (name != null) {
      await widget.savingsRepository.addLocation(name);
    }
  }

  void _openTransfer(ActiveMonth? activeMonth, List<SavingsLocation> locations) {
    if (activeMonth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(Strings.openMonthFirst)),
      );
      return;
    }
    showTransferSheet(
      context,
      activeMonth: activeMonth,
      locations: locations,
      savingsRepository: widget.savingsRepository,
      monthRepository: widget.monthRepository,
      expenseRepository: widget.expenseRepository,
    );
  }

  Future<void> _handleLocationAction(
    SavingsLocation location,
    SavingsLocationAction action,
  ) {
    switch (action) {
      case SavingsLocationAction.rename:
        return _renameLocation(location);
      case SavingsLocationAction.delete:
        return _deleteLocation(location);
    }
  }

  Future<void> _renameLocation(SavingsLocation location) async {
    final name = await showLocationNameDialog(
      context,
      initialName: location.name,
    );
    if (name != null) {
      await widget.savingsRepository.renameLocation(
        id: location.id,
        name: name,
      );
    }
  }

  Future<void> _deleteLocation(SavingsLocation location) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(Strings.deleteLocationTitle),
        content: const Text(Strings.deleteLocationBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(Strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(Strings.delete),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await widget.savingsRepository.deleteLocation(location.id);
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAddLocation});

  final VoidCallback onAddLocation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.savings_outlined,
              size: Dimens.iconXl,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: Dimens.spacingMd),
            Text(Strings.savingsEmptyTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: Dimens.spacingXs),
            Text(
              Strings.savingsEmptyBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Dimens.spacingLg),
            FilledButton.icon(
              onPressed: onAddLocation,
              icon: const Icon(Icons.add),
              label: const Text(Strings.addLocationCta),
            ),
          ],
        ),
      ),
    );
  }
}
