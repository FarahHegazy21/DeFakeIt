import 'dart:io';
import 'package:defakeit/features/home/logic/home_bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class RecordAudioScreen extends StatefulWidget {
  const RecordAudioScreen({super.key});

  @override
  State<RecordAudioScreen> createState() => _RecordAudioScreenState();
}

class _RecordAudioScreenState extends State<RecordAudioScreen> {
  final record = AudioRecorder();
  bool isRecording = false;
  String? recordedFilePath;
  bool isRecorded = false;

  Future<void> _startRecording() async {
    final hasPermission = await _checkPermissions();
    if (!hasPermission) return;

    final dir = await getApplicationDocumentsDirectory();
    final path =
        '${dir.path}/recorded_audio_${DateTime.now().millisecondsSinceEpoch}.wav';

    await record.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: path,
    );

    setState(() {
      isRecording = true;
      recordedFilePath = path;
      isRecorded = false;
    });
  }

  Future<void> _stopRecording() async {
    await record.stop();
    setState(() {
      isRecording = false;
      isRecorded = true;
    });
  }

  Future<bool> _checkPermissions() async {
    final micStatus = await Permission.microphone.request();
    return micStatus.isGranted;
  }

  void _deleteAudio() {
    setState(() {
      recordedFilePath = null;
      isRecording = false;
      isRecorded = false; // نرجع لحالة البداية
    });
    context.read<HomeBloc>().add(ClearPickedAudio());
  }

  @override
  Widget build(BuildContext context) {
    final fileReady = recordedFilePath != null && isRecorded;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Record Audio"),
        backgroundColor: Colors.transparent,
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is AnalyzingState) {
            Navigator.pushNamed(context, '/loading');
          } else if (state is AnalysisResultState) {
            Navigator.pushReplacementNamed(
              context,
              '/detectionResult',
              arguments: {
                'isFake': state.isFake,
                'confidence': state.confidence,
              },
            );
          } else if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isRecorded)
                Icon(
                  isRecording ? Icons.mic : Icons.mic_none,
                  size: 100,
                  color: isRecording ? Colors.red : Colors.grey,
                ),
              const SizedBox(height: 20),
              if (!isRecorded)
                ElevatedButton(
                  onPressed: isRecording ? _stopRecording : _startRecording,
                  child:
                      Text(isRecording ? 'Stop Recording' : 'Start Recording'),
                ),
              if (isRecorded)
                Column(
                  children: [
                    Center(
                      child: Text(
                        "Audio recorded successfully ✅",
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.analytics),
                          label: const Text("Analyze Audio"),
                          onPressed: () {
                            context.read<HomeBloc>().add(
                                  StartAnalysis(File(recordedFilePath!)),
                                );
                          },
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.delete),
                          label: const Text("Delete"),
                          onPressed: _deleteAudio,
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
