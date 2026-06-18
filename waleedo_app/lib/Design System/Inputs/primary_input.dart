import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';

class p_input extends StatefulWidget {
  final double? width;
  final double? height;

  final String? Function(String?)? validator;
  final int icon;
  final bool isRight;
  final bool hidden;

  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;

  final TextStyle style;
  final Color background;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color textColor;

  final String label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final Function(String)? onFieldSubmitted;
  final bool readOnly;

  const p_input({
    super.key,
    this.width,
    this.height,
    this.validator,
    this.icon = 1,
    this.isRight = true,
    this.hidden = false,
    required this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.focusNode,
    this.style = fonts.mb,
    this.background = color.dark2,
    this.borderColor = color.g500,
    this.focusedBorderColor = color.p600,
    this.textColor = color.g400,
    required this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.readOnly = false,
  });

  @override
  State<p_input> createState() => _p_inputState();
}

class _p_inputState extends State<p_input> {
  late bool ishidden;
  @override
  void initState() {
    super.initState();
    ishidden = widget.hidden;
  }
  @override
  Widget build(BuildContext context) {
    final bool textRight = widget.icon == 2 ? false : widget.isRight;
    
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          validator: widget.validator,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          onEditingComplete: widget.onEditingComplete,
          onFieldSubmitted: widget.onFieldSubmitted,
          readOnly: widget.readOnly,
          textAlign: textRight ? TextAlign.right : TextAlign.left,
          textDirection: textRight ? TextDirection.rtl : TextDirection.ltr,
          obscureText: ishidden,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          cursorColor: widget.textColor,
          inputFormatters: widget.inputFormatters,
          style: widget.style.copyWith(color: widget.textColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.background,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(48),
              borderSide: BorderSide(
                color: widget.focusedBorderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: widget.borderColor,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(48),
              borderSide: BorderSide(
                color: widget.borderColor,
              ),
            ),
            labelText: widget.label,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            alignLabelWithHint: true,
            labelStyle: fonts.sb.copyWith(
              color: widget.textColor,
            ),
            floatingLabelStyle: fonts.sb.copyWith(
              color: widget.focusedBorderColor,
            ),
            prefixIcon: (widget.icon == 1 || widget.icon == 3)
                ? widget.prefixIcon
                : null,
            prefixIconColor: (widget.icon == 1 || widget.icon == 3)
                ? WidgetStateColor.resolveWith((states) {
                    if (states.contains(WidgetState.focused)) {
                      return widget.focusedBorderColor;
                    }
                    return widget.textColor;
                  })
                : null,

            suffixIcon: (widget.icon == 3)
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        ishidden = !ishidden;
                      });
                    },
                    icon: (Icon(ishidden
                        ? Icons.visibility_off
                        : Icons.visibility)))
                : (widget.icon == 2)
                    ? widget.suffixIcon
                    : null,
            suffixIconColor: (widget.icon == 2 || widget.icon == 3)
                ? WidgetStateColor.resolveWith((states) {
                    if (states.contains(WidgetState.focused)) {
                      return widget.focusedBorderColor;
                    }
                    return widget.textColor;
                  })
                : null,
          ),
        ),
      ),
    );
  }
}
