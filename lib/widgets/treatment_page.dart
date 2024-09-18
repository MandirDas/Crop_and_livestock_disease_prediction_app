import 'package:flutter/material.dart';

class TreatmentScreen extends StatelessWidget {
  final List<dynamic> immediateActions;
  final List<dynamic> longTermManagement;
  final List<dynamic> preventiveMeasures;

  TreatmentScreen({
    required this.immediateActions,
    required this.longTermManagement,
    required this.preventiveMeasures,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Treatment', style: TextStyle(color: Colors.white)),
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
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTreatmentSection('Immediate Actions', immediateActions),
                SizedBox(height: 16),
                _buildTreatmentSection(
                    'Long Term Management', longTermManagement),
                SizedBox(height: 16),
                _buildTreatmentSection(
                    'Preventive Measures', preventiveMeasures),
                SizedBox(height: 16),
                _buildAdditionalInfoContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTreatmentSection(String title, List<dynamic> steps) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: steps
                .map((step) => Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('• $step',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Information:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          _buildInfoItem(
            icon: Icons.warning,
            text: 'Early detection is crucial for effective management.',
          ),
          SizedBox(height: 8),
          _buildInfoItem(
            icon: Icons.eco,
            text:
                'Environmental factors can significantly influence disease development.',
          ),
          SizedBox(height: 8),
          _buildInfoItem(
            icon: Icons.repeat,
            text: 'Regular monitoring helps prevent widespread infection.',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
