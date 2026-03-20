import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum MonthLabelAlignment { left, center, right }

class HorizontalDateSelector extends StatefulWidget {
  final List<DateTime> dates;
  final DateTime selectedDate;
  final Function(DateTime) onSelect;

  // Month label customization
  final bool showMonthLabel;
  final MonthLabelAlignment monthLabelAlignment;
  final TextStyle? monthLabelStyle;

  // Item customization
  final double itemHeight;
  final double itemHorizontalPadding;
  final double itemSpacing;
  final double borderRadius;

  // Color customization
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;

  const HorizontalDateSelector({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onSelect,

    this.showMonthLabel = true,
    this.monthLabelAlignment = MonthLabelAlignment.left,
    this.monthLabelStyle,

    this.itemHeight = 60,
    this.itemHorizontalPadding = 13,
    this.itemSpacing = 8,
    this.borderRadius = 12,

    this.selectedColor,
    this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
  });

  @override
  State<HorizontalDateSelector> createState() => _HorizontalDateSelectorState();
}

class _HorizontalDateSelectorState extends State<HorizontalDateSelector> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  @override
  void didUpdateWidget(HorizontalDateSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _scrollToSelected();
    }
  }

  void _scrollToSelected() {
    final index = widget.dates.indexWhere(
      (d) =>
          d.day == widget.selectedDate.day &&
          d.month == widget.selectedDate.month,
    );
    if (index < 0 || !_scrollController.hasClients) return;

    final itemWidth =
        (widget.itemHorizontalPadding * 2) + 34 + widget.itemSpacing;
    final offset =
        (index * itemWidth) -
        (_scrollController.position.viewportDimension / 2) +
        (itemWidth / 2);

    _scrollController.animateTo(
      offset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final resolvedSelectedColor = widget.selectedColor ?? colorScheme.primary;
    final resolvedUnselectedColor =
        widget.unselectedColor ?? colorScheme.surface;
    final resolvedSelectedTextColor =
        widget.selectedTextColor ?? colorScheme.onPrimary;
    final resolvedUnselectedTextColor =
        widget.unselectedTextColor ?? colorScheme.onSurface;

    /// Derive month label from selectedDate
    final monthLabel = DateFormat.yMMMM().format(widget.selectedDate);

    return Column(
      crossAxisAlignment: switch (widget.monthLabelAlignment) {
        MonthLabelAlignment.left => CrossAxisAlignment.start,
        MonthLabelAlignment.center => CrossAxisAlignment.center,
        MonthLabelAlignment.right => CrossAxisAlignment.end,
      },
      children: [
        /// Month label
        if (widget.showMonthLabel) ...[
          Text(
            monthLabel,
            style:
                widget.monthLabelStyle ??
                theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
        ],

        /// Date scroll row
        SizedBox(
          height: widget.itemHeight,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.dates.length,
            separatorBuilder: (_, __) => SizedBox(width: widget.itemSpacing),
            itemBuilder: (_, index) {
              final date = widget.dates[index];
              final isSelected =
                  date.day == widget.selectedDate.day &&
                  date.month == widget.selectedDate.month;

              return GestureDetector(
                onTap: () => widget.onSelect(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.itemHorizontalPadding,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? resolvedSelectedColor
                        : resolvedUnselectedColor,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date.day.toString(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? resolvedSelectedTextColor
                              : resolvedUnselectedTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat.E().format(date),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? resolvedSelectedTextColor.withValues(
                                  alpha: 0.85,
                                )
                              : colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
