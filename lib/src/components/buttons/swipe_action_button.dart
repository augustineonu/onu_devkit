import 'package:flutter/material.dart';

enum SwipeDirection { leftToRight, rightToLeft }

class SwipeActionButton extends StatefulWidget {
  final String label;
  final Color trackColor;
  final Color thumbColor;
  final Color labelColor;
  final Color thumbIconColor;
  final IconData thumbIcon;
  final SwipeDirection direction;
  final double height;
  final double thumbSize;
  final double swipeThreshold; // 0.0 - 1.0
  final VoidCallback onSwiped;

  const SwipeActionButton({
    super.key,
    required this.label,
    required this.onSwiped,
    this.trackColor = const Color(0xFF054994),
    this.thumbColor = const Color(0x26FFFFFF),
    this.labelColor = Colors.white,
    this.thumbIcon = Icons.arrow_forward_rounded,
    this.direction = SwipeDirection.leftToRight,
    this.height = 56,
    this.thumbSize = 48,
    this.swipeThreshold = 0.85,
    this.thumbIconColor = const Color(0xFF054994),
  });

  /// Named constructor for clock-in (convenience)
  const SwipeActionButton.clockIn({
    super.key,
    required this.onSwiped,
    this.label = 'Swipe to clock in >>>',
    this.trackColor = const Color(0xFF054994),
    this.thumbColor = Colors.white,
    this.labelColor = Colors.white,
    this.thumbIcon = Icons.arrow_forward_rounded,
    this.height = 56,
    this.thumbSize = 48,
    this.swipeThreshold = 0.85,
    this.thumbIconColor = const Color(0xFF054994),
  }) : direction = SwipeDirection.leftToRight;

  /// Named constructor for clock-out (convenience)
  const SwipeActionButton.clockOut({
    super.key,
    required this.onSwiped,
    this.label = '<<< Swipe to clock out',
    this.trackColor = const Color(0xFFEF4444),
    this.thumbColor = Colors.white,
    this.labelColor = Colors.white,
    this.thumbIcon = Icons.arrow_back_rounded,
    this.height = 56,
    this.thumbSize = 48,
    this.swipeThreshold = 0.85,
    this.thumbIconColor = Colors.white,
  }) : direction = SwipeDirection.rightToLeft;

  @override
  State<SwipeActionButton> createState() => _SwipeActionButtonState();
}

class _SwipeActionButtonState extends State<SwipeActionButton>
    with SingleTickerProviderStateMixin {
  double _dragX = 0;
  bool _completed = false;
  late AnimationController _snapController;
  late Animation<double> _snapAnimation;
  double _lastDragX = 0;

  static const double _trackPadding = 4;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  bool get _isRTL => widget.direction == SwipeDirection.rightToLeft;

  double _maxDrag(double trackWidth) =>
      trackWidth - widget.thumbSize - (_trackPadding * 2);

  double _progress(double trackWidth) =>
      (_dragX / _maxDrag(trackWidth)).clamp(0.0, 1.0);

  void _onDragUpdate(DragUpdateDetails d, double trackWidth) {
    if (_completed) return;
    final delta = _isRTL ? -d.delta.dx : d.delta.dx;
    setState(() {
      _dragX = (_dragX + delta).clamp(0, _maxDrag(trackWidth));
      _lastDragX = _dragX;
    });
  }

  void _onDragEnd(double trackWidth) {
    if (_completed) return;

    if (_progress(trackWidth) >= widget.swipeThreshold) {
      // Snap to end then fire callback
      _snapTo(
        _maxDrag(trackWidth),
        onDone: () {
          setState(() => _completed = true);
          widget.onSwiped();
          Future.delayed(const Duration(milliseconds: 600), _reset);
        },
      );
    } else {
      // Snap back to start
      _snapTo(0);
    }
  }

  void _snapTo(double target, {VoidCallback? onDone}) {
    final start = _dragX;
    _snapAnimation =
        Tween<double>(begin: start, end: target).animate(
          CurvedAnimation(parent: _snapController, curve: Curves.easeOut),
        )..addListener(() {
          setState(() => _dragX = _snapAnimation.value);
        });

    _snapController.forward(from: 0).then((_) => onDone?.call());
  }

  void _reset() {
    setState(() {
      _dragX = 0;
      _completed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        final maxDrag = _maxDrag(trackWidth);
        final progress = _progress(trackWidth);

        // For RTL: thumb starts at the right end
        final thumbOffset = _isRTL
            ? (maxDrag - _dragX) + _trackPadding
            : _dragX + _trackPadding;

        return GestureDetector(
          onHorizontalDragUpdate: (d) => _onDragUpdate(d, trackWidth),
          onHorizontalDragEnd: (_) => _onDragEnd(trackWidth),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: widget.height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: widget.trackColor,
              borderRadius: BorderRadius.circular(widget.height / 2),
            ),
            padding: const EdgeInsets.all(_trackPadding),
            child: Stack(
              children: [
                /// Progress fill overlay
                AnimatedContainer(
                  duration: Duration.zero,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08 * progress),
                    borderRadius: BorderRadius.circular(
                      (widget.height - _trackPadding) / 2,
                    ),
                  ),
                ),

                /// Label — fades as thumb approaches
                Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 100),
                    opacity: _completed
                        ? 0
                        : (1 - (progress * 2)).clamp(0.0, 1.0),
                    child: Text(
                      widget.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: widget.labelColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                /// Completion checkmark
                if (_completed)
                  Center(
                    child: Icon(
                      Icons.check_rounded,
                      color: widget.labelColor,
                      size: 24,
                    ),
                  ),

                /// Draggable thumb
                Positioned(
                  left: thumbOffset,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: widget.thumbSize,
                      height: widget.thumbSize,
                      decoration: BoxDecoration(
                        color: widget.thumbColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _completed ? Icons.check_rounded : widget.thumbIcon,
                        color: widget.thumbIconColor,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


// Examples:
// // Clock in — left to right (default)
// SwipeActionButton.clockIn(
//   onSwiped: controller.clockIn,
// )

// // Clock out — right to left
// SwipeActionButton.clockOut(
//   onSwiped: controller.clockOut,
// )

// // Fully custom — e.g. confirm a leave request
// SwipeActionButton(
//   label: 'Swipe to submit request',
//   trackColor: AppColors.actionLeave,
//   thumbIcon: Icons.flight_takeoff_rounded,
//   direction: SwipeDirection.leftToRight,
//   onSwiped: controller.submitLeave,
// )

// // Custom threshold — easier to trigger
// SwipeActionButton.clockIn(
//   onSwiped: controller.clockIn,
//   swipeThreshold: 0.70,
// )