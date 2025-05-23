import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class RecentActivityWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activities;

  const RecentActivityWidget({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: activities.length,
        separatorBuilder: (context, index) => Divider(
          color: AppTheme.lightTheme.colorScheme.outline.withAlpha(77),
          height: 1,
        ),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return _buildActivityItem(context, activity);
        },
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, Map<String, dynamic> activity) {
    final DateTime timestamp = DateTime.parse(activity['timestamp']);
    final String formattedDate = DateFormat('MMM d, h:mm a').format(timestamp);
    
    Color moodColor;
    IconData moodIcon;
    
    switch (activity['mood']) {
      case 'Relaxed':
        moodColor = AppTheme.moodRelaxed;
        moodIcon = Icons.spa;
        break;
      case 'Energetic':
        moodColor = AppTheme.moodEnergetic;
        moodIcon = Icons.bolt;
        break;
      case 'Anxious':
        moodColor = AppTheme.moodAnxious;
        moodIcon = Icons.psychology;
        break;
      case 'Stressed':
        moodColor = AppTheme.moodStressed;
        moodIcon = Icons.sentiment_dissatisfied;
        break;
      default:
        moodColor = AppTheme.primary;
        moodIcon = Icons.mood;
    }

    String title;
    IconData activityIcon;
    
    switch (activity['type']) {
      case 'craving_resisted':
        title = 'Craving Resisted';
        activityIcon = Icons.thumb_up;
        break;
      case 'mood_logged':
        title = 'Mood Logged';
        activityIcon = Icons.mood;
        break;
      default:
        title = 'Activity';
        activityIcon = Icons.event_note;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 4.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              activityIcon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.titleSmall,
                    ),
                    Text(
                      formattedDate,
                      style: AppTheme.lightTheme.textTheme.labelSmall,
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Icon(
                      moodIcon,
                      color: moodColor,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      activity['mood'],
                      style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: moodColor,
                      ),
                    ),
                  ],
                ),
                if (activity['notes'] != null && activity['notes'].isNotEmpty) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    activity['notes'],
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}