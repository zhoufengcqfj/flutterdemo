
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/MultiProviderPage.dart';
import 'package:provider/provider.dart';

import 'MyCounter.dart';
import 'MySubtract.dart';

class MultiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Provider"),
      ),
      body:MultiProvider(
        providers: [
         ChangeNotifierProvider(create: (context)=>MyCounter()),
         ChangeNotifierProvider(create: (context)=>MySubtract()),
        ],
        child: MultiProvioderPage(),
      ),
    );
  }
}



