import 'package:defakeit/features/settings/presentation/language.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreen1State();
}

class _SettingsScreen1State extends State<SettingsScreen> {
  bool _lightMode = true;
  int _selectedIndex = 3;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(Icons.arrow_back_ios,
                            color: Color(0xFF233C7B)),
                      ),
                      Text(
                        'Settings',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF233C7B),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          'assets/images/logout_icon.png',
                          width: 26,
                          height: 26,
                          color: const Color(0xFF233C7B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // General Section
                _sectionLabel('General'),
                _settingsItem(
                  title: 'Language',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedLanguage,
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right,
                          color: Colors.grey, size: 20),
                    ],
                  ),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LanguageScreen(
                            selectedLanguage: _selectedLanguage),
                      ),
                    );
                    if (result != null && result is String) {
                      setState(() {
                        _selectedLanguage = result;
                      });
                    }
                  },
                ),
                _divider(),
                _settingsItem(
                  title: 'Light Mode',
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/sun_icon.png',
                          width: 22, height: 22),
                      const SizedBox(width: 6),
                    ],
                  ),
                  trailing: Switch(
                    value: _lightMode,
                    activeColor: const Color(0xFF233C7B),
                    inactiveThumbColor: Colors.grey,
                    onChanged: (value) {
                      setState(() {
                        _lightMode = value;
                      });
                    },
                  ),
                  onTap: () {},
                ),
                _divider(),
                _settingsItem(
                  title: 'Contact Us',
                  trailing: const Icon(Icons.chevron_right,
                      color: Colors.grey, size: 20),
                  onTap: () {},
                ),
                const SizedBox(height: 26),
                // Security Section
                _sectionLabel('Security'),
                _settingsItem(
                  title: 'Change Password',
                  trailing: const Icon(Icons.chevron_right,
                      color: Colors.grey, size: 20),
                  onTap: () {},
                ),
                _divider(),
                _settingsItem(
                  title: 'Privacy Policy',
                  trailing: const Icon(Icons.chevron_right,
                      color: Colors.grey, size: 20),
                  onTap: _showPrivacyPolicy,
                ),
              ],
            ),
          );

  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 8, top: 18),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: Colors.grey[500],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _settingsItem({
    required String title,
    Widget? leading,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            if (leading != null) leading,
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color(0xFF233C7B),
              ),
            ),
            const Spacer(),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 20,
      endIndent: 20,
      color: Color(0xFFE5E5E5),
    );
  }

  Widget _bottomNavBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FC),
        borderRadius: BorderRadius.circular(24),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF233C7B),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/home_icon.png',
                width: 24,
                height: 24,
                color: _selectedIndex == 0
                    ? const Color(0xFF233C7B)
                    : Colors.grey),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            label: 'Analysis History',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Policy', style: GoogleFonts.poppins()),
        content: SingleChildScrollView(
          child: Text(
            'DefakeIt respects and protects your privacy. Our application is designed to help identify potentially manipulated audio content while maintaining strict data protection standards.\n\n'
                'When you use our app, the audio files you submit for analysis are processed with state-of-the-art technology to determine authenticity. These files are only stored temporarily for processing and are automatically deleted afterward.\n\n'
                'We collect minimal usage data to improve our service, but this information is anonymized and never linked to your personal identity. We do not share your data with third parties except when required by law.\n\n'
                'By using DefakeIt, you consent to this privacy policy. If you have questions or concerns, please contact our support team.',
            style: GoogleFonts.poppins(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close',
                style: GoogleFonts.poppins(color: const Color(0xFF233C7B))),
          ),
        ],
      ),
    );
  }
}
