import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_button_widget.dart';
import './widgets/craving_modal_widget.dart';
import './widgets/distraction_suggestion_widget.dart';
import './widgets/prediction_card_widget.dart';
import './widgets/smoking_log_modal_widget.dart';
import './widgets/today_summary_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isOnline = true;
  int cigarettesLoggedToday = 0;
  int cravingsManagedToday = 0;
  List<Map<String, dynamic>> offlineQueue = [];

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _loadTodaySummary();
    
    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      final wasOnline = isOnline;
      setState(() {
        isOnline = result != ConnectivityResult.none;
      });
      
      // If we're back online and had been offline, process queue
      if (isOnline && !wasOnline) {
        _processOfflineQueue();
      }
    });
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isOnline = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> _loadTodaySummary() async {
    // In a real app, this would fetch from local storage or API
    // For demo, we'll use mock data
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cigarettesLoggedToday = prefs.getInt('cigarettesLoggedToday') ?? 0;
      cravingsManagedToday = prefs.getInt('cravingsManagedToday') ?? 0;
      
      // Load offline queue if any
      final queueString = prefs.getString('offlineQueue');
      if (queueString != null && queueString.isNotEmpty) {
        // In a real app, you'd parse the JSON string to a List
        // For demo, we'll just set a sample queue if one exists
        offlineQueue = _getSampleOfflineQueue();
      }
    });
  }

  List<Map<String, dynamic>> _getSampleOfflineQueue() {
    return [
      {
        "type": "smoking_event",
        "timestamp": DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        "mood": "Stressed",
        "reason": "Work deadline"
      }
    ];
  }

  Future<void> _processOfflineQueue() async {
    if (offlineQueue.isEmpty) return;
    
    // In a real app, you would send each item to the server
    // For demo, we'll just clear the queue and update UI
    
    // Process each item in the queue
    for (var item in offlineQueue) {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Update local counts based on the type of event
      if (item["type"] == "smoking_event") {
        setState(() {
          cigarettesLoggedToday++;
        });
      } else if (item["type"] == "craving_managed") {
        setState(() {
          cravingsManagedToday++;
        });
      }
    }
    
    // Clear the queue after processing
    setState(() {
      offlineQueue = [];
    });
    
    // Update shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cigarettesLoggedToday', cigarettesLoggedToday);
    await prefs.setInt('cravingsManagedToday', cravingsManagedToday);
    await prefs.setString('offlineQueue', '');
    
    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Synced offline data successfully',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _logSmokingEvent(String mood, String reason) async {
    final event = {
      "type": "smoking_event",
      "timestamp": DateTime.now().toIso8601String(),
      "mood": mood,
      "reason": reason
    };
    
    if (isOnline) {
      // In a real app, this would be an API call
      // For demo, we'll just update the local state
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        cigarettesLoggedToday++;
      });
      
      // Update shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('cigarettesLoggedToday', cigarettesLoggedToday);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Smoking event logged successfully',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      // Add to offline queue
      setState(() {
        offlineQueue.add(event);
      });
      
      // Store in shared preferences
      final prefs = await SharedPreferences.getInstance();
      // In a real app, you'd convert the queue to JSON string
      await prefs.setString('offlineQueue', 'has_items');
      
      // Show offline message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You\'re offline. Event saved and will sync when online.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            backgroundColor: AppTheme.warning,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _logCravingManaged() async {
    final event = {
      "type": "craving_managed",
      "timestamp": DateTime.now().toIso8601String(),
    };
    
    if (isOnline) {
      // In a real app, this would be an API call
      // For demo, we'll just update the local state
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        cravingsManagedToday++;
      });
      
      // Update shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('cravingsManagedToday', cravingsManagedToday);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Craving managed successfully',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      // Add to offline queue
      setState(() {
        offlineQueue.add(event);
      });
      
      // Store in shared preferences
      final prefs = await SharedPreferences.getInstance();
      // In a real app, you'd convert the queue to JSON string
      await prefs.setString('offlineQueue', 'has_items');
      
      // Show offline message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You\'re offline. Event saved and will sync when online.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            backgroundColor: AppTheme.warning,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showSmokingLogModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SmokingLogModalWidget(
        onSubmit: _logSmokingEvent,
      ),
    );
  }

  void _showCravingModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CravingModalWidget(
        onSubmit: _logCravingManaged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SmokeShift',
          style: AppTheme.lightTheme.textTheme.headlineMedium,
        ),
        actions: [
          if (!isOnline && offlineQueue.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: Badge(
                label: Text(offlineQueue.length.toString()),
                child: const CustomIconWidget(
                  iconName: 'cloud_off',
                  color: null,
                  size: 24,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async {
        await _checkConnectivity();
        await _loadTodaySummary();
        if (isOnline && offlineQueue.isNotEmpty) {
          await _processOfflineQueue();
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prediction Card
            const PredictionCardWidget(),
            SizedBox(height: 4.h),
            
            // Action Buttons
            Text(
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: ActionButtonWidget(
                    title: 'Log Smoking Event',
                    iconName: 'smoking_rooms',
                    color: AppTheme.warning,
                    onTap: _showSmokingLogModal,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ActionButtonWidget(
                    title: 'I\'m Having a Craving',
                    iconName: 'psychology',
                    color: AppTheme.moodAnxious,
                    onTap: _showCravingModal,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            
            // Distraction Suggestions
            Text(
              'Distraction Suggestions',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            SizedBox(
              height: 15.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _getDistractionSuggestions().map((suggestion) {
                  return Padding(
                    padding: EdgeInsets.only(right: 3.w),
                    child: DistractionSuggestionWidget(
                      title: suggestion['title'],
                      description: suggestion['description'],
                      iconName: suggestion['iconName'],
                      color: suggestion['color'],
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 4.h),
            
            // Today's Summary
            Text(
              'Today\'s Summary',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            TodaySummaryWidget(
              cigarettesLogged: cigarettesLoggedToday,
              cravingsManaged: cravingsManagedToday,
            ),
            SizedBox(height: 2.h),
          ],
        ),
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

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0, // Home is selected
      onTap: (index) {
        // Handle navigation to other screens
        if (index == 1) {
          Navigator.pushNamed(context, '/mood-journal-screen');
        } else if (index == 2) {
          Navigator.pushNamed(context, '/dashboard-screen');
        }
        // If index is 0, we're already on the home screen
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