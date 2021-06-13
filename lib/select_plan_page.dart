import 'package:flutter/material.dart';

import 'model/plan.dart';

class SelectPlanPage extends StatefulWidget {
  final List<String> functionList;
  final List<Plan> planList;

  SelectPlanPage(this.planList, this.functionList);

  @override
  _SelectPlanPageState createState() => _SelectPlanPageState();
}

class _SelectPlanPageState extends State<SelectPlanPage> {
  late List<String> functionList;
  late List<Plan> planList;
  Plan? selectedPlan;

  @override
  void initState() {
    functionList = widget.functionList;
    planList = widget.planList;
    selectedPlan = planList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktopView = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: isDesktopView ? buildDesktopView() : buildMobileView(),
    );
  }

  Widget buildDesktopView() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Align(
            alignment: Alignment.center,
            child: const Text(
              "Choose a plan",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        // Table
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: DataTable(
              sortAscending: false,
              columns: [
                // Empty space
                DataColumn(label: Text('')),
                ...buildPlanTitle(),
              ],
              rows: buildFunctionDataRow(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMobileView() {
    List<Widget> wl = [];
    for (Plan plan in planList) {
      var widget = Padding(
        padding: const EdgeInsets.only(right: 10, left: 10, bottom: 30),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: DataTable(
            sortAscending: false,
            columns: [
              // Empty space
              DataColumn(label: Text('')),
              ...buildPlanTitle(plan),
            ],
            rows: buildFunctionDataRow(plan),
          ),
        ),
      );

      wl.add(widget);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Align(
              alignment: Alignment.center,
              child: const Text(
                "Choose a plan",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ...wl
        ],
      ),
    );
  }

  // If there is a plan as param, only build that plan, otherwise, build all plans
  List<DataColumn> buildPlanTitle([Plan? plan]) {
    List<DataColumn> dataColumnList = [];
    List<Plan> pl = plan == null ? planList : [plan];

    for (int i = 0; i < pl.length; i++) {
      var dataColumn = DataColumn(
        label: Expanded(
          child: Center(
            child: Text(pl[i].name),
          ),
        ),
      );
      dataColumnList.add(dataColumn);
    }
    return dataColumnList;
  }

  // Display the function name
  List<DataRow> buildFunctionDataRow([Plan? plan]) {
    List<DataRow> functionDataRow = [];
    for (String fun in functionList) {
      var dataRow = DataRow(
        cells: <DataCell>[
          DataCell(Text(fun)),
          ...buildFunctionDataCell(fun, plan),
        ],
      );
      functionDataRow.add(dataRow);
    }
    functionDataRow.add(buildRadioRow(plan));
    return functionDataRow;
  }

  // if the plan contain this function, then return tick icon, otherwise, cross icon
  List<DataCell> buildFunctionDataCell(String funName, [Plan? plan]) {
    List<DataCell> dataCellList = [];

    List<Plan> pl = plan == null ? planList : [plan];
    for (Plan p in pl) {
      var cell = DataCell(
        Center(
          child: p.funList.contains(funName)
              ? const Icon(Icons.check)
              : const Icon(Icons.close),
        ),
      );
      dataCellList.add(cell);
    }
    return dataCellList;
  }

  // The radio for use select the plan and display the plan
  DataRow buildRadioRow([Plan? plan]) {
    List<DataCell> dataCellRadioList = [];

    List<Plan> pl = plan == null ? planList : [plan];
    for (Plan p in pl) {
      var dataCellRadio = DataCell(
        ListTile(
          title: Text('HKD\$${p.price.toString()}/Month'),
          leading: Radio<Plan>(
            value: p,
            groupValue: selectedPlan,
            onChanged: (Plan? p) {
              setState(() => selectedPlan = p);
            },
          ),
        ),
      );
      dataCellRadioList.add(dataCellRadio);
    }

    return DataRow(
      cells: <DataCell>[
        DataCell(Text('')),
        ...dataCellRadioList,
      ],
    );
  }
}
