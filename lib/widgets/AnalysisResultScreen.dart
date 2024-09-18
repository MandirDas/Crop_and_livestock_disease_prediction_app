import 'dart:io';
import 'package:FarmVeda/model/camera_way_model.dart';
import 'package:FarmVeda/widgets/cause_screen.dart';
import 'package:FarmVeda/widgets/pie_chart.dart';
import 'package:FarmVeda/widgets/treatment_page.dart';
import 'package:flutter/material.dart';
import 'package:FarmVeda/services/api_service.dart';
import 'package:flutter/services.dart';
// import 'package:frontend/models/disease_prediction.dart';

class AnalysisResultScreen extends StatefulWidget {
  final File image;
  final String plantName;
  final List<String> symptoms_user;

  AnalysisResultScreen({
    required this.image,
    required this.plantName,
    required this.symptoms_user,
  });

  @override
  _AnalysisResultScreenState createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  bool _isLoading = true;
  bool _isResizing = true;
  DiseasePrediction? _prediction;
  String? _error;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _checkImageAndPerformAnalysis();
  }

  Future<void> _checkImageAndPerformAnalysis() async {
    if (await widget.image.exists()) {
      print('Image exists at path: ${widget.image.path}');
      _performAnalysis();
    } else {
      setState(() {
        _error = 'Image file does not exist at path: ${widget.image.path}';
        _isLoading = false;
      });
    }
  }

  Future<void> _performAnalysis() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      print('Image path: ${widget.image.path}');
      print('Plant name: ${widget.plantName}');
      print('Symptoms: ${widget.symptoms_user}');

      final prediction = await _apiService.predictDisease(
          widget.image.path, widget.plantName, widget.symptoms_user);
      setState(() {
        _prediction = prediction;
        _isLoading = false;
      });
    } catch (e) {
      print('Error during analysis: $e');
      setState(() {
        _error = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBody:
            true, // This allows the body to extend behind the bottom app bar
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Analysis Result', style: TextStyle(color: Colors.white)),
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
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 20),
                        Text(
                          _isResizing ? 'Optimizing image...' : 'Analyzing...',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : _error != null
                    ? _buildErrorWidget()
                    : _prediction != null
                        ? _buildResultWidget()
                        : Center(
                            child: Text('No prediction available',
                                style: TextStyle(color: Colors.white))),
          ),
        ),
        bottomNavigationBar: _buildBottomAppBar(),
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _buildActionButton('Cause', () {
                if (_prediction == null) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('No Cause Available'),
                      content:
                          Text('The cause is not available for this disease.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CauseScreen(
                            potentialCauses: _prediction!.potentialCauses)),
                  );
                }
              }),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildActionButton('Treatment', () {
                if (_prediction == null) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('No Treatment Plan Available'),
                      content: Text(
                          'The treatment plan is not available for this disease.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TreatmentScreen(
                            immediateActions:
                                _prediction!.treatmentPlan.immediateActions,
                            longTermManagement:
                                _prediction!.treatmentPlan.longTermManagement,
                            preventiveMeasures:
                                _prediction!.treatmentPlan.preventiveMeasures)),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 60),
            SizedBox(height: 16),
            Text(
              'An error occurred during analysis:',
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              _error ?? 'Unknown error',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _performAnalysis();
              },
              child: Text('Retry'),
              style: ElevatedButton.styleFrom(
                primary: Colors.white.withOpacity(0.3),
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultWidget() {
    if (_prediction == null) {
      return Center(
          child: Text('No prediction data available',
              style: TextStyle(color: Colors.white)));
    }
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(widget.image),
          ),
          SizedBox(height: 20),
          _buildResultContainer(),
          SizedBox(height: 20),
          // SizedBox(height: 20),
          // _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildResultContainer() {
    final TextStyle headerStyle = TextStyle(
      fontSize: 24, // Increased from 18
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    final TextStyle contentStyle = TextStyle(
      fontSize: 18, // Increased from default (usually 14)
      color: Colors.white,
    );
    final TextStyle subHeaderStyle = TextStyle(
      fontSize: 20, // New style for sub-headers
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Analysis Result:', style: headerStyle),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('Type: ${widget.plantName}', style: contentStyle),
              ),
              Row(
                children: [
                  CustomPieChart(confidence: _prediction!.confidence),
                  SizedBox(width: 8),
                  Text(
                    '${(_prediction!.confidence * 100).toStringAsFixed(1)}%',
                    style: contentStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Text('Condition: ${_prediction!.disease}', style: contentStyle),
          SizedBox(height: 16),
          Text('Given Symptoms:', style: subHeaderStyle),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _prediction!.givenSymptoms.isNotEmpty
                ? _prediction!.givenSymptoms
                    .map((symptom) => Text(
                          '• $symptom',
                          style: contentStyle,
                        ))
                    .toList()
                : [Text('No symptoms provided', style: contentStyle)],
          ),
          SizedBox(height: 16),
          Text('Possible Symptoms:', style: subHeaderStyle),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _prediction!.topSymptoms.isNotEmpty
                ? _prediction!.topSymptoms
                    .map((symptom) => Text(
                          '• $symptom',
                          style: contentStyle,
                        ))
                    .toList()
                : [Text('No top symptoms available', style: contentStyle)],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        primary: Colors.white.withOpacity(0.3),
        onPrimary: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
