class DiseasePrediction {
  final String name;
  final String disease;
  final double confidence;
  final List<String> givenSymptoms;
  final List<String> topSymptoms;
  final List<String> potentialCauses;
  final TreatmentPlan treatmentPlan;

  DiseasePrediction({
    required this.name,
    required this.disease,
    required this.confidence,
    required this.givenSymptoms,
    required this.topSymptoms,
    required this.potentialCauses,
    required this.treatmentPlan,
  });

  static List<String> ensureList(dynamic value) {
    if (value is List) {
      return List<String>.from(value.map((item) => item.toString()));
    } else if (value is String) {
      return [value];
    } else {
      return [];
    }
  }

  factory DiseasePrediction.fromJson(Map<String, dynamic> json) {
    return DiseasePrediction(
      name: json['name'] ?? 'Unknown',
      disease: json['disease'] ?? 'Unknown',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      givenSymptoms: ensureList(json['symptoms']),
      topSymptoms: ensureList(json['other_possible_symptoms']),
      potentialCauses: ensureList(json['potential_causes']),
      treatmentPlan: TreatmentPlan.fromJson(json['treatment_plan'] ?? {}),
    );
  }
}

class TreatmentPlan {
  final List<String> immediateActions;
  final List<String> longTermManagement;
  final List<String> preventiveMeasures;

  TreatmentPlan({
    required this.immediateActions,
    required this.longTermManagement,
    required this.preventiveMeasures,
  });

  static List<String> ensureList(dynamic value) {
    if (value is List) {
      return List<String>.from(value.map((item) => item.toString()));
    } else if (value is String) {
      return [value];
    } else {
      return [];
    }
  }

  factory TreatmentPlan.fromJson(Map<String, dynamic> json) {
    return TreatmentPlan(
      immediateActions: ensureList(json['immediate_actions']),
      longTermManagement: ensureList(json['long_term_management']),
      preventiveMeasures: ensureList(json['preventive_measures']),
    );
  }

  toMap() {}
}
