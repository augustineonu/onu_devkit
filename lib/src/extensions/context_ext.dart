import 'package:flutter/material.dart';

/// Extension on BuildContext to provide convenient navigation and utility methods
extension BuildContextExt on BuildContext {
  // ==================== Navigation Methods ====================

  /// Navigate to a new screen
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push<T>(MaterialPageRoute(builder: (_) => page));
  }

  /// Navigate to a new screen with a custom route
  Future<T?> pushRoute<T>(Route<T> route) {
    return Navigator.of(this).push<T>(route);
  }

  /// Navigate to a named route
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  /// Replace current screen with a new one
  Future<T?> pushReplacement<T, TO>(Widget page, {TO? result}) {
    return Navigator.of(this).pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
      result: result,
    );
  }

  /// Replace current screen with a named route
  Future<T?> pushReplacementNamed<T, TO>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.of(this).pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  /// Push a new route and remove all previous routes
  Future<T?> pushAndRemoveUntil<T>(
    Widget page, {
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.of(this).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      predicate ?? (route) => false,
    );
  }

  /// Push a named route and remove all previous routes
  Future<T?> pushNamedAndRemoveUntil<T>(
    String routeName, {
    bool Function(Route<dynamic>)? predicate,
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamedAndRemoveUntil<T>(
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  /// Pop the current route
  void pop<T>([T? result]) {
    if (canPop()) {
      Navigator.of(this).pop<T>(result);
    }
  }

  /// Check if we can pop the current route
  bool canPop() {
    return Navigator.of(this).canPop();
  }

  /// Pop until a specific route
  void popUntil(String routeName) {
    Navigator.of(this).popUntil((route) {
      return route.settings.name == routeName || route.isFirst;
    });
  }

  /// Pop until the first route
  void popUntilFirst() {
    Navigator.of(this).popUntil((route) => route.isFirst);
  }

  // ==================== Utility Methods ====================

  /// Get the current theme
  ThemeData get theme => Theme.of(this);

  /// Get the current text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get the current color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Check if dark mode is enabled
  bool get isDarkMode {
    return View.of(this).platformDispatcher.platformBrightness ==
        Brightness.dark;
  }

  /// Get MediaQuery for this context
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen size
  Size get screenSize => mediaQuery.size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Get screen padding
  EdgeInsets get screenPadding => mediaQuery.padding;

  /// Get view padding
  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  /// Get view insets (keyboard height, etc.)
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  /// Get safe area padding
  EdgeInsets get safeAreaPadding => mediaQuery.padding;

  /// Show a snackbar at the top of the screen
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    final overlay = Overlay.maybeOf(this);
    if (overlay == null) return;
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _TopSnackBarWidget(
        message: message,
        backgroundColor: backgroundColor ?? Colors.black87,
        textStyle:
            textStyle ?? const TextStyle(color: Colors.white, fontSize: 14),
        duration: duration,
        onDismiss: () {
          if (overlayEntry.mounted) {
            overlayEntry.remove();
          }
        },
      ),
    );

    overlay.insert(overlayEntry);
  }

  /// Show an error snackbar at the top
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: theme.colorScheme.error,
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// Show a snackbar (success by default) at the top
  void snackbar(String message, {bool isError = false}) {
    if (isError) {
      showErrorSnackBar(message);
    } else {
      showSuccessSnackBar(message);
    }
  }

  /// Show a success snackbar at the top
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      duration: const Duration(seconds: 2),
      backgroundColor: const Color(0xFF22C55E), // Generic success green
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// Show a dialog
  Future<T?> showAppDialog<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = false,
    RouteSettings? routeSettings,
  }) {
    return showDialog<T>(
      context: this,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
    );
  }

  /// Show a bottom sheet
  Future<T?> showBottomSheet<T>({
    required WidgetBuilder builder,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool useSafeArea = false,
    RouteSettings? routeSettings,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      builder: builder,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      useSafeArea: useSafeArea,
      routeSettings: routeSettings,
    );
  }

  /// Hide keyboard
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  /// Request focus on a node
  void requestFocus(FocusNode node) {
    FocusScope.of(this).requestFocus(node);
  }
}

/// A custom widget for the top-aligned snackbar
class _TopSnackBarWidget extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final TextStyle textStyle;
  final Duration duration;
  final VoidCallback onDismiss;

  const _TopSnackBarWidget({
    required this.message,
    required this.backgroundColor,
    required this.textStyle,
    required this.duration,
    required this.onDismiss,
  });

  @override
  _TopSnackBarWidgetState createState() => _TopSnackBarWidgetState();
}

class _TopSnackBarWidgetState extends State<_TopSnackBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(widget.message, style: widget.textStyle),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
