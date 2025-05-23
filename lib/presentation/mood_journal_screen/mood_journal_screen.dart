import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/mood_entry_form_widget.dart';
import './widgets/mood_entry_item_widget.dart';
import './widgets/mood_filter_widget.dart';

class MoodJournalScreen extends StatefulWidget {
  const MoodJournalScreen({super.key});

  @override
  State<MoodJournalScreen> createState() => _MoodJournalScreenState();
}

class _MoodJournalScreenState extends State<MoodJournalScreen> {
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasError = false;
  String? selectedMoodFilter;
  List<Map<String, dynamic>> moodEntries = [];
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  final int entriesPerPage = 10;
  bool hasMoreEntries = true;

  @override
  void initState() {
    super.initState();
    _loadMoodEntries();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8 &&
        !isLoadingMore &&
        hasMoreEntries) {
      _loadMoreEntries();
    }
  }

  Future<void> _loadMoodEntries({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        currentPage = 1;
        hasMoreEntries = true;
      });
    }

    setState(() {
      isLoading = refresh ? true : isLoading;
      hasError = false;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      final List<Map<String, dynamic>> fetchedEntries = _getMockMoodEntries(currentPage);
      
      setState(() {
        if (refresh || currentPage == 1) {
          moodEntries = fetchedEntries;
        } else {
          moodEntries.addAll(fetchedEntries);
        }
        isLoading = false;
        hasMoreEntries = fetchedEntries.length >= entriesPerPage;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _loadMoreEntries() async {
    if (isLoadingMore || !hasMoreEntries) return;
    
    setState(() {
      isLoadingMore = true;
    });
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Increment page and fetch more entries
      currentPage++;
      final List<Map<String, dynamic>> fetchedEntries = _getMockMoodEntries(currentPage);
      
      setState(() {
        moodEntries.addAll(fetchedEntries);
        isLoadingMore = false;
        hasMoreEntries = fetchedEntries.length >= entriesPerPage;
      });
    } catch (e) {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  List<Map<String, dynamic>> _getMockMoodEntries(int page) {
    // Generate mock data based on page number
    final List<Map<String, dynamic>> entries = [];
    final DateTime now = DateTime.now();
    
    // Different moods for variety
    final List<String> moods = ['Relaxed', 'Anxious', 'Energetic', 'Lazy', 'Stressed', 'Happy', 'Focused'];
    
    // Notes templates
    final List<String> notes = [
      'Feeling good today after avoiding a cigarette.',
      'Had a craving but managed to distract myself.',
      'Meditation helped me stay calm.',
      'Difficult day, but staying strong.',
      'Exercise really helped with cravings.',
      'Proud of my progress so far!',
      'Feeling the benefits of not smoking.',
      'Struggled a bit today, but still smoke-free.',
      '',  // Empty notes sometimes
    ];
    
    // If filter is applied, only return entries with that mood
    final filteredMoods = selectedMoodFilter != null ? [selectedMoodFilter!] : moods;
    
    // Generate entries for this page
    final int startIndex = (page - 1) * entriesPerPage;
    final int endIndex = startIndex + entriesPerPage;
    
    for (int i = startIndex; i < endIndex; i++) {
      // Stop generating if we've reached a reasonable limit
      if (i >= 50) break;
      
      final mood = filteredMoods[i % filteredMoods.length];
      final note = notes[i % notes.length];
      final daysAgo = i ~/ 3;  // Group entries by day (3 entries per day)
      
      final entryDate = now.subtract(Duration(days: daysAgo, hours: (i % 3) * 4));
      
      entries.add({
        'id': i + 1,
        'mood': mood,
        'note': note,
        'timestamp': entryDate.toIso8601String(),
      });
    }
    
    // Return fewer items on later pages to simulate end of data
    if (page > 3) {
      return entries.take(entries.length ~/ 2).toList();
    }
    
    return entries;
  }

  void _addMoodEntry(String mood, String note) async {
    // Create new entry
    final newEntry = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'mood': mood,
      'note': note,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    // Optimistic UI update
    setState(() {
      moodEntries.insert(0, newEntry);
    });
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // In a real app, you would handle the response and update the entry if needed
      // For now, we'll just keep our optimistic update
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mood logged successfully!'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      // Revert optimistic update on error
      if (mounted) {
        setState(() {
          moodEntries.removeAt(0);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to log mood. Please try again.'),
            backgroundColor: AppTheme.error,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _addMoodEntry(mood, note),
            ),
          ),
        );
      }
    }
  }

  void _onMoodFilterChanged(String? mood) {
    setState(() {
      selectedMoodFilter = mood == selectedMoodFilter ? null : mood;
      isLoading = true;
      currentPage = 1;
    });
    _loadMoodEntries();
  }

  Map<String, List<Map<String, dynamic>>> _groupEntriesByDay() {
    final Map<String, List<Map<String, dynamic>>> groupedEntries = {};
    
    for (final entry in moodEntries) {
      final DateTime entryDate = DateTime.parse(entry['timestamp']);
      final String dateKey = DateFormat('yyyy-MM-dd').format(entryDate);
      
      if (!groupedEntries.containsKey(dateKey)) {
        groupedEntries[dateKey] = [];
      }
      
      groupedEntries[dateKey]!.add(entry);
    }
    
    return groupedEntries;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mood Journal',
          style: AppTheme.lightTheme.textTheme.headlineMedium,
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Mood Entry Form
            MoodEntryFormWidget(onSubmit: _addMoodEntry),
            
            // Mood Filters
            MoodFilterWidget(
              selectedFilter: selectedMoodFilter,
              onFilterChanged: _onMoodFilterChanged,
            ),
            
            // Entries List
            Expanded(
              child: _buildEntriesList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildEntriesList() {
    if (isLoading && moodEntries.isEmpty) {
      return _buildLoadingState();
    }
    
    if (hasError && moodEntries.isEmpty) {
      return _buildErrorState();
    }
    
    if (moodEntries.isEmpty) {
      return _buildEmptyState();
    }
    
    final groupedEntries = _groupEntriesByDay();
    final sortedDates = groupedEntries.keys.toList()..sort((a, b) => b.compareTo(a));
    
    return RefreshIndicator(
      onRefresh: () => _loadMoodEntries(refresh: true),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        itemCount: sortedDates.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= sortedDates.length) {
            return _buildLoadMoreIndicator();
          }
          
          final dateKey = sortedDates[index];
          final entries = groupedEntries[dateKey]!;
          final DateTime date = DateTime.parse(dateKey);
          final String formattedDate = _formatDateHeader(date);
          
          return _buildDaySection(formattedDate, entries);
        },
      ),
    );
  }

  String _formatDateHeader(DateTime date) {
    final DateTime now = DateTime.now();
    final DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
    
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('EEEE, MMMM d').format(date);
    }
  }

  Widget _buildDaySection(String dateHeader, List<Map<String, dynamic>> entries) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        dateHeader,
        style: AppTheme.lightTheme.textTheme.titleMedium,
      ),
      children: entries.map((entry) => MoodEntryItemWidget(entry: entry)).toList(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading your mood journal...',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.colorScheme.primary,
          strokeWidth: 3,
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'error_outline',
              color: AppTheme.error,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'Oops! Something went wrong',
              style: AppTheme.lightTheme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'We couldn\'t load your mood entries. Please check your connection and try again.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: () => _loadMoodEntries(refresh: true),
              icon: const CustomIconWidget(
                iconName: 'refresh',
                color: Colors.white,
                size: 20,
              ),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'mood',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'Your Mood Journal is Empty',
              style: AppTheme.lightTheme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Start tracking how you feel during your quit journey. Use the form above to log your first mood entry.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: () {
                // Scroll to top to show the form
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
              icon: const CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 20,
              ),
              label: const Text('Log Your First Mood'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 1, // Mood Journal is selected
      onTap: (index) {
        // Handle navigation to other screens
        if (index == 0) {
          Navigator.pushNamed(context, '/home-screen');
        } else if (index == 2) {
          Navigator.pushNamed(context, '/dashboard-screen');
        }
        // If index is 1, we're already on the mood journal screen
      },
      items: const [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            size: 24,
            color: null, // Will use the theme's default color
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'mood',
            size: 24,
            color: null,
          ),
          label: 'Mood Journal',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard',
            size: 24,
            color: null,
          ),
          label: 'Dashboard',
        ),
      ],
    );
  }
}