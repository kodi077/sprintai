import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_constants.dart';
import '../config/mock_sprint_plan.dart';
import '../models/app_error.dart';
import '../models/sprint_plan_model.dart';
import '../models/stack_model.dart';

class AiService {
  const AiService();

  Future<SprintPlan> analyzePrd({
    required String prdText,
    required StackSelection stack,
    required String mode,
    String? conversationId,
  }) async {
    if (kUseMockAi) {
      return SprintPlan.fromJson(jsonDecode(kMockSprintPlanJson) as Map<String, dynamic>);
    }

    if (kAnalyzePrdEndpoint.trim().isEmpty) {
      throw const AppError(code: ErrorCode.serverError, message: 'Missing analyze_prd endpoint.');
    }

    final response = await http.post(
      Uri.parse(kAnalyzePrdEndpoint),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'prdText': prdText,
        'stack': stack.toJson(),
        'conversationId': conversationId,
        'mode': mode,
      }),
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      final error = (body['error'] as Map?)?.cast<String, dynamic>() ?? const <String, dynamic>{};
      final code = (error['code'] as String?) ?? 'SERVER_ERROR';
      throw AppError(
        code: _parseErrorCode(code),
        message: (error['message_ko'] as String?) ?? 'Server error',
        retryAfterSec: (error['retry_after_sec'] as num?)?.toInt(),
      );
    }

    final data = (body['data'] as Map?)?.cast<String, dynamic>();
    if (data == null || !data.containsKey('project_title') || !data.containsKey('epics')) {
      throw const AppError(code: ErrorCode.serverError, message: 'Invalid response shape.');
    }

    return SprintPlan.fromJson(data);
  }

  ErrorCode _parseErrorCode(String code) {
    switch (code) {
      case 'RATE_LIMITED':
        return ErrorCode.rateLimited;
      case 'DAILY_LIMIT':
        return ErrorCode.dailyLimit;
      case 'BAD_REQUEST':
        return ErrorCode.badRequest;
      default:
        return ErrorCode.serverError;
    }
  }
}
