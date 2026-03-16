import 'package:flutter/material.dart';
import 'package:posternova/providers/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Appearance section ──────────────────────────────────
          _SectionHeader(title: 'Appearance'),
          const SizedBox(height: 8),
          _ThemeSelector(),
          const SizedBox(height: 24),

          // ── Quick toggle ────────────────────────────────────────
          _SectionHeader(title: 'Quick Toggle'),
          const SizedBox(height: 8),
          _QuickToggleTile(),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Section header
// ────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// 3-option theme card selector (System / Light / Dark)
// ────────────────────────────────────────────────────────────────────────────
class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    final options = [
      _ThemeOption(
        label: 'System',
        icon: Icons.brightness_auto_rounded,
        mode: ThemeMode.system,
        onTap: provider.setSystemMode,
      ),
      _ThemeOption(
        label: 'Light',
        icon: Icons.light_mode_rounded,
        mode: ThemeMode.light,
        onTap: provider.setLightMode,
      ),
      _ThemeOption(
        label: 'Dark',
        icon: Icons.dark_mode_rounded,
        mode: ThemeMode.dark,
        onTap: provider.setDarkMode,
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Mode',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Choose how the app looks',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: options
                  .map((opt) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _ThemeModeCard(
                            option: opt,
                            isSelected: provider.themeMode == opt.mode,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption {
  final String label;
  final IconData icon;
  final ThemeMode mode;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.mode,
    required this.onTap,
  });
}

class _ThemeModeCard extends StatelessWidget {
  final _ThemeOption option;
  final bool isSelected;

  const _ThemeModeCard({required this.option, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: option.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                option.icon,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withOpacity(0.6),
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                option.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? colorScheme.primary
                      : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Quick toggle tile
// ────────────────────────────────────────────────────────────────────────────
class _QuickToggleTile extends StatelessWidget {
  const _QuickToggleTile();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    final isDark = provider.isDarkMode ||
        (provider.isSystemMode &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Card(
      child: SwitchListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        secondary: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            key: ValueKey(isDark),
            color: colorScheme.primary,
          ),
        ),
        title: Text(
          isDark ? 'Dark Mode' : 'Light Mode',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          isDark ? 'Using dark theme' : 'Using light theme',
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontSize: 13,
          ),
        ),
        value: isDark,
        onChanged: (_) => provider.toggleTheme(),
      ),
    );
  }
}