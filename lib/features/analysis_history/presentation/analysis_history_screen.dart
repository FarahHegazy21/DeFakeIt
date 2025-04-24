import 'package:flutter/material.dart';

import 'audio_analysis_screen.dart';

class AnalysisHistoryScreen extends StatelessWidget {
  const AnalysisHistoryScreen({super.key});

  final List<Map<String, String>> recent7Days = const [
    {'name': 'Audio 5', 'status': 'Fake', 'date': '02/10/2024'},
    {'name': 'Audio 6', 'status': 'Fake', 'date': '02/10/2024'},
  ];

  final List<Map<String, String>> previous30Days = const [
    {'name': 'Audio 1', 'status': 'Real', 'date': '02/10/2024'},
    {'name': 'Audio 5', 'status': 'Fake', 'date': '02/10/2024'},
    {'name': 'Audio 2', 'status': 'Fake', 'date': '02/10/2024'},
    {'name': 'Audio 3', 'status': 'Real', 'date': '02/10/2024'},
    {'name': 'Audio 4', 'status': 'Real', 'date': '02/10/2024'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Analysis History",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SectionList(title: "Previous 7 days", audios: recent7Days),
                  const SizedBox(height: 20),
                  SectionList(
                      title: "Previous 30 days", audios: previous30Days),
                ],
              ),
            ),
    );
  }
}

class SectionList extends StatelessWidget {
  final String title;
  final List<Map<String, String>> audios;

  const SectionList({super.key, required this.title, required this.audios});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text("Delete All")),
          ],
        ),
        ...audios.map((audio) => AudioListItem(audio: audio)).toList(),
      ],
    );
  }
}

class AudioListItem extends StatelessWidget {
  final Map<String, String> audio;

  const AudioListItem({super.key, required this.audio});

  @override
  Widget build(BuildContext context) {
    bool isFake = audio['status'] == 'Fake';
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Audio2Screen()
        ));
      },
      child: ListTile(
          leading: const Icon(Icons.mic),
          title: Text(audio['name']!),
          subtitle: Text(audio['date']!),
          trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  audio['status']!,
                  style: TextStyle(
                    color: isFake ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.delete_outline, color: Colors.grey),
              ],
             ),
         ),
    );
    }
}