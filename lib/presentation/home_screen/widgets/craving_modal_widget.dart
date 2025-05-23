import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CravingModalWidget extends StatefulWidget {
  final VoidCallback onSubmit;

  const CravingModalWidget({
    super.key,
    required this.onSubmit,
  });

  @override
  State<CravingModalWidget> createState() => _CravingModalWidgetState();
}

class _CravingModalWidgetState extends State<CravingModalWidget> {
  bool _isSubmitting = false;
  int _selectedSuggestionIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 2.h,
        horizontal: 4.w,
      ),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Managing Your Craving',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const CustomIconWidget(
                  iconName: 'close',
                  color: null,
                  size: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Try one of these activities to distract yourself:',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          SizedBox(height: 2.h),
          _buildDistractionSuggestions(),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _handleSubmit,
              child: _isSubmitting
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text('I Managed My Craving'),
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('I\'ll Try Later'),
            ),
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildDistractionSuggestions() {
    final suggestions = _getDistractionSuggestions();
    
    return SizedBox(
      height: 30.h,
      child: ListView.separated(
        itemCount: suggestions.length,
        separatorBuilder: (context, index) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final isSelected = _selectedSuggestionIndex == index;
          
          return InkWell(
            onTap: () {
              setState(() {
                _selectedSuggestionIndex = index;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? suggestion['color'].withAlpha(26)
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? suggestion['color']
                      : AppTheme.lightTheme.colorScheme.outline.withAlpha(128),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: suggestion['color'].withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: suggestion['iconName'],
                      color: suggestion['color'],
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          suggestion['title'],
                          style: AppTheme.lightTheme.textTheme.titleSmall,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          suggestion['description'],
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: suggestion['color'],
                      size: 24,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getDistractionSuggestions() {
    return [
      {
        'title': 'Take a Walk',
        'description': 'A 5-minute walk can reduce cravings significantly',
        'iconName': 'directions_walk',
        'color': AppTheme.moodRelaxed,
      },
      {
        'title': 'Deep Breathing',
        'description': 'Try 4-7-8 breathing: inhale for 4, hold for 7, exhale for 8',
        'iconName': 'air',
        'color': AppTheme.primary,
      },
      {
        'title': 'Drink Water',
        'description': 'Staying hydrated helps reduce cravings',
        'iconName': 'local_drink',
        'color': AppTheme.info,
      },
      {
        'title': 'Call a Friend',
        'description': 'Social support can help you resist cravings',
        'iconName': 'call',
        'color': AppTheme.moodEnergetic,
      },
      {
        'title': 'Mindfulness',
        'description': 'Focus on your senses to stay present',
        'iconName': 'spa',
        'color': AppTheme.moodRelaxed,
      },
    ];
  }

  void _handleSubmit() {
    setState(() {
      _isSubmitting = true;
    });
    
    // Submit the form
    widget.onSubmit();
    
    // Close the modal
    Navigator.pop(context);
  }
}