import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<String> availableGoals = [
    'الصحة',
    'الدراسة',
    'الإنتاجية',
    'الدين',
    'تطوير الذات',
  ];

  final List<String> selectedGoals = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('أهدافك')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'اختر أهدافك للبدء في بناء عاداتك:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: availableGoals.length,
                itemBuilder: (context, index) {
                  final goal = availableGoals[index];
                  final isSelected = selectedGoals.contains(goal);
                  return CheckboxListTile(
                    title: Text(goal),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedGoals.add(goal);
                        } else {
                          selectedGoals.remove(goal);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await context.read<AuthProvider>().updateGoals(selectedGoals);
                if (mounted) {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('متابعة', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
