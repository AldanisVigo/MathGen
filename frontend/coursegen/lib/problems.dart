import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Problems extends StatefulWidget{
  final String course;
  final List<String> topics;

  const Problems({super.key, required this.course, required this.topics});

  @override
  State<StatefulWidget> createState() {
    return ProblemsState();
  }
}

class Problem {
  final String problem;
  final String answer;
  Problem({required this.problem, required this.answer});

  Problem.fromJson(Map<String,dynamic> json) :
    problem = json['problem'],
    answer = json['answer'];

  Map<String,dynamic> toJson()=> {
    "problem" : problem,
    "answer" : answer
  };
}

class ProblemsState extends State<Problems>{
  String selectedTopic = "";
  List<Problem> currentProblems = [];

  Future<List<Problem>> _getProblems() async {
    try{
      var response = await http.post(Uri.parse("http://127.0.0.1:3000/problems/${widget.course}/$selectedTopic/generate"), 
      headers: {
        "Content-Type" : "application/json"
      });

      if (response.statusCode == 200) {
          if(kDebugMode){
            print(response.body);
          }
      } else {
        if(kDebugMode){
          print('A network error occurred');
        }
      }
      List<dynamic> items = jsonDecode(response.body);
      if(kDebugMode){
        print(items);
      }
      List<Problem> problems = items.map((e)=>Problem.fromJson(e)).toList();
      if(kDebugMode){
        print(problems);
      }
      return problems;
    }catch(error){
      if(kDebugMode){
        print(error);
      }
      return Future.value([]);
    }
  }

  Future<void> initialize() async {
    try {
      List<Problem> problems = await _getProblems();
      
      setState((){
        currentProblems = problems;
      });
     
    }catch(error){
      if(kDebugMode){
        print(error);
      }
    }
  }

  @override
  void initState() {
    selectedTopic = widget.topics[0];
    initialize();
    super.initState();
  }

  List<DropdownMenuItem> _generateTopicOptions() => widget.topics.map((e) => DropdownMenuItem(value: e,child: Text(e.split('_').map((e){return "${e.substring(0,1).toUpperCase()}${e.substring(1)}";}).toList().reduce((value, element)=>value = "$value $element")))).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.course} Problems", style: const TextStyle(fontWeight: FontWeight.bold))
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text("Please Select ${widget.course} Topic"),
              DropdownButton(
                value: selectedTopic,
                items: _generateTopicOptions(), 
                onChanged: (value) async{
                  setState(() {
                    selectedTopic = value; // Change the selected topic
                    currentProblems = []; // Clear the current list of problems
                  });
        
                  // Get a new list of problems from OpenAI
                  List<Problem> probs = await _getProblems();
        
                  // Set the new list of problems
                  setState(() {
                    currentProblems = probs;
                  });
                }
              ),
              currentProblems.isNotEmpty ? _generateListOfProblemsUi(context, currentProblems) : _generatingProblemsUi(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              child: const Text("Generate New Problems"),
              onPressed: () async {
                setState(() {
                  currentProblems = []; // Clear the current list of problems
                });
      
                // Get a new list of problems from OpenAI
                List<Problem> probs = await _getProblems();
      
                // Set the new list of problems
                setState(() {
                  currentProblems = probs;
                });
              },
            )
          ],
        ),
      ),
    );   
  }
}

Widget _generateListOfProblemsUi(BuildContext context, List<Problem> currentProblems) => ListView.builder(
  physics: const NeverScrollableScrollPhysics(),
  shrinkWrap: true,
  itemCount: currentProblems.length,
  itemBuilder: (context, index){
    return ListTile(
      subtitle: Text(currentProblems[index].problem),
      trailing: IconButton(icon: const Icon(Icons.question_answer),onPressed: () async {
        _showAnswer(context, currentProblems, index);
      }),
      onTap: () async => await _showAnswer(context, currentProblems, index),
    );
  },
);

Widget _generatingProblemsUi(BuildContext context) => SizedBox(
  height: MediaQuery.of(context).size.height - 200,
  child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset('assets/lotties/brain.json'),
        const Text("AI Generating Problems, Please be patient.", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10,),
        const CircularProgressIndicator()
      ],
    ),
);

Future<dynamic> _showAnswer(BuildContext context, List<Problem> currentProblems, int index) async => await showDialog(context: context, builder:(context) => Dialog(
  child: Container(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        Expanded(flex: 1, child: Container()),
        const Text("Answer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35), textAlign: TextAlign.start,),
        Expanded(
          flex: 2,
          child: Text(currentProblems[index].answer, textAlign: TextAlign.center,),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              child: const Text("Close"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          )
        )
      ],
    ),
  )
));