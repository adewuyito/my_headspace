import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@routePage
class CreateAccountPage1 extends StatelessWidget {
  const CreateAccountPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [TextButton(onPressed: () {}, child: Text("Login"))],
      ),
      body: Column(children: [

        ],
      ),
    );
  }
}
