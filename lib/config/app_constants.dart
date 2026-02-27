import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF141922);
  static const Color sidebar = Color(0xFF1A202B);
  static const Color surface = Color(0xFF232B38);
  static const Color border = Color(0xFF364152);
  static const Color primary = Color(0xFF4F8EF7);
  static const Color primaryHover = Color(0xFF3C77DA);
  static const Color textPrimary = Color(0xFFF4F7FC);
  static const Color textSecondary = Color(0xFFB2BDC9);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
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
  static const String selectFrontend = '프레임워크 선택';
  static const String selectBackend = '백엔드 선택';
  static const String selectDatabase = '데이터베이스 선택 (선택사항)';
  static const String loginPrompt = '이메일로 로그인하세요';
  static const String loginEmailHint = '이메일 주소 입력';
  static const String sendOtp = 'OTP 전송';
  static const String enterOtp = 'OTP 코드 입력';
  static const String verifyOtp = '확인';
  static const String storyPoints = 'SP';
  static const String acceptanceCriteria = '완료 조건';
  static const String risks = '리스크';
  static const String confirm = '확인';
  static const String guestNoHistory =
      '게스트 모드에서는 대화 기록이 저장되지 않습니다. 로그인하면 기록을 저장할 수 있어요.';

  static const String rateLimitedTitle = '요청이 너무 많아요';
  static const String rateLimitedMessage =
      '현재 분당 AI 요청 한도(분당)가 초과되었습니다. 약 1분 후 다시 시도해 주세요.';
  static const String dailyLimitTitle = '오늘의 무료 사용량을 모두 사용했어요';
  static const String dailyLimitMessage =
      '무료 AI 요청 한도(일일)가 초과되었습니다. 내일 다시 시도해 주세요. ※ 데모 환경에서는 요청 횟수가 제한됩니다.';
  static const String serverErrorTitle = '문제가 발생했어요';
  static const String serverErrorMessage = '일시적인 오류입니다. 잠시 후 다시 시도해 주세요.';
}

class AppSizes {
  static const double sidebarWidth = 260.0;
  static const double borderRadius = 8.0;
  static const double padding = 16.0;
  static const double paddingSmall = 8.0;
  static const double paddingLarge = 24.0;
}

const bool kUseMockAi = false;
const String kAnalyzePrdEndpoint =
    'https://hmbmkydxsixjkwdqsjrz.supabase.co/functions/v1/analyze_prd';
