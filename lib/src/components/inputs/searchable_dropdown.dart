import 'package:flutter/material.dart';

/// A searchable dropdown that shows a modal bottom sheet with a search field
/// and a scrollable list of options.
///
/// [T] is the value type. [displayLabel] is the visible label above the field.
/// [items] is the full list of options; [itemLabel] maps each item to its
/// display string; [onChanged] fires whenever the user picks a new item.
class SearchableDropdown<T> extends StatefulWidget {
  const SearchableDropdown({
    super.key,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    required this.displayLabel,
    this.hintText,
    this.initialValue,
    this.isInputOptional = false,
    this.validator,
  });

  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final String displayLabel;
  final String? hintText;
  final T? initialValue;
  final bool isInputOptional;
  final String? Function(T?)? validator;

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  T? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  Future<void> _openPicker() async {
    final picked = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _PickerSheet<T>(
        items: widget.items,
        itemLabel: widget.itemLabel,
        selected: _selected,
      ),
    );

    if (picked != null) {
      setState(() => _selected = picked);
      widget.onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = _selected != null ? widget.itemLabel(_selected as T) : null;

    return FormField<T>(
      initialValue: _selected,
      validator: widget.validator,
      builder: (FormFieldState<T> fieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label row
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.displayLabel,
                  style:
                      Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ) ??
                      TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 8),
                if (!widget.isInputOptional)
                  Text(
                    '*',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // Tappable field
            GestureDetector(
              onTap: () async {
                await _openPicker();
                fieldState.didChange(_selected);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(90),
                  border: Border.all(
                    color: fieldState.hasError
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).dividerColor,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        label ?? widget.hintText ?? 'Select option',
                        style: TextStyle(
                          color: label != null
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
            if (fieldState.hasError)
              Padding(
                padding: EdgeInsets.only(top: 8, left: 16),
                child: Text(
                  fieldState.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Internal sheet that handles search + selection.
class _PickerSheet<T> extends StatefulWidget {
  const _PickerSheet({
    required this.items,
    required this.itemLabel,
    this.selected,
  });

  final List<T> items;
  final String Function(T) itemLabel;
  final T? selected;

  @override
  State<_PickerSheet<T>> createState() => _PickerSheetState<T>();
}

class _PickerSheetState<T> extends State<_PickerSheet<T>> {
  late List<T> _filtered;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filtered = widget.items
          .where((item) => widget.itemLabel(item).toLowerCase().contains(q))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16),

          // Search field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          SizedBox(height: 8),

          // List
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: _filtered.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No results found.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.5),
                    ),
                    itemBuilder: (_, i) {
                      final item = _filtered[i];
                      final isSelected = item == widget.selected;
                      return ListTile(
                        title: Text(
                          widget.itemLabel(item),
                          style: TextStyle(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                        onTap: () => Navigator.pop(context, item),
                      );
                    },
                  ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
