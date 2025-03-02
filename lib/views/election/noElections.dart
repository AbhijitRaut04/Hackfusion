import 'package:flutter/material.dart';

class NoElections extends StatefulWidget {
  const NoElections({super.key});

  @override
  State<NoElections> createState() => _NoElectionsState();
}

class _NoElectionsState extends State<NoElections> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Elections"),),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Text("No Ongoing Elections!",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}
