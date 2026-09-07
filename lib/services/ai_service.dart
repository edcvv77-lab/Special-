import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  Future<List<String>> generateRoutine(List<String> goals) async {
    // In a real app, do not hardcode the API key, fetch it from remote config or secure storage.
    // Assuming a placeholder or environment variable would go here.
    const apiKey = 'MOCK_API_KEY_OR_USE_ENV';

    if (goals.isEmpty) {
      return ['حاول تحديد أهدافك أولاً للحصول على روتين مخصص!'];
    }

    try {
      // Mocking the behavior for safety/compilation since we do not have a real API key provided.
      // If a real key was provided, we would use:
      // final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
      // final content = [Content.text("اقترح 5 عادات يومية بناءً على الأهداف التالية: \${goals.join(', ')}")];
      // final response = await model.generateContent(content);
      // return response.text?.split('\n') ?? [];

      await Future.delayed(const Duration(seconds: 2));
      List<String> suggestions = [];
      if (goals.contains('الصحة')) suggestions.addAll(['شرب كوبين من الماء عند الاستيقاظ', 'ممارسة الرياضة لمدة 20 دقيقة']);
      if (goals.contains('الدراسة')) suggestions.addAll(['دراسة مركزة لمدة 45 دقيقة (تقنية بومودورو)', 'مراجعة الملاحظات قبل النوم']);
      if (goals.contains('الإنتاجية')) suggestions.addAll(['تخطيط مهام اليوم التالي مساءً', 'إنجاز أصعب مهمة أولاً (أكل الضفدع)']);
      if (goals.contains('الدين')) suggestions.addAll(['أداء الصلوات في وقتها', 'قراءة ورد يومي من القرآن']);
      if (goals.contains('تطوير الذات')) suggestions.addAll(['قراءة 10 صفحات من كتاب مفيد', 'الاستماع لبودكاست تطويري']);

      suggestions.shuffle();
      return suggestions.take(5).toList();
    } catch (e) {
      print('AI Error: \$e');
      return ['عذراً، حدث خطأ أثناء جلب الاقتراحات الذكية.'];
    }
  }
}
