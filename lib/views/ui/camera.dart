import 'dart:io';
import 'package:flutter/material.dart';
import 'package:FarmVeda/widgets/AnalysisResultScreen.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelectionScreen extends StatefulWidget {
  @override
  _ImageSelectionScreenState createState() => _ImageSelectionScreenState();
}

class _ImageSelectionScreenState extends State<ImageSelectionScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _symptomController = TextEditingController();
  List<String> _symptoms = [];

  Future<void> _getImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _addSymptom() {
    if (_symptomController.text.isNotEmpty) {
      setState(() {
        _symptoms.add(_symptomController.text);
        _symptomController.clear();
      });
    }
  }

  void _removeSymptom(int index) {
    setState(() {
      _symptoms.removeAt(index);
    });
  }

  void _navigateToAnalysisScreen() {
    if (_image != null && _nameController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnalysisResultScreen(
            image: _image!,
            plantName: _nameController.text,
            symptoms_user: _symptoms,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image and enter a name')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Select Image', style: TextStyle(color: Colors.white)),
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
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        controller: _nameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter plant or animal name',
                          hintStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildSymptomInput(),
                      SizedBox(height: 20),
                      _buildSymptomList(),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: _buildButton(
                              icon: Icons.camera_alt,
                              label: 'Camera',
                              onPressed: () => _getImage(ImageSource.camera),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildButton(
                              icon: Icons.photo_library,
                              label: 'Gallery',
                              onPressed: () => _getImage(ImageSource.gallery),
                            ),
                          ),
                        ],
                      ),
                      // _buildButton(
                      //   icon: Icons.camera_alt,
                      //   label: 'Take a Photo',
                      //   onPressed: () => _getImage(ImageSource.camera),
                      // ),
                      // SizedBox(height: 20),
                      // _buildButton(
                      //   icon: Icons.photo_library,
                      //   label: 'Choose from Gallery',
                      //   onPressed: () => _getImage(ImageSource.gallery),
                      // ),
                      SizedBox(height: 40),
                      _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(_image!, height: 200),
                            )
                          : Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.image,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                      SizedBox(height: 20),
                      Text(
                        _image != null ? 'Image Selected' : 'No image selected',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      _buildButton(
                        icon: Icons.send,
                        label: 'Analyze',
                        onPressed: _navigateToAnalysisScreen,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSymptomInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _symptomController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter symptom',
              hintStyle: TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: _addSymptom,
          child: Icon(Icons.add, color: Colors.white),
          style: ElevatedButton.styleFrom(
            primary: Colors.white.withOpacity(0.2),
            shape: CircleBorder(),
            padding: EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomList() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: _symptoms.isEmpty
          ? Center(
              child: Text(
                'No symptoms added',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: _symptoms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _symptoms[index],
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.white70),
                    onPressed: () => _removeSymptom(index),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 250,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(label),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.white.withOpacity(0.2),
          onPrimary: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _symptomController.dispose();
    super.dispose();
  }
}
