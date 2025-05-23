import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TodaySummaryWidget extends StatelessWidget {
  final int cigarettesLogged;
  final int cravingsManaged;

  const TodaySummaryWidget({
    super.key,
    required this.cigarettesLogged,
    required this.cravingsManaged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withAlpha(128),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Cigarettes Logged',
                  cigarettesLogged.toString(),
                  'smoking_rooms',
                  AppTheme.warning,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Cravings Managed',
                  cravingsManaged.toString(),
                  'psychology',
                  AppTheme.moodRelaxed,
                ),
              ),
            ],
          ),
          if (cigarettesLogged > 0 || cravingsManaged > 0) ...[
            SizedBox(height: 3.h),
            _buildProgressIndicator(context),
            SizedBox(height: 2.h),
            _buildEncouragementMessage(context),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String title,
    String value,
    String iconName,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(1.5.w),
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(6),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 18,
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                title,
                style: AppTheme.lightTheme.textTheme.labelMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    // Calculate success rate
    final total = cigarettesLogged + cravingsManaged;
    final successRate = total > 0 ? cravingsManaged / total : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Success Rate',
              style: AppTheme.lightTheme.textTheme.labelMedium,
            ),
            Text(
              '${(successRate * 100).toStringAsFixed(0)}%',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getSuccessColor(successRate),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: successRate,
            backgroundColor: AppTheme.warning.withAlpha(51),
            valueColor: AlwaysStoppedAnimation<Color>(_getSuccessColor(successRate)),
            minHeight: 0.8.h,
          ),
        ),
      ],
    );
  }

  Color _getSuccessColor(double rate) {
    if (rate >= 0.7) return AppTheme.success;
    if (rate >= 0.4) return AppTheme.moodEnergetic;
    return AppTheme.warning;
  }

  Widget _buildEncouragementMessage(BuildContext context) {
    final total = cigarettesLogged + cravingsManaged;
    final successRate = total > 0 ? cravingsManaged / total : 0.0;
    
    String message;
    IconData icon;
    Color color;
    
    if (successRate >= 0.7) {
      message = 'Great job! You\'re making excellent progress.';
      icon = Icons.sentiment_very_satisfied;
      color = AppTheme.success;
    } else if (successRate >= 0.4) {
      message = 'You\'re doing well. Keep going!';
      icon = Icons.sentiment_satisfied;
      color = AppTheme.moodEnergetic;
    } else {
      message = 'Every craving managed is a step forward. You can do this!';
      icon = Icons.sentiment_neutral;
      color = AppTheme.warning;
    }
    
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            message,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}