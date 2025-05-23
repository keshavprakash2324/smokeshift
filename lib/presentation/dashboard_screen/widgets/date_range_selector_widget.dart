import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DateRangeSelectorWidget extends StatelessWidget {
  final String selectedRange;
  final Function(String) onRangeChanged;

  const DateRangeSelectorWidget({
    super.key,
    required this.selectedRange,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.lightTheme.colorScheme.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRangeOption(context, 'Today'),
          _buildRangeOption(context, 'Week'),
          _buildRangeOption(context, 'Month'),
        ],
      ),
    );
  }

  Widget _buildRangeOption(BuildContext context, String range) {
    final isSelected = selectedRange == range;
    
    return GestureDetector(
      onTap: () => onRangeChanged(range),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        margin: EdgeInsets.symmetric(horizontal: 0.5.w),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.lightTheme.colorScheme.primary 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          range,
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: isSelected 
                ? AppTheme.lightTheme.colorScheme.onPrimary 
                : AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}