

import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
static const routeName='product-detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Detail"),),
      body: Center(

        child: Text('Produt Detail'),
      ),
      
    );
  }
}