import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../providers/auth_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final completionRate = context.watch<HabitProvider>().completionRate;
    final user = context.watch<AuthProvider>().user;
    final habits = context.watch<HabitProvider>().habits;

    // Top habit logic (most simple implementation based on importance for this prototype)
    String topHabit = 'لا يوجد بعد';
    if (habits.isNotEmpty) {
       habits.sort((a, b) => b.importance.compareTo(a.importance));
       topHabit = habits.first.name;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('الإحصائيات')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatCard(
              title: 'نسبة الالتزام اليومية',
              value: '${(completionRate * 100).toInt()}%',
              icon: Icons.pie_chart,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              title: 'الأيام المتتالية',
              value: '${user?.currentStreak ?? 0} أيام',
              icon: Icons.local_fire_department,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              title: 'أكثر العادات إنجازاً (مقدر)',
              value: topHabit,
              icon: Icons.star,
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color}) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        trailing: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
