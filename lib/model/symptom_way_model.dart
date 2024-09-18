class DiseaseResponse {
  final String disease;
  final double confidence;
  final String diagnosis;
  final List<String> possibleTreatment;
  final List<String> possibleCauses;
  final String name;
  final String location;
  final List<String> symptoms;
  final String environment;
  final String age;

  DiseaseResponse({
    required this.disease,
    required this.confidence,
    required this.diagnosis,
    required this.possibleTreatment,
    required this.possibleCauses,
    required this.name,
    required this.location,
    required this.symptoms,
    required this.environment,
    required this.age,
  });

  factory DiseaseResponse.fromJson(Map<String, dynamic> json) {
    return DiseaseResponse(
      disease: json['disease'],
      confidence: json['confidence'].toDouble(),
      diagnosis: json['diagnosis'],
      possibleTreatment: List<String>.from(json['possible_treatment']),
      possibleCauses: List<String>.from(json['possible_causes']),
      name: json['name'],
      location: json['location'],
      symptoms: List<String>.from(json['symptoms']),
      environment: json['environment'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disease': disease,
      'confidence': confidence,
      'diagnosis': diagnosis,
      'possible_treatment': possibleTreatment,
      'possible_causes': possibleCauses,
      'name': name,
      'location': location,
      'symptoms': symptoms,
      'environment': environment,
      'age': age,
    };
  }
}

class DiseaseInput {
  final String name;
  final String location;
  final List<String> symptoms;
  final String environment;
  final String age;

  DiseaseInput({
    required this.name,
    required this.location,
    required this.symptoms,
    required this.environment,
    required this.age,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'symptoms': symptoms,
      'environment': environment,
      'age': age,
    };
  }
}
