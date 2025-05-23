import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MoodEntryItemWidget extends StatelessWidget {
  final Map<String, dynamic> entry;

  const MoodEntryItemWidget({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime timestamp = DateTime.parse(entry['timestamp']);
    final String formattedTime = DateFormat('h:mm a').format(timestamp);
    
    // Determine mood color and icon
    Color moodColor;
    String moodIcon;
    
    switch (entry['mood']) {
      case 'Relaxed':
        moodColor = AppTheme.moodRelaxed;
        moodIcon = 'spa';
        break;
      case 'Anxious':
        moodColor = AppTheme.moodAnxious;
        moodIcon = 'psychology';
        break;
      case 'Energetic':
        moodColor = AppTheme.moodEnergetic;
        moodIcon = 'bolt';
        break;
      case 'Lazy':
        moodColor = AppTheme.moodStressed;
        moodIcon = 'weekend';
        break;
      case 'Stressed':
        moodColor = AppTheme.moodStressed;
        moodIcon = 'sentiment_dissatisfied';
        break;
      case 'Happy':
        moodColor = AppTheme.moodEnergetic;
        moodIcon = 'sentiment_very_satisfied';
        break;
      case 'Focused':
        moodColor = AppTheme.moodRelaxed;
        moodIcon = 'center_focus_strong';
        break;
      default:
        moodColor = AppTheme.primary;
        moodIcon = 'mood';
    }

    return Container(
      margin: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withAlpha(128),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: moodColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: moodIcon,
                    color: moodColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  entry['mood'],
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: moodColor,
                  ),
                ),
                const Spacer(),
                Text(
                  formattedTime,
                  style: AppTheme.lightTheme.textTheme.labelSmall,
                ),
              ],
            ),
            if (entry['note'] != null && entry['note'].isNotEmpty) ...[
              SizedBox(height: 1.5.h),
              Text(
                entry['note'],
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}