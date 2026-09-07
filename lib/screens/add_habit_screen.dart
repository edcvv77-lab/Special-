import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../services/notification_service.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  TimeOfDay _selectedTime = TimeOfDay.now();
  final List<int> _selectedDays = [];
  int _importance = 3;
  bool _isLoading = false;

  final Map<int, String> _daysMap = {
    1: 'الاثنين', 2: 'الثلاثاء', 3: 'الأربعاء',
    4: 'الخميس', 5: 'الجمعة', 6: 'السبت', 7: 'الأحد'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة عادة جديدة')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم العادة',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'يرجى إدخال اسم العادة' : null,
              ),
              const SizedBox(height: 24),
              ListTile(
                title: const Text('الوقت'),
                subtitle: Text(_selectedTime.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (time != null) {
                    setState(() => _selectedTime = time);
                  }
                },
              ),
              const Divider(),
              const SizedBox(height: 12),
              const Text('الأيام', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: _daysMap.entries.map((entry) {
                  final isSelected = _selectedDays.contains(entry.key);
                  return FilterChip(
                    label: Text(entry.value),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedDays.add(entry.key);
                        } else {
                          _selectedDays.remove(entry.key);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              const Text('مستوى الأهمية (1-5)', style: TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: _importance.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: _importance.toString(),
                onChanged: (val) => setState(() => _importance = val.toInt()),
              ),
              const SizedBox(height: 32),
              _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() && _selectedDays.isNotEmpty) {
                        setState(() => _isLoading = true);

                        final habitId = const Uuid().v4();
                        final habit = Habit(
                          id: habitId,
                          name: _nameController.text,
                          time: _selectedTime,
                          days: _selectedDays,
                          importance: _importance,
                        );

                        await context.read<HabitProvider>().addHabit(habit);

                        // Schedule notification
                        await NotificationService().scheduleHabitNotification(
                          id: habitId.hashCode,
                          title: 'تذكير بالعادة',
                          body: 'حان وقت: \${habit.name}',
                          hour: habit.time.hour,
                          minute: habit.time.minute,
                        );

                        if (mounted) Navigator.pop(context);
                      } else if (_selectedDays.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('يرجى اختيار يوم واحد على الأقل')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: const Text('حفظ العادة', style: TextStyle(fontSize: 18)),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
