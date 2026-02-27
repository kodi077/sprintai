import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../config/app_constants.dart';
import '../../providers/app_provider.dart';

class PrdInputWidget extends StatefulWidget {
  const PrdInputWidget({super.key});

  @override
  State<PrdInputWidget> createState() => _PrdInputWidgetState();
}

class _PrdInputWidgetState extends State<PrdInputWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _controller,
            maxLines: 10,
            minLines: 6,
            onChanged: (val) => provider.setPrdText(val),
            decoration: const InputDecoration(
              hintText: AppStrings.prdInputHint,
              hintStyle: TextStyle(color: AppColors.textSecondary),
            ),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton.icon(
                icon: const Icon(
                  Icons.upload_file,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
                label: const Text(
                  AppStrings.uploadFile,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                onPressed: () => _pickFile(context),
              ),
              ElevatedButton(
                onPressed: provider.isLoading ? null : () => _onSubmit(context),
                child: provider.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(AppStrings.analyzeButton),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile(BuildContext context) async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['txt'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) {
      return;
    }

    final bytes = result.files.single.bytes;
    if (bytes == null) {
      return;
    }

    final text = utf8.decode(bytes);
    _controller.text = text;
    provider.setPrdText(text);
  }

  Future<void> _onSubmit(BuildContext context) async {
    // TODO: will be implemented in the AI service step
  }
}
