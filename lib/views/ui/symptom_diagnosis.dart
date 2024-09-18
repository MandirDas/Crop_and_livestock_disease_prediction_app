import 'package:flutter/material.dart';
import 'package:FarmVeda/widgets/pie_chart.dart'; // Make sure this import is correct
// import 'package:frontend/shared/data.dart';

class CauseAndTreatmentPage extends StatelessWidget {
  final String subjectType;
  final String subjectName;
  final String diagnosis;
  final String disease;
  final double confidence;
  final List<String> possibleTreatment;
  final List<String> possibleCauses;
  final bool isLoading;

  const CauseAndTreatmentPage({
    Key? key,
    required this.subjectType,
    required this.subjectName,
    required this.diagnosis,
    required this.disease,
    required this.confidence,
    required this.possibleTreatment,
    required this.possibleCauses,
    this.isLoading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Diagnosis Results', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade300, Colors.purple.shade300],
          ),
        ),
        child: SafeArea(
          
          child: isLoading
              ? Center(
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
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildResultContainer(),
                      SizedBox(height: 20),
                      _buildDiagnosisContainer(),
                      SizedBox(height: 20),
                      _buildTreatmentContainer(),
                      SizedBox(height: 20),
                      _buildCausesContainer(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildResultContainer() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analysis Result:',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('Disease: $disease',
                    style: TextStyle(color: Colors.white)),
              ),
              Row(
                children: [
                  CustomPieChart(confidence: confidence),
                  SizedBox(width: 8),
                  Text(
                    '${(confidence * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisContainer() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Diagnosis:',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(diagnosis, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildTreatmentContainer() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.medical_services, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Possible Treatment:',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 10),
          ...possibleTreatment.map((step) => Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(color: Colors.white)),
                    Expanded(
                        child:
                            Text(step, style: TextStyle(color: Colors.white))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCausesContainer() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.biotech, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Possible Causes:',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 10),
          ...possibleCauses.map((cause) => Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(color: Colors.white)),
                    Expanded(
                        child:
                            Text(cause, style: TextStyle(color: Colors.white))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
