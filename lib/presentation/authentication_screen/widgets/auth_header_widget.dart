import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AuthHeaderWidget extends StatelessWidget {
  final bool isLogin;

  const AuthHeaderWidget({
    super.key,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogo(),
        SizedBox(height: 3.h),
        Text(
          isLogin ? "Welcome Back" : "Create Account",
          style: AppTheme.lightTheme.textTheme.displayMedium,
        ),
        SizedBox(height: 1.h),
        Text(
          isLogin
              ? "Sign in to continue your smoke-free journey"
              : "Join SmokeShift to start your smoke-free journey",
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomIconWidget(
            iconName: 'smoke_free',
            color: AppTheme.primary,
            size: 32,
          ),
        ),
        SizedBox(width: 3.w),
        Text(
          "SmokeShift",
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}