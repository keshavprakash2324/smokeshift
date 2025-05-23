import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SmokingLogModalWidget extends StatefulWidget {
  final Function(String, String) onSubmit;

  const SmokingLogModalWidget({
    super.key,
    required this.onSubmit,
  });

  @override
  State<SmokingLogModalWidget> createState() => _SmokingLogModalWidgetState();
}

class _SmokingLogModalWidgetState extends State<SmokingLogModalWidget> {
  final _formKey = GlobalKey<FormState>();
  String _selectedMood = 'Neutral';
  final TextEditingController _reasonController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _moodOptions = [
    'Relaxed',
    'Energetic',
    'Neutral',
    'Stressed',
    'Anxious',
    'Bored',
    'Happy',
    'Sad',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      
      // Submit the form
      widget.onSubmit(_selectedMood, _reasonController.text);
      
      // Close the modal
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 2.h,
        left: 4.w,
        right: 4.w,
        bottom: MediaQuery.of(context).viewInsets.bottom + 2.h,
      ),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Log Smoking Event',
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
            SizedBox(height: 3.h),
            Text(
              'How are you feeling?',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            SizedBox(height: 1.h),
            _buildMoodSelector(),
            SizedBox(height: 3.h),
            Text(
              'Why did you smoke?',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            SizedBox(height: 1.h),
            TextFormField(
              controller: _reasonController,
              decoration: InputDecoration(
                hintText: 'E.g., After coffee, Stress, Social situation...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a reason';
                }
                return null;
              },
            ),
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
                    : Text('Log Event'),
              ),
            ),
            SizedBox(height: 1.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: _moodOptions.map((mood) {
        final isSelected = _selectedMood == mood;
        
        Color chipColor;
        switch (mood) {
          case 'Relaxed':
            chipColor = AppTheme.moodRelaxed;
            break;
          case 'Energetic':
            chipColor = AppTheme.moodEnergetic;
            break;
          case 'Stressed':
            chipColor = AppTheme.moodStressed;
            break;
          case 'Anxious':
            chipColor = AppTheme.moodAnxious;
            break;
          default:
            chipColor = AppTheme.primary;
        }
        
        return ChoiceChip(
          label: Text(mood),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedMood = mood;
              });
            }
          },
          backgroundColor: chipColor.withAlpha(26),
          selectedColor: chipColor.withAlpha(51),
          labelStyle: TextStyle(
            color: isSelected ? chipColor : AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          avatar: isSelected
              ? Icon(
                  Icons.check_circle,
                  size: 18,
                  color: chipColor,
                )
              : null,
        );
      }).toList(),
    );
  }
}