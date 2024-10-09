import 'dart:io';

import 'package:ai_fitness_trainer/services/mongodb_service.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _genderController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  int _step = 0;

  late CameraController _cameraController;
  late List<CameraDescription> cameras;
  bool _isCameraInitialized = false;
  String? _capturedImagePath;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  void initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[1], ResolutionPreset.high);
    await _cameraController.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _captureFace() async {
    final XFile file = await _cameraController.takePicture();
    setState(() {
      _capturedImagePath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Stepper(
        currentStep: _step,
        onStepContinue: () {
          setState(() {
            if (_step < 7) _step++;
          });
          if (_step == 7) _registerUser();
        },
        onStepCancel: () {
          setState(() {
            if (_step > 0) _step--;
          });
        },
        steps: [
          Step(
            title: Text('Name'),
            content: TextField(
              controller: _nameController,
              decoration:
                  InputDecoration(labelText: 'What should we call you?'),
            ),
          ),
          Step(
            title: Text('Birthdate'),
            content: TextField(
              controller: _birthdateController,
              decoration: InputDecoration(labelText: 'Enter your birthdate'),
            ),
          ),
          Step(
            title: Text('Gender'),
            content: TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Enter your gender'),
            ),
          ),
          Step(
            title: Text('Weight'),
            content: TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Enter your weight'),
            ),
          ),
          Step(
            title: Text('Height'),
            content: TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Enter your height'),
            ),
          ),
          Step(
            title: Text('Email'),
            content: TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Enter your email'),
            ),
          ),
          Step(
            title: Text('Password'),
            content: TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Enter your password'),
              obscureText: true,
            ),
          ),
          Step(
            title: Text('Capture Face'),
            content: _isCameraInitialized
                ? Column(
                    children: [
                      AspectRatio(
                        aspectRatio: _cameraController.value.aspectRatio,
                        child: CameraPreview(_cameraController),
                      ),
                      ElevatedButton(
                        onPressed: _captureFace,
                        child: Text('Capture Face'),
                      ),
                      if (_capturedImagePath != null)
                        Image.file(
                          File(_capturedImagePath!),
                          height: 100,
                          width: 100,
                        ),
                    ],
                  )
                : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  void _registerUser() async {
    var userData = {
      'name': _nameController.text,
      'birthdate': _birthdateController.text,
      'gender': _genderController.text,
      'weight': _weightController.text,
      'height': _heightController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'face_image_path': _capturedImagePath, // Add captured face image path
    };
    await MongoDBService.insertUser(userData);
  }
}
