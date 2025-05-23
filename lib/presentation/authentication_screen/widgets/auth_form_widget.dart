import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './registration_fields_widget.dart';

class AuthFormWidget extends StatefulWidget {
  final bool isLogin;
  final Function(Map<String, dynamic>) onSubmit;

  const AuthFormWidget({
    super.key,
    required this.isLogin,
    required this.onSubmit,
  });

  @override
  State<AuthFormWidget> createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  
  final Map<String, dynamic> _authData = {
    'email': '',
    'password': '',
    'name': '',
    'age': '',
    'gender': 'Prefer not to say',
    'smokerType': 'Moderate',
  };

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Non-binary',
    'Prefer not to say',
  ];

  final List<String> _smokerTypeOptions = [
    'Light',
    'Moderate',
    'Heavy',
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    if (!widget.isLogin) {
      final hasUppercase = value.contains(RegExp(r'[A-Z]'));
      final hasDigit = value.contains(RegExp(r'[0-9]'));
      final hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      
      if (!hasUppercase || !hasDigit || !hasSpecialChar) {
        return 'Password must contain uppercase, number, and special character';
      }
    }
    
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    _formKey.currentState!.save();
    widget.onSubmit(_authData);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildEmailField(),
          SizedBox(height: 2.h),
          _buildPasswordField(),
          SizedBox(height: 2.h),
          if (!widget.isLogin) ...[
            RegistrationFieldsWidget(
              authData: _authData,
              genderOptions: _genderOptions,
              smokerTypeOptions: _smokerTypeOptions,
            ),
            SizedBox(height: 2.h),
          ],
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email address',
        prefixIcon: const CustomIconWidget(
          iconName: 'email',
          color: null,
          size: 20,
        ),
      ),
      validator: _validateEmail,
      onSaved: (value) {
        _authData['email'] = value!.trim();
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: widget.isLogin ? TextInputAction.done : TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: widget.isLogin 
            ? 'Enter your password' 
            : 'Create a strong password',
        prefixIcon: const CustomIconWidget(
          iconName: 'lock',
          color: null,
          size: 20,
        ),
        suffixIcon: IconButton(
          icon: CustomIconWidget(
            iconName: _obscurePassword ? 'visibility' : 'visibility_off',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
      validator: _validatePassword,
      onSaved: (value) {
        _authData['password'] = value!;
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submit,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        widget.isLogin ? 'Login' : 'Sign Up',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}