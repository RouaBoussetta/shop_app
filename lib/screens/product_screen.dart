import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
 
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
         title: Text('Shop'),
      ),
      body: Center(
         child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            
            
          ],
        ),
      ),
       
    );
  }
}