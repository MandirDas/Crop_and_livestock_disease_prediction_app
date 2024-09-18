class DiagnosticData {
  static final List<String> subjectTypes = ['Plant', 'Animal'];

  static final Map<String, List<String>> commonSubjects = {
    'Plant': ['Tomato', 'Rose', 'Cucumber', 'Sunflower', 'Other'],
    'Animal': ['Cow', 'Goat', 'Sheep', 'Pig', 'Other'],
  };

  static final Map<String, List<String>> commonSymptoms = {
    'Plant': [
      'Yellowing leaves',
      'Wilting',
      'Spots on leaves',
      'Stunted growth',
      'Leaf curling',
      'Unusual odor',
    ],
    'Animal': [
      'Loss of appetite',
      'Lethargy',
      'Unusual droppings',
      'Coughing',
      'Sneezing',
      'Limping',
      'Hair loss',
    ],
  };

  static final List<String> environmentTypes = [
    'Indoor',
    'Outdoor',
    'Mixed',
  ];

  static final List<String> ageRanges = [
    'Young',
    'Adult',
    'Senior',
  ];

  static String getDiagnosis(String subjectType, String subjectName,
      List<String> symptoms, String environment, String age) {
    // This is a placeholder function. In a real application, you'd have a more
    // sophisticated algorithm or API call to determine the diagnosis.
    String diagnosis =
        'Based on the provided information for $subjectName ($subjectType):\n\n';

    if (subjectType == 'Plant') {
      if (symptoms.contains('Yellowing leaves') &&
          symptoms.contains('Wilting')) {
        diagnosis +=
            'Possible overwatering or root rot. Ensure proper drainage and reduce watering frequency.';
      } else if (symptoms.contains('Spots on leaves')) {
        diagnosis +=
            'Potential fungal infection. Consider applying a fungicide and improving air circulation.';
      }
    } else if (subjectType == 'Animal') {
      if (symptoms.contains('Loss of appetite') &&
          symptoms.contains('Lethargy')) {
        diagnosis +=
            'Could be a sign of infection or stress. Monitor closely and consult a veterinarian if symptoms persist.';
      } else if (symptoms.contains('Coughing') ||
          symptoms.contains('Sneezing')) {
        diagnosis +=
            'Possible respiratory infection. Keep the animal warm and seek veterinary advice.';
      }
    }

    if (diagnosis ==
        'Based on the provided information for $subjectName ($subjectType):\n\n') {
      diagnosis +=
          'A specific diagnosis cannot be determined. Please consult with a professional for a thorough examination.';
    }

    diagnosis += '\n\nEnvironment: $environment\nAge: $age';

    return diagnosis;
  }

  static Map<String, String> getCauseAndTreatment(String diagnosis) {
    // This is a placeholder. In a real application, you'd have a more
    // sophisticated system to determine causes and treatments based on the diagnosis.
    switch (diagnosis) {
      case 'Possible overwatering or root rot':
        return {
          'causes':
              '• Excessive watering\n• Poor drainage\n• Fungal infection in the roots',
          'treatments':
              '• Reduce watering frequency\n• Improve soil drainage\n• Consider repotting with fresh, well-draining soil\n• Apply fungicide if root rot is suspected',
        };
      case 'Potential fungal infection':
        return {
          'causes':
              '• Fungal spores in the environment\n• High humidity\n• Poor air circulation',
          'treatments':
              '• Remove affected leaves\n• Improve air circulation\n• Apply appropriate fungicide\n• Avoid overhead watering',
        };
      // Add more cases as needed
      default:
        return {
          'causes': 'Unable to determine specific causes for this diagnosis.',
          'treatments':
              'Please consult with a professional for appropriate treatment options.',
        };
    }
  }
}
