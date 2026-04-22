import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';

class p_button extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final double width;
  final double? height;
  final BorderRadius borderRadius;
  final Color background;
  final Color colort;
  final TextStyle fontType;
  final bool isLoading;
  final Widget? loadingWidget;

  final bool showRightIcon;
  final bool showLeftIcon;

  final IconData rightIcon;
  final IconData leftIcon;

  final double iconSize;
  final Color? iconColor;

  const p_button({
    super.key,
    required this.title,
    required this.onPressed,
    this.width = double.infinity,
    this.height,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(16),
    ),
    this.background = color.p500,
    this.colort = color.g200,
    this.fontType = fonts.xlb,
    this.isLoading = false,
    this.loadingWidget,
    this.showRightIcon = false,
    this.showLeftIcon = false,
    this.rightIcon = Icons.flash_on,
    this.leftIcon = Icons.person_add,
    this.iconSize = 22,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: MaterialButton(
        color: background,
        disabledColor: background,
        elevation: 0,
        highlightElevation: 0,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),

        // ✅ لا نخليه null
        onPressed: () {
          if (!isLoading && onPressed != null) {
            onPressed!();
          }
        },

        child: isLoading
            ? loadingWidget ??
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(colort),
                  ),
                )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showLeftIcon) ...[
                    Icon(
                      leftIcon,
                      size: iconSize,
                      color: iconColor ?? colort,
                    ),
                    const SizedBox(width: 8),
                  ],

                  Text(
                    title,
                    style: fontType.copyWith(color: colort),
                  ),

                  if (showRightIcon) ...[
                    const SizedBox(width: 8),
                    Icon(
                      rightIcon,
                      size: iconSize,
                      color: iconColor ?? colort,
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}


