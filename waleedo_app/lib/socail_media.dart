import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants/colors.dart';
import 'constants/fonts.dart';
import 'Design System/AppBar/primary_appbar.dart';

class SocailMedia extends StatelessWidget {
  const SocailMedia({super.key});

  static const String _instagramUrl = 'https://instagram.com/your_page';
  static const String _facebookUrl = 'https://facebook.com/your_page';
  static const String _whatsappUrl = 'https://wa.me/+967770411921';
  static const String _tiktokUrl = 'https://tiktok.com/@48wa_r';

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Widget _socialCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFF1E1E22),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: color.dark2,
          ),
          // padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  // color: const Color(0xFF2A2A30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFFF1D25),
                  size: 32,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: fonts.mb.copyWith(color: color.white)
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.dark1,

      appBar: p_appbar(
        title: "مواقع التواصل",
        centerTheTitles: true,
      ),
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                const SizedBox(height: 12),

                // الشعار
                Center(
                  child: Image.asset(
                    'assets/images/MainLogo.png',
                    width: MediaQuery.of(context).size.width * 0.40,
                    height: MediaQuery.of(context).size.height * 0.25,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'حساباتنا الرسمية\nعلى مواقع التواصل',
                  textAlign: TextAlign.center,
                  style: fonts.h5.copyWith(color: color.white)
                ),
                const SizedBox(height: 28),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.7,
                  children: [
                    _socialCard(
                      context: context,
                      title: 'انستجرام',
                      icon: Icons.camera_alt_outlined,
                      onTap: () => _openLink(_instagramUrl),
                    ),
                    _socialCard(
                      context: context,
                      title: 'فيسبوك',
                      icon: Icons.facebook,
                      onTap: () => _openLink(_facebookUrl),
                    ),
                    _socialCard(
                      context: context,
                      title: 'واتساب',
                      icon: Icons.chat_bubble_outline,
                      onTap: () => _openLink(_whatsappUrl),
                    ),
                    _socialCard(
                      context: context,
                      title: 'تيك توك',
                      icon: Icons.music_note,
                      onTap: () => _openLink(_tiktokUrl),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
