import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

import '../config/app_constants.dart';
import '../models/app_error.dart';
import '../models/conversation_model.dart';
import '../models/sprint_plan_model.dart';
import '../models/stack_model.dart';
import '../services/ai_service.dart';
import '../services/export_service.dart';

class AppState extends ChangeNotifier {
  AppState({AiService? aiService, ExportService? exportService})
    : _aiService = aiService ?? const AiService(),
      _exportService = exportService ?? const ExportService() {
    _loadPersistedConversations();
  }

  final AiService _aiService;
  final ExportService _exportService;

  final List<Conversation> _conversations = <Conversation>[];

  StackSelection _stack = StackSelection.empty();
  String _prdText = '';
  SprintPlan? _currentPlan;
  String? _selectedConversationId;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String _userLabel = AppStrings.guestUser;

  List<Conversation> get conversations =>
      List<Conversation>.unmodifiable(_conversations);
  StackSelection get stack => _stack;
  String get prdText => _prdText;
  SprintPlan? get currentPlan => _currentPlan;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String get userLabel => _userLabel;
  String? get selectedConversationId => _selectedConversationId;

  void setFrontend(String? value) {
    _stack = _stack.copyWith(frontend: value);
    notifyListeners();
  }

  void setBackend(String? value) {
    _stack = _stack.copyWith(backend: value);
    notifyListeners();
  }

  void setDatabase(String? value) {
    if (value == null || value.trim().isEmpty) {
      _stack = _stack.copyWith(clearDatabase: true);
    } else {
      _stack = _stack.copyWith(database: value);
    }
    notifyListeners();
  }

  void setPrdText(String value) {
    _prdText = value;
    notifyListeners();
  }

  Future<void> pickPrdFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['txt'],
      withData: true,
    );

    final file = result?.files.single;
    if (file?.bytes == null) {
      return;
    }

    _prdText = utf8.decode(file!.bytes!);
    notifyListeners();
  }

  Future<void> analyze() async {
    if (_isLoading) {
      return;
    }

    if (!_stack.isValid) {
      throw const AppError(
        code: ErrorCode.badRequest,
        message: 'Stack selection is required.',
      );
    }

    if (_prdText.trim().isEmpty) {
      throw const AppError(
        code: ErrorCode.badRequest,
        message: 'PRD is required.',
      );
    }

    _isLoading = true;
    notifyListeners();

    try {
      final plan = await _aiService.analyzePrd(
        prdText: _prdText,
        frontend: _stack.frontend ?? '',
        backend: _stack.backend ?? '',
        database: _stack.database,
      );

      _currentPlan = plan;
      if (_isAuthenticated) {
        final conversation = Conversation(
          id:
              _selectedConversationId ??
              DateTime.now().microsecondsSinceEpoch.toString(),
          title: plan.projectTitle,
          createdAt: DateTime.now(),
          plan: plan,
        );

        _upsertConversation(conversation);
        _selectedConversationId = conversation.id;
        _persistConversations();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void exportJira() {
    final plan = _currentPlan;
    if (plan == null) {
      return;
    }
    _exportService.exportJiraCsv(plan);
  }

  void exportNotion() {
    final plan = _currentPlan;
    if (plan == null) {
      return;
    }
    _exportService.exportNotionMarkdown(plan);
  }

  void startNewConversation() {
    _selectedConversationId = null;
    _currentPlan = null;
    _prdText = '';
    notifyListeners();
  }

  String login(String email) {
    _isAuthenticated = true;
    _userLabel = email.trim().isEmpty ? '사용자' : email.trim();
    notifyListeners();
    return 'OTP is mocked in MVP mode.';
  }

  void logout() {
    _isAuthenticated = false;
    _userLabel = AppStrings.guestUser;
    _selectedConversationId = null;
    _currentPlan = null;
    notifyListeners();
  }

  String guestHistoryMessage() {
    return AppStrings.guestNoHistory;
  }

  void selectConversation(String id) {
    if (!_isAuthenticated) {
      return;
    }

    final conversation = _conversations
        .where((item) => item.id == id)
        .firstOrNull;
    if (conversation == null) {
      return;
    }

    _selectedConversationId = id;
    _currentPlan = conversation.plan;
    notifyListeners();
  }

  void _upsertConversation(Conversation conversation) {
    final index = _conversations.indexWhere(
      (item) => item.id == conversation.id,
    );
    if (index == -1) {
      _conversations.insert(0, conversation);
      return;
    }

    _conversations[index] = conversation;
  }

  void _loadPersistedConversations() {
    final raw = html.window.localStorage['sprint_ai_conversations'];
    if (raw == null || raw.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final loaded = decoded.whereType<Map>().map((item) {
        final map = item.cast<String, dynamic>();
        return Conversation(
          id: map['id'] as String,
          title: map['title'] as String,
          createdAt: DateTime.parse(map['created_at'] as String),
          plan: SprintPlan.fromJson(
            (map['plan'] as Map).cast<String, dynamic>(),
          ),
        );
      }).toList();

      _conversations
        ..clear()
        ..addAll(loaded);
    } catch (_) {
      _conversations.clear();
    }
  }

  void _persistConversations() {
    final payload = _conversations
        .map(
          (item) => {
            'id': item.id,
            'title': item.title,
            'created_at': item.createdAt.toIso8601String(),
            'plan': item.plan.toJson(),
          },
        )
        .toList();

    html.window.localStorage['sprint_ai_conversations'] = jsonEncode(payload);
  }
}

extension _FirstWhereOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    if (isEmpty) {
      return null;
    }
    return first;
  }
}
