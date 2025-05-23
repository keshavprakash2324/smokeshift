import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MoodFilterWidget extends StatelessWidget {
  final String? selectedFilter;
  final Function(String?) onFilterChanged;

  const MoodFilterWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filterOptions = [
      {  "name": 'Relaxed', 'icon': 'spa', 'color': AppTheme.moodRelaxed},
      {  "name": 'Anxious', 'icon': 'psychology', 'color': AppTheme.moodAnxious},
      {  "name": 'Energetic', 'icon': 'bolt', 'color': AppTheme.moodEnergetic},
      {  "name": 'Stressed', 'icon': 'sentiment_dissatisfied', 'color': AppTheme.moodStressed},
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline.withAlpha(77),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'filter_list',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Filter by mood:',
                  style: AppTheme.lightTheme.textTheme.labelMedium,
                ),
                const Spacer(),
                if (selectedFilter != null)
                  TextButton.icon(
                    onPressed: () => onFilterChanged(null),
                    icon: const CustomIconWidget(
                      iconName: 'clear',
                      color: null,
                      size: 16,
                    ),
                    label: Text('Clear'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 5.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              scrollDirection: Axis.horizontal,
              itemCount: filterOptions.length,
              separatorBuilder: (context, index) => SizedBox(width: 2.w),
              itemBuilder: (context, index) {
                final filter = filterOptions[index];
                final isSelected = selectedFilter == filter['name'];
                
                return GestureDetector(
                  onTap: () => onFilterChanged(filter['name']),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? filter['color'].withAlpha(51) 
                          : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected 
                            ? filter['color'] 
                            : AppTheme.lightTheme.colorScheme.outline,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: filter['icon'],
                          color: isSelected 
                              ? filter['color'] 
                              : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          filter['name'],
                          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                            color: isSelected 
                                ? filter['color'] 
                                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}