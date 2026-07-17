import 'package:flutter/material.dart';
import '../core/strings.dart';
import '../core/theme/theme_controller.dart';
import '../features/business/business_screen.dart';
import '../features/expenses/expense_form_sheet.dart';
import '../features/expenses/expense_repository.dart';
import '../features/home/home_screen.dart';
import '../features/loans/loans_screen.dart';
import '../features/mom/mom_screen.dart';
import '../features/monthly_budget/month_repository.dart';
import '../features/savings/savings_repository.dart';
import '../features/savings/savings_screen.dart';
import '../features/settings/settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.themeController,
    required this.monthRepository,
    required this.expenseRepository,
    required this.savingsRepository,
  });

  final ThemeController themeController;
  final MonthRepository monthRepository;
  final ExpenseRepository expenseRepository;
  final SavingsRepository savingsRepository;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final Stream<ActiveMonth?> _activeMonth =
      widget.monthRepository.watchActiveMonth();

  static const List<String> _titles = [
    Strings.tabHome,
    Strings.tabLoans,
    Strings.tabSavings,
    Strings.tabBusiness,
    Strings.tabMom,
  ];

  late final List<Widget> _screens = [
    HomeScreen(
      monthRepository: widget.monthRepository,
      expenseRepository: widget.expenseRepository,
    ),
    const LoansScreen(),
    SavingsScreen(
      savingsRepository: widget.savingsRepository,
      monthRepository: widget.monthRepository,
      expenseRepository: widget.expenseRepository,
    ),
    const BusinessScreen(),
    const MomScreen(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: Strings.settingsTitle,
            onPressed: _openSettings,
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      floatingActionButton: _selectedIndex == 0 ? _buildExpenseFab() : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: Strings.tabHome,
          ),
          NavigationDestination(
            icon: Icon(Icons.handshake_outlined),
            selectedIcon: Icon(Icons.handshake),
            label: Strings.tabLoans,
          ),
          NavigationDestination(
            icon: Icon(Icons.savings_outlined),
            selectedIcon: Icon(Icons.savings),
            label: Strings.tabSavings,
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: Strings.tabBusiness,
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: Strings.tabMom,
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseFab() {
    return StreamBuilder<ActiveMonth?>(
      stream: _activeMonth,
      builder: (context, snapshot) => FloatingActionButton(
        tooltip: Strings.quickExpenseTooltip,
        onPressed: () => _openQuickExpense(snapshot.data),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openQuickExpense(ActiveMonth? activeMonth) {
    if (activeMonth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(Strings.openMonthFirst)),
      );
      return;
    }
    showQuickExpenseSheet(
      context,
      activeMonth: activeMonth,
      expenseRepository: widget.expenseRepository,
      monthRepository: widget.monthRepository,
    );
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SettingsScreen(themeController: widget.themeController),
      ),
    );
  }
}
