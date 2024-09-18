import 'package:flutter/material.dart';
import 'package:FarmVeda/shared/data.dart';
import 'package:FarmVeda/views/ui/symptom_diagnosis.dart';
import 'package:FarmVeda/services/api_service.dart';

class DiagnosisPage extends StatefulWidget {
  @override
  _DiagnosisPageState createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  String _name = '';
  String _location = '';
  List<String> _selectedSymptoms = [];
  String _environment = '';
  String _age = '';
  List<String> _additionalSymptoms = [];
  final TextEditingController _otherSymptomsController =
      TextEditingController();

  Map<String, dynamic>? _diagnosisResult;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    print('Name: $_name');
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      List<String> allSymptoms = [..._selectedSymptoms, ..._additionalSymptoms];
      final context = this.context; // Store context in a local variable

      setState(() {
        _isLoading = true;
      });
      print('Name: $_name');

      try {
        final result = await _apiService.predictDiseaseFromSymptoms(
          name: _name, // Make sure this line is included
          location: _location,
          symptoms: allSymptoms,
          environment: _environment,
          age: _age,
        );

        setState(() {
          _diagnosisResult = result;
          _isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CauseAndTreatmentPage(
              subjectType: _name,
              subjectName: _name,
              diagnosis: _diagnosisResult!['diagnosis'],
              disease: _diagnosisResult!['disease'],
              confidence: _diagnosisResult!['confidence'],
              possibleTreatment:
                  List<String>.from(_diagnosisResult!['possible_treatment']),
              possibleCauses:
                  List<String>.from(_diagnosisResult!['possible_causes']),
              isLoading: false,
            ),
          ),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  void _addAdditionalSymptom() {
    setState(() {
      if (_otherSymptomsController.text.isNotEmpty) {
        _additionalSymptoms.add(_otherSymptomsController.text);
        _otherSymptomsController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Diagnosis Form',
            style: TextStyle(color: Colors.white),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade300, Colors.purple.shade300],
                ),
              ),
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.all(24.0),
                    children: [
                      _buildTextField(
                        label: 'Name',
                        onSaved: (value) {
                          _name = value!;
                          print('Name: $_name');
                        },
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                          print('Name changed: $_name');
                        },
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        label: 'Location',
                        onSaved: (value) {
                          _location = value!;
                          print('Location: $_location');
                        },
                      ),
                      SizedBox(height: 16),
                      _buildDropdown(
                        value: _environment,
                        items: DiagnosticData.environmentTypes,
                        onChanged: (String? newValue) {
                          setState(() => _environment = newValue!);
                        },
                        label: 'Environment',
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        label: 'Age',
                        onSaved: (value) {
                          _age = value!;
                          print('Age: $_age');
                        },
                        onChanged: (value) {
                          setState(() {
                            _age = value;
                          });
                          print('Age changed: $_age');
                        },
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Symptoms',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      ..._buildSymptomsList(),
                      SizedBox(height: 16),
                      Text(
                        'Additional Symptoms',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _otherSymptomsController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter other symptoms',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.2),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _addAdditionalSymptom,
                            child: Text('Add'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _additionalSymptoms
                            .map((symptom) => Chip(
                                  label: Text(symptom,
                                      style: TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.blue.shade300,
                                  onDeleted: () {
                                    setState(() {
                                      _additionalSymptoms.remove(symptom);
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        child: Text('Get Diagnosis'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white.withOpacity(0.2),
                          onPrimary: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: _submitForm,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 20),
                      Text(
                        'Analyzing...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required void Function(String?) onSaved,
    void Function(String)? onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.white),
        onSaved: onSaved,
        onChanged: onChanged,
        validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String label,
  }) {
    // Ensure that the value is null if it's not in the items list
    if (!items.contains(value)) {
      value = null;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide.none,
            ),
          ),
          dropdownColor: Colors.blue.shade300,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: onChanged,
          style: TextStyle(color: Colors.white),
          validator: (value) => value == null ? 'Please select $label' : null,
        ),
      ),
    );
  }

  List<Widget> _buildSymptomsList() {
    return DiagnosticData.commonSymptoms['Animal']!.map((symptom) {
      return Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: CheckboxListTile(
          title: Text(symptom, style: TextStyle(color: Colors.white)),
          value: _selectedSymptoms.contains(symptom),
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                _selectedSymptoms.add(symptom);
              } else {
                _selectedSymptoms.remove(symptom);
              }

              print('Selected symptoms: $_selectedSymptoms');
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: Colors.white,
          checkColor: Colors.blue.shade300,
        ),
      );
    }).toList();
  }
}
