import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? label;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final IconData? icon;
  final bool enabled;
  final bool? readOnly;
  final int? maxLines;
  final int? maxLength;
  final int? minLength;
  final VoidCallback? onTap;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final bool isInputOptional;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final TextStyle? labelStyle;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? hintStyle;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final BorderRadius? borderRadius;

  const AppTextInput({
    super.key,
    this.controller,
    this.labelText,
    this.label,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.icon,
    this.readOnly,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.minLength,
    this.textInputAction = TextInputAction.done,
    this.focusNode,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.isInputOptional = true,
    this.textCapitalization = TextCapitalization.sentences,
    this.fillColor,
    this.labelStyle,
    this.inputFormatters,
    this.hintStyle,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.borderRadius,
  });

  @override
  State<AppTextInput> createState() => _AppTextInputState();
}

class _AppTextInputState extends State<AppTextInput> {
  late FocusNode _internalFocusNode;
  TextEditingController? _internalController;
  bool _isFocused = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _internalFocusNode.addListener(_onFocusChange);
    if (widget.controller == null) {
      _internalController = TextEditingController();
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    } else {
      _internalFocusNode.removeListener(_onFocusChange);
    }
    _internalController?.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _internalFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textController = widget.controller ?? _internalController!;
    final displayLabel = widget.labelText ?? widget.label;

    // Combine minLength validation with existing validator if provided
    String? Function(String?)? combinedValidator = widget.validator;
    if (widget.minLength != null) {
      final minLengthValue = widget.minLength!;
      final existingValidator = widget.validator;
      combinedValidator = (String? value) {
        String? error;
        if (value != null &&
            value.isNotEmpty &&
            value.length < minLengthValue) {
          error = 'Minimum length is $minLengthValue characters';
        } else if (existingValidator != null) {
          error = existingValidator(value);
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _errorText = error);
        });
        return error;
      };
    } else if (widget.validator != null) {
      // Handle case where there's a validator but no minLength
      final existingValidator = widget.validator!;
      combinedValidator = (String? value) {
        final error = existingValidator(value);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _errorText = error);
        });
        return error;
      };
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (displayLabel != null) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                displayLabel.toString(),
                style:
                    widget.labelStyle ??
                    Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 14.sp,
                    ) ??
                    TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8.0),
              if (widget.isInputOptional == false)
                Text(
                  '*',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10.0),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(90.0),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: const Color(0x405EA3D6), // #5EA3D640
                      blurRadius: 0,
                      spreadRadius: 4,
                      offset: const Offset(0, 0),
                    ),
                  ]
                : [],
          ),
          child: TextFormField(
            controller: textController,
            readOnly: widget.readOnly ?? false,
            validator: combinedValidator,
            onFieldSubmitted: widget.onSubmitted,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: widget.hintText,
              errorText: null,
              errorStyle: const TextStyle(fontSize: 0, height: 0),
              prefixIcon:
                  widget.prefixIcon ??
                  (widget.icon != null ? Icon(widget.icon) : null),
              suffixIcon: widget.suffixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: widget.suffixIcon,
                    )
                  : null,
              hintStyle:
                  widget.hintStyle ??
                  Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    fontSize: 14.sp,
                  ),
              // errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              // color: AppColors.error,
              // fontSize: 12.sp,
              // ),
              errorMaxLines: 2,
              border:
                  widget.border ??
                  OutlineInputBorder(
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(90.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
              enabledBorder:
                  widget.enabledBorder ??
                  OutlineInputBorder(
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(90.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
              focusedBorder:
                  widget.focusedBorder ??
                  OutlineInputBorder(
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(90.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
              errorBorder:
                  widget.errorBorder ??
                  OutlineInputBorder(
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(90.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                      width: 1,
                    ),
                  ),
              focusedErrorBorder:
                  widget.focusedErrorBorder ??
                  OutlineInputBorder(
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(90.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                      width: 1.5,
                    ),
                  ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              fillColor: widget.fillColor ?? Colors.white,
              filled: true,
            ),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
            obscureText: widget.obscureText,
            keyboardType: widget.maxLines! > 1
                ? TextInputType.multiline
                : widget.keyboardType,
            onChanged: widget.onChanged,
            enabled: widget.enabled,
            onTap: widget.onTap,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            textInputAction: widget.maxLines! > 1
                ? TextInputAction.newline
                : widget.textInputAction,
            focusNode: _internalFocusNode,
            onEditingComplete: widget.onEditingComplete,
            textCapitalization: widget.textCapitalization,
            inputFormatters: widget.inputFormatters,
          ),
        ),
        if (_errorText != null || widget.errorText != null) ...[
          // const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              _errorText ?? widget.errorText!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ],
    );
  }
}
