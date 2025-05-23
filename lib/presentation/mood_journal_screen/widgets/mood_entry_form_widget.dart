import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MoodEntryFormWidget extends StatefulWidget {
  final Function(String, String) onSubmit;

  const MoodEntryFormWidget({
    super.key,
    required this.onSubmit,
  });

  @override
  State<MoodEntryFormWidget> createState() => _MoodEntryFormWidgetState();
}

class _MoodEntryFormWidgetState extends State<MoodEntryFormWidget> {
  final TextEditingController _noteController = TextEditingController();
  String? _selectedMood;
  bool _isSubmitting = false;
  final int _maxNoteLength = 150;

  final List<Map<String, dynamic>> _moodOptions = [
    {  "name": 'Relaxed', 'icon': 'spa', 'color': AppTheme.moodRelaxed},
    {  "name": 'Anxious', 'icon': 'psychology', 'color': AppTheme.moodAnxious},
    {  "name": 'Energetic', 'icon': 'bolt', 'color': AppTheme.moodEnergetic},
    {  "name": 'Lazy', 'icon': 'weekend', 'color': AppTheme.moodStressed},
    {  "name": 'Stressed', 'icon': 'sentiment_dissatisfied', 'color': AppTheme.moodStressed},
    {  "name": 'Happy', 'icon': 'sentiment_very_satisfied', 'color': AppTheme.moodEnergetic},
    {  "name": 'Focused', 'icon': 'center_focus_strong', 'color': AppTheme.moodRelaxed},
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select your mood'),
          backgroundColor: AppTheme.warning,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Call the onSubmit callback
    widget.onSubmit(_selectedMood!, _noteController.text.trim());

    // Reset form
    setState(() {
      _selectedMood = null;
      _noteController.clear();
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4.w),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How are you feeling?',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            _buildMoodSelector(),
            SizedBox(height: 2.h),
            _buildNoteField(),
            SizedBox(height: 2.h),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodSelector() {
    return SizedBox(
      height: 6.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _moodOptions.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final mood = _moodOptions[index];
          final isSelected = _selectedMood == mood['name'];
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedMood = mood['name'];
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                color: isSelected 
                    ? mood['color'].withAlpha(51) 
                    : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected 
                      ? mood['color'] 
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: mood['icon'],
                    color: isSelected 
                        ? mood['color'] 
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    mood['name'],
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: isSelected 
                          ? mood['color'] 
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
    );
  }

  Widget _buildNoteField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add a note (optional)',
          style: AppTheme.lightTheme.textTheme.labelLarge,
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: _noteController,
          maxLines: 3,
          maxLength: _maxNoteLength,
          decoration: InputDecoration(
            hintText: 'How are you feeling about your quit journey today?',
            counterText: '${_noteController.text.length}/$_maxNoteLength',
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isSubmitting ? null : _submitForm,
        icon: CustomIconWidget(
          iconName: _isSubmitting ? 'hourglass_empty' : 'add',
          color: Colors.white,
          size: 20,
        ),
        label: Text(_isSubmitting ? 'Logging...' : 'Log Mood'),
      ),
    );
  }
}