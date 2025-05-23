import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationFieldsWidget extends StatelessWidget {
  final Map<String, dynamic> authData;
  final List<String> genderOptions;
  final List<String> smokerTypeOptions;

  const RegistrationFieldsWidget({
    super.key,
    required this.authData,
    required this.genderOptions,
    required this.smokerTypeOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNameField(),
        SizedBox(height: 2.h),
        _buildAgeField(),
        SizedBox(height: 2.h),
        _buildGenderField(context),
        SizedBox(height: 2.h),
        _buildSmokerTypeField(context),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Full Name',
        hintText: 'Enter your full name',
        prefixIcon: const CustomIconWidget(
          iconName: 'person',
          color: null,
          size: 20,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Name is required';
        }
        return null;
      },
      onSaved: (value) {
        authData['name'] = value!.trim();
      },
    );
  }

  Widget _buildAgeField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      decoration: InputDecoration(
        labelText: 'Age',
        hintText: 'Enter your age',
        prefixIcon: const CustomIconWidget(
          iconName: 'cake',
          color: null,
          size: 20,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Age is required';
        }
        
        final age = int.tryParse(value);
        if (age == null || age < 18 || age > 120) {
          return 'Please enter a valid age (18-120)';
        }
        
        return null;
      },
      onSaved: (value) {
        authData['age'] = value!;
      },
    );
  }

  Widget _buildGenderField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender (Optional)',
          style: AppTheme.lightTheme.textTheme.labelMedium,
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                prefixIcon: const CustomIconWidget(
                  iconName: 'people',
                  color: null,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
              ),
              value: authData['gender'],
              items: genderOptions.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  authData['gender'] = newValue;
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmokerTypeField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Smoker Type',
          style: AppTheme.lightTheme.textTheme.labelMedium,
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                prefixIcon: const CustomIconWidget(
                  iconName: 'smoking_rooms',
                  color: null,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
              ),
              value: authData['smokerType'],
              items: smokerTypeOptions.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  authData['smokerType'] = newValue;
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your smoker type';
                }
                return null;
              },
            ),
          ),
        ),
        SizedBox(height: 1.h),
        _buildSmokerTypeInfo(),
      ],
    );
  }

  Widget _buildSmokerTypeInfo() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.info.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: 'info',
            color: AppTheme.info,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              'Light: < 10 cigarettes/day\nModerate: 10-20 cigarettes/day\nHeavy: > 20 cigarettes/day',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}