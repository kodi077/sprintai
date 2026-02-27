import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_constants.dart';
import '../models/sprint_plan_model.dart';

class AiException implements Exception {
  const AiException({
    required this.code,
    required this.messageKo,
    this.retryAfterSec,
  });

  final String code;
  final String messageKo;
  final int? retryAfterSec;

  @override
  String toString() => messageKo;
}

const Map<String, dynamic> _mockSprintPlan = <String, dynamic>{
  'project_title': 'Mock Sprint Plan (개발 테스트용)',
  'stack': <String, dynamic>{
    'frontend': 'Flutter',
    'backend': 'Supabase',
    'database': 'PostgreSQL',
  },
  'epics': <Map<String, dynamic>>[
    <String, dynamic>{
      'id': 'E1',
      'name': 'User Authentication',
      'description': 'Implement login and session management.',
      'story_points': 8,
      'tasks': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 'E1-T1',
          'name': 'Email OTP Login',
          'description': 'Allow users to log in with email OTP.',
          'story_points': 5,
          'subtasks': <Map<String, dynamic>>[
            <String, dynamic>{'name': 'Create login UI', 'story_points': 2},
            <String, dynamic>{
              'name': 'Integrate Supabase Auth',
              'story_points': 3,
            },
          ],
          'acceptance_criteria': <String>[
            'User can enter email and receive OTP',
            'User is redirected to home after successful login',
          ],
          'risks': <String>['Email delivery delay may cause poor UX'],
        },
      ],
    },
  ],
};

class AiService {
  const AiService();

  static const String _edgeFunctionUrl = kAnalyzePrdEndpoint;

  Future<SprintPlan> analyzePrd({
    required String prdText,
    required String frontend,
    required String backend,
    String? database,
  }) async {
    if (kUseMockAi) {
      await Future<void>.delayed(const Duration(seconds: 2));
      return SprintPlan.fromJson(_mockSprintPlan);
    }

    if (_edgeFunctionUrl.trim().isEmpty) {
      throw const AiException(
        code: 'SERVER_ERROR',
        messageKo: 'Edge Function URL이 설정되지 않았습니다.',
      );
    }

    final body = <String, dynamic>{
      'prdText': prdText,
      'stack': <String, dynamic>{
        'frontend': frontend,
        'backend': backend,
        'database': database ?? '',
      },
      'conversationId': null,
      'mode': 'guest',
    };

    final response = await http
        .post(
          Uri.parse(_edgeFunctionUrl),
          headers: const <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 30));

    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

    if (responseJson['error'] != null) {
      final err = responseJson['error'] as Map<String, dynamic>;
      throw AiException(
        code: err['code'] as String? ?? 'SERVER_ERROR',
        messageKo: err['message_ko'] as String? ?? '오류가 발생했습니다.',
        retryAfterSec: (err['retry_after_sec'] as num?)?.toInt(),
      );
    }

    if (responseJson['data'] != null) {
      return SprintPlan.fromJson(responseJson['data'] as Map<String, dynamic>);
    }

    throw const AiException(
      code: 'SERVER_ERROR',
      messageKo: '알 수 없는 오류가 발생했습니다.',
    );
  }
}
