import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/auth_form_widget.dart';
import './widgets/auth_header_widget.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool isLogin = true;
  bool isLoading = false;

  void toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  Future<void> handleAuthentication(Map<String, dynamic> authData) async {
    setState(() {
      isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Mock authentication success
      if (isLogin) {
        // Login logic would go here in a real app
        if (authData['email'] == 'user@example.com' && authData['password'] == 'Password123!') {
          // Navigate to home screen on successful login
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home-screen');
          }
        } else {
          // Show error for invalid credentials
          _showErrorDialog('Invalid email or password. Please try again.');
        }
      } else {
        // Registration logic would go here in a real app
        // For demo purposes, we'll just navigate to home screen
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home-screen');
        }
      }
    } catch (error) {
      // Handle authentication errors
      _showErrorDialog('Authentication failed. Please check your connection and try again.');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Authentication Error',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              _buildAuthContent(),
              if (isLoading) _buildLoadingOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 5.h),
            AuthHeaderWidget(isLogin: isLogin),
            SizedBox(height: 4.h),
            AuthFormWidget(
              isLogin: isLogin,
              onSubmit: handleAuthentication,
            ),
            SizedBox(height: 3.h),
            _buildAuthToggle(),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin ? "Don't have an account? " : "Already have an account? ",
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        GestureDetector(
          onTap: toggleAuthMode,
          child: Text(
            isLogin ? "Sign Up" : "Login",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withAlpha(77),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: AppTheme.primary,
              ),
              SizedBox(height: 2.h),
              Text(
                isLogin ? "Logging in..." : "Creating account...",
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}