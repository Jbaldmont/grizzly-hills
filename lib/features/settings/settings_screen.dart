import 'package:flutter/material.dart';
import '../../core/dimens.dart';
import '../../core/strings.dart';
import '../../core/theme/app_themes.dart';
import '../../core/theme/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.settingsTitle)),
      body: ListenableBuilder(
        listenable: themeController,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(Dimens.spacingMd),
          children: [
            Text(Strings.settingsThemeMode, style: textTheme.titleMedium),
            const SizedBox(height: Dimens.spacingSm),
            _ThemeModeSelector(controller: themeController),
            const SizedBox(height: Dimens.spacingLg),
            Text(Strings.settingsThemeScheme, style: textTheme.titleMedium),
            const SizedBox(height: Dimens.spacingSm),
            for (final option in availableThemes)
              _ThemeOptionTile(option: option, controller: themeController),
          ],
        ),
      ),
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector({required this.controller});

  final ThemeController controller;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment(
          value: ThemeMode.system,
          label: Text(Strings.themeModeSystem),
          icon: Icon(Icons.brightness_auto_outlined),
        ),
        ButtonSegment(
          value: ThemeMode.light,
          label: Text(Strings.themeModeLight),
          icon: Icon(Icons.light_mode_outlined),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          label: Text(Strings.themeModeDark),
          icon: Icon(Icons.dark_mode_outlined),
        ),
      ],
      selected: {controller.mode},
      onSelectionChanged: (selection) => controller.setMode(selection.first),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({required this.option, required this.controller});

  final AppThemeOption option;
  final ThemeController controller;

  @override
  Widget build(BuildContext context) {
    final isSelected = controller.scheme == option.scheme;
    return Card(
      child: ListTile(
        leading: _SchemePreview(option: option),
        title: Text(option.label),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        selected: isSelected,
        onTap: () => controller.setScheme(option.scheme),
      ),
    );
  }
}

class _SchemePreview extends StatelessWidget {
  const _SchemePreview({required this.option});

  final AppThemeOption option;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ColorDot(color: option.lightPrimary),
        const SizedBox(width: Dimens.spacingXs),
        _ColorDot(color: option.darkPrimary),
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimens.colorDotSize,
      height: Dimens.colorDotSize,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
