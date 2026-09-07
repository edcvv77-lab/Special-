import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/habit.dart';
import '../providers/habit_provider.dart';

class HabitLibraryScreen extends StatelessWidget {
  const HabitLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> libraryHabits = [
      {'name': 'شرب الماء', 'importance': 4},
      {'name': 'قراءة أذكار الصباح', 'importance': 5},
      {'name': 'المشي 30 دقيقة', 'importance': 4},
      {'name': 'القراءة لمدة 15 دقيقة', 'importance': 3},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('مكتبة العادات')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: libraryHabits.length,
        itemBuilder: (context, index) {
          final habitData = libraryHabits[index];
          return Card(
            child: ListTile(
              title: Text(habitData['name']),
              subtitle: Text('أهمية: ${habitData['importance']}'),
              trailing: IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.green),
                onPressed: () async {
                  final newHabit = Habit(
                    id: const Uuid().v4(),
                    name: habitData['name'],
                    time: TimeOfDay.now(),
                    days: [1, 2, 3, 4, 5, 6, 7], // Every day
                    importance: habitData['importance'],
                  );
                  await context.read<HabitProvider>().addHabit(newHabit);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم إضافة "${habitData['name']}" بنجاح!')),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
