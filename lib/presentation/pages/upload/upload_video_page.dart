import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/providers/repository_providers.dart';
import '../../widgets/atoms/primary_button.dart';
import '../../widgets/atoms/custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UploadVideoPage extends ConsumerStatefulWidget {
  const UploadVideoPage({super.key});

  @override
  ConsumerState<UploadVideoPage> createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends ConsumerState<UploadVideoPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _gameController = TextEditingController();
  String? _videoPath;
  bool _compressVideo = false;
  bool _isUploading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _gameController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _videoPath = video.path;
      });
    }
  }

  Future<void> _uploadVideo() async {
    if (!_formKey.currentState!.validate() || _videoPath == null) {
      return;
    }

    setState(() => _isUploading = true);

    try {
      final repository = ref.read(videoRepositoryProvider);
      await repository.uploadVideo(
        filePath: _videoPath!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        game: _gameController.text.trim().isEmpty
            ? null
            : _gameController.text.trim(),
        compress: _compressVideo,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vídeo enviado com sucesso!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.uploadVideo),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_videoPath != null)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.videocam, color: Colors.white, size: 48),
                  ),
                )
              else
                PrimaryButton(
                  text: l10n.selectVideo,
                  onPressed: _pickVideo,
                ),
              const SizedBox(height: 16),
              CustomTextField(
                label: l10n.videoTitle,
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: l10n.videoDescription,
                controller: _descriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: l10n.gameName,
                controller: _gameController,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: Text(l10n.compressVideo),
                value: _compressVideo,
                onChanged: (value) {
                  setState(() {
                    _compressVideo = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: l10n.upload,
                onPressed: _isUploading ? null : _uploadVideo,
                isLoading: _isUploading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

