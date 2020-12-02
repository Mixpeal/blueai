import 'package:flutter/material.dart';

class Preload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      height: 85,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Blue AI',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Votre Préféré Personal Digital Assistant',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text('Developed by: Kayode Ojo (ADS20B00373Y)')),
          ),
        ],
      ),
    );
  }
}
