import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../providers/auth_provider.dart';
import '../providers/habit_provider.dart';
import 'add_habit_screen.dart';
import 'statistics_screen.dart';
import 'habit_library_screen.dart';
import 'ai_assistant_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final habitProvider = context.watch<HabitProvider>();
    final todayHabits = habitProvider.todayHabits;
    final completionRate = habitProvider.completionRate;

    return Scaffold(
      appBar: AppBar(
        title: Text('مرحباً، ${user?.name ?? ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StatisticsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.library_books),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HabitLibraryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.assistant),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AiAssistantScreen()),
              );
            },
          ),
        ],
      ),
      body: habitProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProgressCard(context, completionRate, user?.points ?? 0, user?.level ?? 1),
                const SizedBox(height: 24),
                const Text(
                  'مهام اليوم',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: todayHabits.isEmpty
                      ? const Center(child: Text('لا توجد عادات لليوم. أضف عادة جديدة!'))
                      : ListView.builder(
                          itemCount: todayHabits.length,
                          itemBuilder: (context, index) {
                            final habit = todayHabits[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                title: Text(
                                  habit.name,
                                  style: TextStyle(
                                    decoration: habit.isCompletedToday
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                subtitle: Text('${habit.time.format(context)} • أهمية: ${habit.importance}'),
                                trailing: Checkbox(
                                  value: habit.isCompletedToday,
                                  onChanged: (_) {
                                    // Pass authProvider to reward points
                                    context.read<HabitProvider>().toggleHabitCompletion(habit.id, authProvider);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    _showWhatToDoNowDialog(context, todayHabits);
                  },
                  icon: const Icon(Icons.lightbulb_outline),
                  label: const Text('ماذا أفعل الآن؟'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddHabitScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, double rate, int points, int level) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 8.0,
              percent: rate,
              center: Text('${(rate * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
              progressColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('نسبة الإنجاز اليومية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('المستوى: \$level  |  النقاط: \$points', style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blueGrey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWhatToDoNowDialog(BuildContext context, List<dynamic> habits) {
    final uncompleted = habits.where((h) => !h.isCompletedToday).toList();
    String suggestion = 'خذ استراحة قصيرة واشرب كوباً من الماء!';

    if (uncompleted.isNotEmpty) {
      suggestion = 'ما رأيك في إنجاز: ${uncompleted.first.name}؟';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اقتراح سريع'),
        content: Text(suggestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}
