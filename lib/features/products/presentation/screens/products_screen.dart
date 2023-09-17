import 'package:articles_flutter/features/shared/widgets/side_menu.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    
    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey,),
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: const Center(
        child: Text('Products Screen'),
      ),
    );
  }
}