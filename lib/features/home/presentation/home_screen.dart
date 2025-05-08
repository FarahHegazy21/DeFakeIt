import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'upload_audio_screen.dart';
import 'record_audio_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = "User"; // Default value
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    try {
      final username = await _storage.read(key: 'username');
      if (username != null && username.isNotEmpty) {
        setState(() {
          _username = username;
        });
      }
    } catch (e) {
      print("Error loading username: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, $_username",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 140,
                    ),
                    Text(
                      "Ready to check\naudio authenticity?",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UploadAudioScreen()),
                            );
                          },
                          icon: const Icon(
                            Icons.file_upload,
                            color: Color(0xFFA4A3A3),
                          ),
                          label: const Text("Upload File"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF4F4F4),
                            foregroundColor: const Color(0xFFA4A3A3),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RecordAudioScreen()),
                            );
                          },
                          icon: const Icon(
                            Icons.mic,
                            color: Color(0xFFA4A3A3),
                          ),
                          label: const Text("Record"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF4F4F4),
                            foregroundColor: const Color(0xFFA4A3A3),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 26, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
