import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../config/app_constants.dart';
import '../../models/conversation_model.dart';
import '../../providers/app_provider.dart';
import '../../services/ai_service.dart';
import '../../services/database_service.dart';

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
    final provider = Provider.of<AppProvider>(context, listen: false);

    // 유효성 검증 실패 시 API 요청 없이 종료
    if (provider.prdText.trim().isEmpty) {
      provider.setError('PRD를 입력해주세요.');
      return;
    }
    if (!provider.stackSelection.isValid) {
      provider.setError('프레임워크와 백엔드를 선택해주세요.');
      return;
    }

    provider.setError(null);
    provider.setLoading(true);
    provider.setSprintPlan(null);

    try {
      final plan = await const AiService().analyzePrd(
        prdText: provider.prdText.trim(),
        frontend: provider.stackSelection.frontend!,
        backend: provider.stackSelection.backend!,
        database: provider.stackSelection.database,
      );

      provider.setSprintPlan(plan);

      // 로그인 사용자만 대화/메시지 영속화
      if (provider.currentUser != null) {
        try {
          final dbService = DatabaseService();
          final conversation = ConversationModel(
            id: '',
            userId: provider.currentUser!.id,
            title: plan.projectTitle,
            frontendStack: provider.stackSelection.frontend!,
            backendStack: provider.stackSelection.backend!,
            databaseStack: provider.stackSelection.database,
            createdAt: DateTime.now(),
          );
          final saved = await dbService.createConversation(conversation);
          await dbService.saveMessage(
            MessageModel(
              id: '',
              conversationId: saved.id,
              role: 'user',
              content: provider.prdText.trim(),
              createdAt: DateTime.now(),
            ),
          );
          await dbService.saveMessage(
            MessageModel(
              id: '',
              conversationId: saved.id,
              role: 'assistant',
              content: jsonEncode(plan.toJson()),
              createdAt: DateTime.now(),
            ),
          );
          final updated = await dbService.fetchConversations(
            provider.currentUser!.id,
          );
          provider.setConversations(updated);
          provider.setActiveConversation(saved);
        } catch (e) {
          // AI 결과는 이미 생성되었으므로 저장 실패는 화면 표시를 막지 않음
          debugPrint('Failed to persist conversation: $e');
        }
      }
    } on AiException catch (e) {
      // 요청 실패 시 자동 재시도 금지 (쿼터 보호)
      if (context.mounted) {
        _showErrorDialog(
          context,
          title: _titleForCode(e.code),
          message: e.messageKo,
        );
      }
    } catch (_) {
      if (context.mounted) {
        _showErrorDialog(
          context,
          title: AppStrings.serverErrorTitle,
          message: AppStrings.serverErrorMessage,
        );
      }
    } finally {
      provider.setLoading(false);
    }
  }

  String _titleForCode(String code) {
    switch (code) {
      case 'RATE_LIMITED':
        return AppStrings.rateLimitedTitle;
      case 'DAILY_LIMIT':
        return AppStrings.dailyLimitTitle;
      default:
        return AppStrings.serverErrorTitle;
    }
  }

  void _showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.error,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            height: 1.6,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
  }
}
