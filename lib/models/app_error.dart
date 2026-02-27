enum ErrorCode {
  rateLimited,
  dailyLimit,
  badRequest,
  serverError,
}

class AppError implements Exception {
  const AppError({
    required this.code,
    required this.message,
    this.retryAfterSec,
  });

  final ErrorCode code;
  final String message;
  final int? retryAfterSec;
}
