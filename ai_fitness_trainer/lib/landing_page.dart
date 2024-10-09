import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Fitness Trainer'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              children: [
                Image.asset('assets/slide1.jpg'),
                Image.asset('assets/slide2.jpg'),
                Image.asset('assets/slide3.jpg'),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: Text('Get Started'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
