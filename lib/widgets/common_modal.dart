import 'package:flutter/material.dart';

class CommonModal {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    bool barrierDismissible = true,
    Color? primaryColor,
    IconData? icon,
    ModalType modalType = ModalType.info,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _ModalContent(
            title: title,
            message: message,
            primaryButtonText: primaryButtonText,
            secondaryButtonText: secondaryButtonText,
            onPrimaryPressed: onPrimaryPressed,
            onSecondaryPressed: onSecondaryPressed,
            primaryColor: primaryColor,
            icon: icon,
            modalType: modalType,
          ),
        );
      },
    );
  }

  // Convenience methods
  static void showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    bool barrierDismissible = true,
  }) {
    show(
      context: context,
      title: title,
      message: message,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryPressed: onPrimaryPressed,
      onSecondaryPressed: onSecondaryPressed,
      barrierDismissible: barrierDismissible,
      modalType: ModalType.success,
      icon: Icons.check_circle_rounded,
    );
  }

  static void showError({
    required BuildContext context,
    required String title,
    required String message,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    bool barrierDismissible = true,
  }) {
    show(
      context: context,
      title: title,
      message: message,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryPressed: onPrimaryPressed,
      onSecondaryPressed: onSecondaryPressed,
      barrierDismissible: barrierDismissible,
      modalType: ModalType.error,
      icon: Icons.cancel_rounded,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String title,
    required String message,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    bool barrierDismissible = true,
  }) {
    show(
      context: context,
      title: title,
      message: message,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryPressed: onPrimaryPressed,
      onSecondaryPressed: onSecondaryPressed,
      barrierDismissible: barrierDismissible,
      modalType: ModalType.warning,
      icon: Icons.warning_rounded,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String title,
    required String message,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    bool barrierDismissible = true,
  }) {
    show(
      context: context,
      title: title,
      message: message,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryPressed: onPrimaryPressed,
      onSecondaryPressed: onSecondaryPressed,
      barrierDismissible: barrierDismissible,
      modalType: ModalType.info,
      icon: Icons.info_rounded,
    );
  }

  static ModalColorScheme _getColorScheme(
      ModalType type, Color? customColor, BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    if (customColor != null) {
      return ModalColorScheme(
        primary: customColor,
        primaryLight: customColor.withOpacity(0.1),
        container: isDark ? const Color(0xFF1F2937) : Colors.white,
        onContainer: isDark ? Colors.white : const Color(0xFF111827),
        secondaryText: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
      );
    }

    switch (type) {
      case ModalType.success:
        return ModalColorScheme(
          primary: const Color(0xFF10B981),
          primaryLight: const Color(0xFF10B981).withOpacity(0.1),
          container: isDark ? const Color(0xFF1F2937) : Colors.white,
          onContainer: isDark ? Colors.white : const Color(0xFF111827),
          secondaryText: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
        );
      case ModalType.warning:
        return ModalColorScheme(
          primary:  Colors.deepPurple.withOpacity(0.5),
          primaryLight: Colors.deepPurple.withOpacity(0.5),
          container: isDark ? const Color(0xFF1F2937) : Colors.white,
          onContainer: isDark ? Colors.white : const Color(0xFF111827),
          secondaryText: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
        );
      case ModalType.error:
        return ModalColorScheme(
          primary: const Color(0xFFEF4444),
          primaryLight: const Color(0xFFEF4444).withOpacity(0.1),
          container: isDark ? const Color(0xFF1F2937) : Colors.white,
          onContainer: isDark ? Colors.white : const Color(0xFF111827),
          secondaryText: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
        );
      case ModalType.info:
      default:
        return ModalColorScheme(
          primary: const Color(0xFF3B82F6),
          primaryLight: const Color(0xFF3B82F6).withOpacity(0.1),
          container: isDark ? const Color(0xFF1F2937) : Colors.white,
          onContainer: isDark ? Colors.white : const Color(0xFF111827),
          secondaryText: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
        );
    }
  }
}

class _ModalContent extends StatefulWidget {
  final String title;
  final String message;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final Color? primaryColor;
  final IconData? icon;
  final ModalType modalType;

  const _ModalContent({
    required this.title,
    required this.message,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.primaryColor,
    this.icon,
    required this.modalType,
  });

  @override
  State<_ModalContent> createState() => _ModalContentState();
}

class _ModalContentState extends State<_ModalContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        CommonModal._getColorScheme(widget.modalType, widget.primaryColor, context);
    final theme = Theme.of(context);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: colorScheme.container,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 40.0,
                offset: const Offset(0, 20),
                spreadRadius: -5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon section with gradient background
              if (widget.icon != null)
                Container(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      size: 36.0,
                      color: colorScheme.primary,
                    ),
                  ),
                ),

              // Title section
              Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 24.0, 32.0, 12.0),
                child: Text(
                  widget.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Message section
              Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 32.0),
                child: Text(
                  widget.message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.secondaryText,
                    height: 1.6,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Buttons section
              Container(
                padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
                child: widget.secondaryButtonText != null
                    ? Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: widget.onSecondaryPressed ??
                                  () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                side: BorderSide(
                                  color: theme.dividerColor,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                widget.secondaryButtonText!,
                                style: TextStyle(
                                  color: colorScheme.secondaryText,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildPrimaryButton(colorScheme),
                          ),
                        ],
                      )
                    : _buildPrimaryButton(colorScheme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(ModalColorScheme colorScheme) {
    if (widget.primaryButtonText == null) return const SizedBox.shrink();

    return ElevatedButton(
      onPressed: widget.onPrimaryPressed ?? () => Navigator.of(context).pop(),
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 0,
        shadowColor: colorScheme.primary.withOpacity(0.3),
      ),
      child: Text(
        widget.primaryButtonText!,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }
}

enum ModalType { success, error, warning, info }

class ModalColorScheme {
  final Color primary;
  final Color primaryLight;
  final Color container;
  final Color onContainer;
  final Color secondaryText;

  ModalColorScheme({
    required this.primary,
    required this.primaryLight,
    required this.container,
    required this.onContainer,
    required this.secondaryText,
  });
}