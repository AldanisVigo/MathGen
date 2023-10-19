import 'package:coursegen/problems.dart';
import 'package:flutter/material.dart';

class Subjects extends StatelessWidget{
  Subjects({super.key});

  final Map<String,List<String>> subjects = {
    "PreCalculus" : [
      "precalc_identifying_and_evaluating_functions",
      "precalc_domain_and_range_of_functions"
    ]
  };

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Subject", style: TextStyle(fontWeight: FontWeight.bold))
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: subjects.keys.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // number of items in each row
            mainAxisSpacing: 8.0, // spacing between rows
            crossAxisSpacing: 8.0, // spacing between columns
          ), 
          itemBuilder:(context, index) => ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 200,
              width: 200,
              child: GestureDetector(
                onTap: (){
                  MaterialPageRoute route = MaterialPageRoute(builder:(context) => Problems(course: subjects.keys.elementAt(index),topics: subjects[subjects.keys.elementAt(index)] ?? []));
                  Navigator.of(context).push(route);
                },
                child: GridTile(
                  child: Container(
                    color: Colors.black,
                    child: Center(child: Text(subjects.keys.elementAt(index), textAlign: TextAlign.center,style: const TextStyle(color: Colors.white)))
                  ),
                ),
              ),
            ),
          )
        )
      ),
    );
  }
}