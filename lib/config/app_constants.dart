import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFF5F7FB);
  static const Color sidebar = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFD6DCE8);
  static const Color primary = Color(0xFF0B66FF);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF059669);
}

class AppStrings {
  static const String appTitle = 'SprintAI';
  static const String newConversation = '새 대화';
  static const String conversationHistory = '대화 목록';
  static const String login = '로그인';
  static const String logout = '로그아웃';
  static const String frontendLabel = '프레임워크';
  static const String backendLabel = '백엔드';
  static const String databaseLabel = '데이터베이스';
  static const String prdInputHint = 'PRD를 여기에 붙여넣으세요...';
  static const String uploadFile = '파일 업로드';
  static const String analyzeButton = '분석하기';
  static const String exportJira = 'Jira로 내보내기';
  static const String exportNotion = 'Notion으로 내보내기';
  static const String analyzing = '분석 중입니다... 잠시만 기다려 주세요.';
  static const String guestUser = '게스트';
  static const String storyPoints = 'SP';
  static const String acceptanceCriteria = '완료 조건';
  static const String risks = '리스크';
  static const String confirm = '확인';
  static const String guestNoHistory = '게스트 모드에서는 대화 기록이 저장되지 않습니다. 로그인하면 기록을 저장할 수 있어요.';

  static const String rateLimitedTitle = '요청이 너무 많아요';
  static const String rateLimitedMessage = '현재 분당 AI 요청 한도(분당)가 초과되었습니다. 약 1분 후 다시 시도해 주세요.';
  static const String dailyLimitTitle = '오늘의 무료 사용량을 모두 사용했어요';
  static const String dailyLimitMessage = '무료 AI 요청 한도(일일)가 초과되었습니다. 내일 다시 시도해 주세요. ※ 데모 환경에서는 요청 횟수가 제한됩니다.';
  static const String serverErrorTitle = '문제가 발생했어요';
  static const String serverErrorMessage = '일시적인 오류입니다. 잠시 후 다시 시도해 주세요.';
}

class AppSizes {
  static const double sidebarWidth = 280;
  static const double borderRadius = 10;
  static const double padding = 16;
  static const double paddingSmall = 8;
  static const double paddingLarge = 24;
}

const bool kUseMockAi = true;
const String kAnalyzePrdEndpoint = String.fromEnvironment(
  'ANALYZE_PRD_ENDPOINT',
  defaultValue: '',
);
