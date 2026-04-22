import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';

class p_snackbar {
  static void show({
    required BuildContext context,
    required String title,

    Color background = color.success,
    Color colort = color.g200,
    TextStyle fontType = fonts.mb,

    Duration timer = const Duration(seconds: 3),

    double? width = double.infinity,
    EdgeInsets? margin,

    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),

    bool showIcon = true,
    IconData icon = Icons.check_circle,
    double iconSize = 22,
    Color? iconColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: width,
        margin: margin,
        padding: EdgeInsets.zero,
        elevation: 0,
        duration: timer,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,

        content: Container(
          width: double.infinity,
          padding: padding,
          color: background,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: fontType.copyWith(
                    color: colort,
                  ),
                ),
              ),

              if (showIcon) ...[
                const SizedBox(width: 10),
                Icon(
                  icon,
                  size: iconSize,
                  color: iconColor ?? colort,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}