import 'dart:io';
import 'package:defakeit/features/home/logic/home_bloc/home_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadAudioScreen extends StatelessWidget {
  const UploadAudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Audio'),
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
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is AudioPickedState) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.audiotrack, size: 80, color: Colors.green),
                    const SizedBox(height: 12),
                    Text('Picked: ${state.fileName}'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(
                              StartAnalysis(state.audioFile),
                            );
                      },
                      child: const Text('Analyze Audio'),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Delete Audio'),
                      onPressed: () {
                        context.read<HomeBloc>().add(ClearPickedAudio());
                      },
                    ),
                  ],
                ),
              );
            }

            if (state is ErrorState) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            return Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text('Pick Audio File'),
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['mp3', 'wav'],
                  );

                  if (result != null && result.files.single.path != null) {
                    final file = File(result.files.single.path!);
                    final fileName = result.files.single.name;
                    context.read<HomeBloc>().add(AudioPicked(file, fileName));
                  } else {
                    context
                        .read<HomeBloc>()
                        .add(const AnalysisFailed('No file selected.'));
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
