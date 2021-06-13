import 'dart:convert';
import 'package:flutter/material.dart';
import 'select_plan_page.dart';

import 'model/plan.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Plan Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InputPage(),
    );
  }
}

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  late TextEditingController _textEditingController;
  List<String> _functionList = [];
  String? errorMessage;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2)),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _textEditingController,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  late List<Plan> planList;
                  try {
                    planList =
                        convertJsonToPlanList(_textEditingController.text);

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => SelectPlanPage(planList, _functionList),
                      ),
                    );
                  } catch (e) {
                    showErrorMessage(e.toString());
                  }
                },
                child: Text('Submit'),
              ),
            ),
            const SizedBox(height: 20),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
          ],
        ),
      ),
    );
  }

  List<Plan> convertJsonToPlanList(String string) {
    final String planKey = 'plan', priceKey = 'price';

    // print(string);
    Map<String, dynamic> json;
    try {
      json = jsonDecode(string);
    } catch (e) {
      throw ("invaild json format");
    }

    // get Plan
    List<Plan> planList = convertPlan(json[planKey]);
    setPriceToPlan(planList, json[priceKey]);

    for (String key in json.keys) {
      // 'key' and 'price' are handled already
      if (key == planKey || key == priceKey) continue;

      // record all of the function, used to display at PlanPage
      _functionList.add(key);

      int planNumber = json[key];
      // if (planNumber == null) throw ('The value of json[key] is not a int');

      for (int i = planNumber; i < planList.length; i++) {
        planList[i].addFunction(key);
      }
    }

    for (Plan p in planList) {
      print(p.toString());
    }

    return planList;
  }

  List<Plan> convertPlan(var planName) {
    if (!(planName is List)) {
      throw ("plan should be array");
    }

    List<Plan> planList = [];

    for (String name in planName) {
      planList.add(Plan(name));
    }

    if (planList.isEmpty) {
      throw ("Cannot found any plan name");
    }

    return planList;
  }

  void setPriceToPlan(List<Plan> planList, var priceList) {
    if (!(priceList is List)) {
      throw ("price should be array");
    }

    if (priceList.length < planList.length) {
      throw ('The size of price array is not equal to plan array');
    }

    for (int i = 0; i < planList.length; i++) {
      double? price = priceList[i];
      if (price == null) throw ('${priceList[i]} is not a number');
      planList[i].setPrice(price);
    }
  }

  void showErrorMessage(String mess) {
    setState(() {
      errorMessage = mess;
    });
  }
}
