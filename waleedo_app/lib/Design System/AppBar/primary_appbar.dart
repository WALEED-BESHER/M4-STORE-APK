import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';

class p_appbar extends StatelessWidget implements PreferredSizeWidget {
  final Color background;
  final double elevation;

  // leading
  final bool showLeading;
  final bool showbtn1;
  final bool showbtn2;

  final IconData btn1icon;
  final IconData btn2icon;

  final Color? btnbg;
  final Color iconcolor;
  final bool showLeadingBorder;

  final VoidCallback? btn1_Onprss;
  final VoidCallback? btn2_Onprss;

  // title
  final String title;
  final TextStyle titleStyle;
  final Color titleColor;
  final bool centerTheTitles;

  // action
  final bool showAction;
  final IconData btn3icon;
 

  p_appbar({
    super.key,
    this.background = color.dark2,
    this.elevation = 0,

    // leading
    this.showLeading = false,
    this.showbtn1 = true,
    this.showbtn2 = true,
    this.btn1icon = Icons.tune,
    this.btn2icon = Icons.search,
    this.btnbg,
    this.iconcolor = color.g400,
    this.showLeadingBorder = true,
    this.btn1_Onprss,
    this.btn2_Onprss,

    // title
    required this.title,
    this.titleStyle = fonts.xlb,
    this.titleColor = color.white,
    this.centerTheTitles = false,

    // action
    this.showAction = true,
    this.btn3icon = Icons.arrow_forward,
    
  });

  double get leadingWidth {
    if (!showLeading) return 0;

    int count = 0;
    if (showbtn1) count++;
    if (showbtn2) count++;

    if (count == 2) return 96;
    if (count == 1) return 52;

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    VoidCallback btn2 = btn2_Onprss ?? (){Navigator.of(context).pushNamed("search");};
    return AppBar(
      backgroundColor: background, //dark2
      elevation: elevation,
      leadingWidth: leadingWidth, //96

      leading: showLeading
          ? SizedBox.expand(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                
                if (showbtn1)
                  IconButton(
                    onPressed: btn1_Onprss,
                    splashRadius: 24,
                    enableFeedback: true,
                    constraints: const BoxConstraints(
                      minHeight: 40,
                      minWidth: 40,
                    ),
                    icon: Icon(btn1icon),
                    style: ButtonStyle(
                      backgroundColor: showLeadingBorder ? MaterialStateProperty.all(btnbg ?? color.f_secondary) : null,
                      foregroundColor: MaterialStateProperty.all(iconcolor),
                      overlayColor: showLeadingBorder ? MaterialStateProperty.resolveWith<Color?>(
                        (states) {
                          if (states.contains(MaterialState.pressed)) {
                            return color.b_activered; // لون عند الضغط
                          }
                          if (states.contains(MaterialState.hovered)) {
                            return color.b_hoverdred;
                          }
                          return null; // يرجع طبيعي
                        },
                      ) : 
                      MaterialStateProperty.resolveWith<Color?>(
                        (states) {
                          if (states.contains(MaterialState.pressed)) {
                            return color.b_activegrey; // لون عند الضغط
                          }
                          if (states.contains(MaterialState.hovered)) {
                            return color.b_hovergrey;
                          }
                          return null; // يرجع طبيعي
                        },
                      ),
                      padding: MaterialStateProperty.all(EdgeInsets.all(5)),
                      shape: showLeadingBorder ? MaterialStateProperty.all(
                          RoundedRectangleBorder(//
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: btnbg ?? color.f_primary,
                              width: 2
                            ),
                          ),
                        ) : 
                        MaterialStateProperty.all(
                          RoundedRectangleBorder(//
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.transparent,
                              width: 2
                            ),
                          ),
                        ),
                    ),
                  ),
                if (showbtn2)
                  IconButton(
                    onPressed: btn2,
                    splashRadius: 24,
                    enableFeedback: true,
                    constraints: const BoxConstraints(
                      minHeight: 40,
                      minWidth: 40,
                    ),
                    icon: Icon(btn2icon),
                    style: ButtonStyle(
                      backgroundColor: showLeadingBorder ? MaterialStateProperty.all(btnbg ?? color.f_secondary) : null,
                      foregroundColor: MaterialStateProperty.all(iconcolor),
                      overlayColor:  showLeadingBorder ? MaterialStateProperty.resolveWith<Color?>(
                        (states) {
                          if (states.contains(MaterialState.pressed)) {
                            return color.b_activered; // لون عند الضغط
                          }
                          if (states.contains(MaterialState.hovered)) {
                            return color.b_hoverdred;
                          }
                          return null; // يرجع طبيعي
                        },
                      ) : 
                      MaterialStateProperty.resolveWith<Color?>(
                        (states) {
                          if (states.contains(MaterialState.pressed)) {
                            return color.b_activegrey; // لون عند الضغط
                          }
                          if (states.contains(MaterialState.hovered)) {
                            return color.b_hovergrey;
                          }
                          return null; // يرجع طبيعي
                        },
                      ),
                      padding: MaterialStateProperty.all(EdgeInsets.all(5)),
                      shape: showLeadingBorder ? MaterialStateProperty.all(
                          RoundedRectangleBorder(//
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: btnbg ?? color.f_primary,
                              width: 2
                            ),
                          ),
                        ) : 
                        MaterialStateProperty.all(
                          RoundedRectangleBorder(//
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.transparent,
                              width: 2
                            ),
                          ),
                        ),
                    ),
                  ),
              ],
            ),
          )
          : null,

      centerTitle: centerTheTitles ? true : null,
      titleSpacing: centerTheTitles ? null : 0,
      title: centerTheTitles ? Text(
        title,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: titleStyle.copyWith(color: titleColor),
      ) : SizedBox(
        width: double.infinity,
        child: Text(
          title,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: titleStyle.copyWith(color: titleColor),
        ),
      ),

      actions: [
        if (showAction)
          IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(btn3icon),
            style: ButtonStyle(
              foregroundColor:MaterialStateProperty.all(iconcolor),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
