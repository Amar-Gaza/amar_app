import 'package:amar_bot/src/texts.dart';
import 'package:amar_bot/src/vision.dart';

/// Prints a sample diagnosis reply (dart run tool/diag_preview.dart).
void main() {
  final d = Diagnosis.fromJson({
    'is_relevant': true,
    'category': 'شوادر وخيم',
    'what_i_see': 'خيمة شادرها ممزّق من الجنب',
    'problem': 'الشادر قديم وممزّق، المي رح تدخل.',
    'severity': 'عاجل',
    'technician': 'فني تركيب شوادر وخيم',
    'materials': ['شادر مقوّى', 'حبال'],
    'inspection_reason': 'المقاس بيحدد الكمية',
    'tips': ['غطّي الفتحة بنايلون'],
    'questions': ['شو مقاس الخيمة؟'],
  });
  print(T.diagnosis(d));
}
