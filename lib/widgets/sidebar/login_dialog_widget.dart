import 'package:flutter/material.dart';

import '../../config/app_constants.dart';
import '../../services/auth_service.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;
  bool _loading = false;
  String? _error;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text(
        AppStrings.loginPrompt,
        style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
      ),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: AppColors.error, fontSize: 13),
              ),
            if (_error != null) const SizedBox(height: 8),
            if (!_otpSent)
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: AppStrings.loginEmailHint,
                ),
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            if (!_otpSent) const SizedBox(height: 12),
            if (!_otpSent)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _sendOtp,
                  child: _loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : const Text(AppStrings.sendOtp),
                ),
              ),
            if (_otpSent)
              Text(
                '${_emailController.text} 으로 OTP를 전송했습니다.',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            if (_otpSent) const SizedBox(height: 8),
            if (_otpSent)
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(hintText: '000000'),
                keyboardType: TextInputType.number,
                maxLength: 6,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            if (_otpSent) const SizedBox(height: 12),
            if (_otpSent)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _verifyOtp,
                  child: _loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : const Text(AppStrings.verifyOtp),
                ),
              ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            '취소',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Future<void> _sendOtp() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _authService.sendOtp(_emailController.text.trim());
      if (!mounted) {
        return;
      }
      setState(() {
        _otpSent = true;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = '이메일을 확인해주세요.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _authService.verifyOtp(
        _emailController.text.trim(),
        _otpController.text.trim(),
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = 'OTP가 올바르지 않습니다. 다시 확인해주세요.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }
}
