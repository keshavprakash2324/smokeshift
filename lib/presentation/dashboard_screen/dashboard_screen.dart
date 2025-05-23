import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/date_range_selector_widget.dart';
import './widgets/mood_chart_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/stats_card_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedDateRange = 'Week';
  bool isLoading = true;
  bool hasError = false;
  Map<String, dynamic>? dashboardData;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This would refresh data when returning to this tab in a real app
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      // Mock data loading
      final data = _getMockDashboardData();
      
      setState(() {
        dashboardData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Map<String, dynamic> _getMockDashboardData() {
    return {
      "stats": {
        "daysSmokeFreeSinceStart": 12,
        "cravingsResisted": 37,
        "cigarettesAvoided": 84,
        "moneySaved": 42.00
      },
      "moodTrend": [
        {"date": "Mon", "value": 3.2},
        {"date": "Tue", "value": 3.5},
        {"date": "Wed", "value": 3.8},
        {"date": "Thu", "value": 4.0},
        {"date": "Fri", "value": 3.7},
        {"date": "Sat", "value": 4.2},
        {"date": "Sun", "value": 4.5}
      ],
      "recentActivity": [
        {
          "id": 1,
          "type": "craving_resisted",
          "timestamp": "2023-06-10T14:30:00Z",
          "mood": "Relaxed",
          "notes": "Went for a walk instead"
        },
        {
          "id": 2,
          "type": "mood_logged",
          "timestamp": "2023-06-10T10:15:00Z",
          "mood": "Energetic",
          "notes": "Morning coffee without cigarette"
        },
        {
          "id": 3,
          "type": "craving_resisted",
          "timestamp": "2023-06-09T19:45:00Z",
          "mood": "Anxious",
          "notes": "After dinner craving, did deep breathing"
        },
        {
          "id": 4,
          "type": "mood_logged",
          "timestamp": "2023-06-09T12:30:00Z",
          "mood": "Stressed",
          "notes": "Work deadline approaching"
        },
        {
          "id": 5,
          "type": "craving_resisted",
          "timestamp": "2023-06-08T08:20:00Z",
          "mood": "Relaxed",
          "notes": "Morning routine, had tea instead"
        }
      ]
    };
  }

  void _onDateRangeChanged(String range) {
    setState(() {
      selectedDateRange = range;
      isLoading = true;
    });
    _loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: AppTheme.lightTheme.textTheme.headlineMedium,
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    if (hasError) {
      return _buildErrorState();
    }

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DateRangeSelectorWidget(
              selectedRange: selectedDateRange,
              onRangeChanged: _onDateRangeChanged,
            ),
            SizedBox(height: 3.h),
            Text(
              'Your Progress',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            _buildStatsSection(),
            SizedBox(height: 4.h),
            Text(
              'Mood Improvement',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            _buildMoodChartSection(),
            SizedBox(height: 4.h),
            Text(
              'Recent Activity',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            _buildRecentActivitySection(),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    if (isLoading) {
      return _buildStatsSkeletonLoader();
    }

    if (dashboardData == null || dashboardData!['stats'] == null) {
      return _buildEmptyState(
        'No stats available yet',
        'Start tracking your journey to see your progress here.',
      );
    }

    final stats = dashboardData!['stats'];
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatsCardWidget(
                title: 'Days Smoke-Free',
                value: stats['daysSmokeFreeSinceStart'].toString(),
                icon: 'calendar_today',
                color: AppTheme.primary,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: StatsCardWidget(
                title: 'Cravings Resisted',
                value: stats['cravingsResisted'].toString(),
                icon: 'thumb_up',
                color: AppTheme.success,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: StatsCardWidget(
                title: 'Cigarettes Avoided',
                value: stats['cigarettesAvoided'].toString(),
                icon: 'smoke_free',
                color: AppTheme.info,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: StatsCardWidget(
                title: 'Money Saved',
                value: '\$${stats['moneySaved'].toStringAsFixed(2)}',
                icon: 'savings',
                color: AppTheme.moodRelaxed,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSkeletonLoader() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildSkeletonCard()),
            SizedBox(width: 4.w),
            Expanded(child: _buildSkeletonCard()),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(child: _buildSkeletonCard()),
            SizedBox(width: 4.w),
            Expanded(child: _buildSkeletonCard()),
          ],
        ),
      ],
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      height: 12.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildMoodChartSection() {
    if (isLoading) {
      return Container(
        height: 25.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }

    if (dashboardData == null || dashboardData!['moodTrend'] == null || (dashboardData!['moodTrend'] as List).isEmpty) {
      return _buildEmptyState(
        'No mood data yet',
        'Log your mood daily to see how you\'re improving over time.',
      );
    }

    return MoodChartWidget(
      moodData: List<Map<String, dynamic>>.from(dashboardData!['moodTrend']),
    );
  }

  Widget _buildRecentActivitySection() {
    if (isLoading) {
      return Container(
        height: 30.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }

    if (dashboardData == null || dashboardData!['recentActivity'] == null || (dashboardData!['recentActivity'] as List).isEmpty) {
      return _buildEmptyState(
        'No activity recorded yet',
        'Your recent actions will appear here as you use the app.',
      );
    }

    return RecentActivityWidget(
      activities: List<Map<String, dynamic>>.from(dashboardData!['recentActivity']),
    );
  }

  Widget _buildEmptyState(String title, String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.lightTheme.colorScheme.outline),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'hourglass_empty',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            message,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
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
              'We couldn\'t load your dashboard data. Please check your connection and try again.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: _loadDashboardData,
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

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 2, // Dashboard is selected
      onTap: (index) {
        // Handle navigation to other screens
        if (index == 0) {
          Navigator.pushNamed(context, '/home-screen');
        } else if (index == 1) {
          Navigator.pushNamed(context, '/mood-journal-screen');
        }
        // If index is 2, we're already on the dashboard screen
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