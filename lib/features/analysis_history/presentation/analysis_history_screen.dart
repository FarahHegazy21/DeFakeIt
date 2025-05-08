import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/logic/auth_bloc.dart';
import '../../auth/logic/auth_event.dart';
import '../../auth/logic/auth_state.dart';
import 'audio_analysis_screen.dart';

class AnalysisHistoryScreen extends StatelessWidget {
  const AnalysisHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(GetHistoryRequested());

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HistoryLoaded) {
              final recent7Days = state.history.where((item) {
                final date = DateTime.parse(item['upload_date']);
                return DateTime.now().difference(date).inDays <= 7;
              }).toList();

              final previous30Days = state.history.where((item) {
                final date = DateTime.parse(item['upload_date']);
                return DateTime.now().difference(date).inDays > 7 &&
                    DateTime.now().difference(date).inDays <= 30;
              }).toList();

              return ListView(
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
                  SectionList(title: "Previous 30 days", audios: previous30Days),
                ],
              );
            } else if (state is HistoryError) {
              return Center(child: Text("Error: ${state.message}"));
            } else {
              return const Center(child: Text("No data available"));
            }
          },
        ),
      ),
    );
  }
}

class SectionList extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> audios;

  const SectionList({super.key, required this.title, required this.audios});

  @override
  Widget build(BuildContext context) {
    if (audios.isEmpty) {
      return Text("No audios in $title");
    }

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
  final Map<String, dynamic> audio;

  const AudioListItem({super.key, required this.audio});

  @override
  Widget build(BuildContext context) {
    // استخراج البيانات من الـ audio
    String audioName = audio['audio_name'] ?? 'Unknown';
    String uploadDate = audio['upload_date'] ?? '';
    String notes = audio['notes'] ?? 'No notes available';
    String format = audio['format'] ?? 'Unknown format';
    double confidence = audio['confidence'] ?? 0.0;
    double size = audio['size'] ?? 0.0;
    bool isFake = audio['is_fake'] ?? false;

    return InkWell(
      onTap: () {
        // الانتقال لصفحة AudioAnalysisScreen وتمرير البيانات
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AudioAnalysisScreen(
              audioName: audioName,
              isFake: isFake,
              confidence: confidence,
              uploadDate: uploadDate,
              notes: notes,
              format: format,
              size: size,
            ),
          ),
        );
      },
      child: ListTile(
        leading: const Icon(Icons.mic),
        title: Text(audioName),
        subtitle: Text(uploadDate),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isFake ? 'Fake' : 'Real',
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