import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageScreen extends StatefulWidget {
  final String selectedLanguage;

  const LanguageScreen({Key? key, this.selectedLanguage = 'English'})
      : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final List<String> _languages = ['Arabic', 'English', 'French', 'German'];
  String _selectedLanguage = 'English';
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.selectedLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final filteredLanguages = _languages
        .where((lang) => lang.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Background Image with all visual effects
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
              color: isDarkMode ? Colors.white.withOpacity(0.2) : null,
            ),
          ),
          SafeArea(
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
                        onTap: () => Navigator.pop(context, _selectedLanguage),
                        child: const Icon(Icons.arrow_back_ios,
                            color: Color(0xFF233C7B)),
                      ),
                      Text(
                        'Language',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF233C7B),
                        ),
                      ),
                      Icon(
                        Icons.camera_alt_outlined,
                        color: const Color(0xFF233C7B),
                        size: 24,
                      ),
                    ],
                  ),
                ),
                // Search bar
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      style: GoogleFonts.poppins(fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Search Language',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey[400],
                          fontSize: 15,
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Language list
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredLanguages.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                      color: Color(0xFFE5E5E5),
                    ),
                    itemBuilder: (context, index) {
                      final lang = filteredLanguages[index];
                      return ListTile(
                        title: Text(
                          lang,
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF233C7B),
                            fontSize: 16,
                          ),
                        ),
                        trailing: _selectedLanguage == lang
                            ? Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: const Color(0xFF233C7B),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          ),
                        )
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedLanguage = lang;
                          });
                          Navigator.pop(context, lang);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
