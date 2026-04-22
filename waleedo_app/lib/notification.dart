import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/AppBar/primary_appbar.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.dark1,
      appBar: p_appbar(
        title: "الاشعارات",
        centerTheTitles: true,
        showLeading: true,
        showbtn2: false,
        btn1icon: Icons.refresh,
        btn1_Onprss: () {},
        showLeadingBorder: false,
      ),

      // BODY
      body: SingleChildScrollView(
        child: Column(
          children: [
            notificationCard(),
            notificationCard(),
            notificationCard(),
            notificationCard(),
          ],
        ),
      ),
    );
  }

  Widget notificationCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: const EdgeInsets.only(left: 8,right: 8,bottom: 4),
      decoration: BoxDecoration(
        color: color.dark2,
        borderRadius: BorderRadius.circular(28),
      ),

      // ROW
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // LEFT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                // NEW BADGE
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.p,
                      borderRadius: BorderRadius.circular(48),
                    ),
                    child: Text(
                      "New",
                      style: fonts.xsb.copyWith(
                        color: color.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // MAIN TITLE
                Container(
                  width: double.infinity,
                  child: Text(
                    "كل عام وانتم بخير.. معنا العيد افضل كل عام وانتم بخير.. معنا العيد افضل",
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    softWrap: true,
                    style: fonts.lb.copyWith(
                      color: color.g200,   
                      height: 1.2,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // SUB TITLE
                Container(
                  width: double.infinity,
                  child: Text(
                    "نستأنف دوامنا الى 2 العيد الموافق السبت نستأنف دوامنا الى 2 العيد الموافق السبت",
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    softWrap: true,
                    style: fonts.ss.copyWith(
                      color: color.g300,
                      height: 1.2
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // DATE
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "19-3-2026 19:30:11",
                    style: fonts.xss.copyWith(
                      color: color.g400,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // RIGHT ICON
          Container(
            alignment: Alignment.center,
            child: Icon(
              Icons.notifications_outlined,
              color: color.p,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}