// ignore_for_file: non_constant_identifier_names, prefer_const_declarations, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:unify/Bloc/blocStream.dart';
import 'package:unify/Project/Model/projectModel.dart';
import 'package:unify/Project/Service/projectService.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:unify/Util/route_generator.dart';

import '../../Util/hive_helper.dart';

class ProjectCreate extends StatefulWidget {
  final int? ProjectID;

  const ProjectCreate({
    super.key,
    this.ProjectID,
  });
  @override
  State<ProjectCreate> createState() => _ProjectCreate();
}

class _ProjectCreate extends State<ProjectCreate> {
  final _ProjectService = ProjectService();
  ProjectModel _ProjectModel = ProjectModel();
  final _hivehelper = HiveHelper();
  bool edit = false;
  bool flag = true;
  bool flag1 = true;
  final TextEditingController _projectCode = TextEditingController();
  final TextEditingController _projectname = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _scheduledStartDate = TextEditingController();
  final TextEditingController _scheduledEndDate = TextEditingController();
  final TextEditingController _ActualStartDate = TextEditingController();
  final TextEditingController _ActualEndDate = TextEditingController();
  bool projectCode = false;
  bool projectName = false;
  bool scheduledStartDate = false;
  bool actualStartDate = false;
  List<ProjectManagerList> projmanagerlist = [];
  List<EmployeeListModel> emplists = [];
  List<TaskModel> tasklists = [];
  String? projmgrdropdownValue;
  String? ProjstatusdropdownValue = "Open";
  List? _selectedEmpValues = [];
  List? _selectedTaskValues = [];
  List<int> _selectedTaskValuesint = [];
  List<int> _selectedemployeeValuesint = [];

  String? status = 'Active';
  String? scheduledStartDateval;
  String? scheduledEndDateval;
  String? actualStartDateval;
  String? actualEndDateval;
  DateTime selectedActualStartDate = DateTime.now();
  DateTime selectedActualEndDate = DateTime.now();
  DateTime selectedScheduledtartDate = DateTime.now();
  DateTime selectedScheduledEndDate = DateTime.now();
  int? statusindex = 0;
  int? CreatedBY;
  BlocStream blocStream = BlocStream();
  GetLoginData() {
    var data = _hivehelper.getHiveLoginData();
    CreatedBY = data['UserID'];
  }

  GetDropdownVal() async {
    var projmgrlist = await _ProjectService.getProjectMgrList();
    var emplist = await _ProjectService.getEmpList();
    var tasklist = await _ProjectService.getTaskList();
    if (mounted) {
      setState(() {
        projmanagerlist = projmgrlist;
        emplists = emplist;
        tasklists = tasklist;
      });
    }
  }

  GetEditProject() async {
    _ProjectModel = await _ProjectService.GetEditProject(widget.ProjectID);
    if (_ProjectModel.status?.toLowerCase() == "inactive") {
      if (mounted) {
        setState(() {
          statusindex = 1;
          status = 'inactive';
        });
      }
    }
    if (_ProjectModel.projectStatus?.toLowerCase() == "closed") {
      if (mounted) {
        setState(() {
          ProjstatusdropdownValue = "Closed";
        });
      }
    }
    _projectCode.text = _ProjectModel.projectCode ?? "";
    _projectname.text = _ProjectModel.projectName ?? "";
    _description.text = _ProjectModel.description ?? "";
    selectedActualStartDate = StringtoDateTime(_ProjectModel.actualStartDate);
    _ActualStartDate.text =
        DateFormat('dd-MM-yyyy').format(selectedActualStartDate);
    actualStartDateval =
        DateFormat('MM-dd-yyyy').format(selectedActualStartDate);

    if (_ProjectModel.actualEndDate != null &&
        _ProjectModel.actualEndDate != "") {
      selectedActualEndDate = StringtoDateTime(_ProjectModel.actualEndDate);
      _ActualEndDate.text =
          DateFormat('dd-MM-yyyy').format(selectedActualEndDate);
      actualEndDateval = DateFormat('MM-dd-yyyy').format(selectedActualEndDate);
    }
    selectedScheduledtartDate =
        StringtoDateTime(_ProjectModel.scheduledStartDate);
    _scheduledStartDate.text =
        DateFormat('dd-MM-yyyy').format(selectedScheduledtartDate);
    scheduledStartDateval =
        DateFormat('MM-dd-yyyy').format(selectedScheduledtartDate);
    if (_ProjectModel.scheduledEndDate != null &&
        _ProjectModel.scheduledEndDate != "") {
      selectedScheduledEndDate =
          StringtoDateTime(_ProjectModel.scheduledEndDate);
      _scheduledEndDate.text =
          DateFormat('dd-MM-yyyy').format(selectedScheduledEndDate);
      scheduledEndDateval =
          DateFormat('MM-dd-yyyy').format(selectedScheduledEndDate);
    }
    if (_ProjectModel.projectManagerID! > 0) {
      projmgrdropdownValue = _ProjectModel.projectManagerID.toString();
    }
    if (_ProjectModel.employees != null && _ProjectModel.employees != "") {
      String employees = _ProjectModel.employees ?? "";
      _selectedEmpValues = employees
          .split(",")
          .map((x) => x.trim())
          .where((element) => element.isNotEmpty)
          .toList();
      for (var i in _selectedEmpValues!) {
        _selectedemployeeValuesint.add(int.parse(i));
      }
    }
    if (_ProjectModel.tasks != null && _ProjectModel.tasks != "") {
      String tasks = _ProjectModel.tasks ?? "";
      _selectedTaskValues = tasks
          .split(",")
          .map((x) => x.trim())
          .where((element) => element.isNotEmpty)
          .toList();
      for (var i in _selectedTaskValues!) {
        _selectedTaskValuesint.add(int.parse(i));
      }
    }
    edit = true;
  }

  @override
  void initState() {
    super.initState();
    GetLoginData();
    GetDropdownVal();

    int? projectID = widget.ProjectID ?? 0;
    if (projectID > 0) {
      GetEditProject();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              widget.ProjectID != null ? 'Update Project' : 'Create Project',
              textAlign: TextAlign.left,
            ),
          ],
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            child: Form(
              child: Column(children: <Widget>[
                ActiveStatus(),
                ProjectCode(),
                projectCode ? ProjectCodeValidation() : SizedBox(),
                ProjectName(),
                projectName ? ProjectNameValidation() : SizedBox(),
                Description(),
                ScheduledStartDate(context),
                scheduledStartDate
                    ? ScheduledStartDateValidation()
                    : SizedBox(),
                ScheduledEndDate(context),
                ActualStartDate(context),
                actualStartDate ? ActualStartDateValidation() : SizedBox(),
                ActualEndDate(context),
                Projectmanager(),
                ProjectStatus(),
                EmployeeList(),
                TaskList(),
              ]),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            if (_projectCode.text == null || _projectCode.text == '') {
              if (mounted) {
                setState(() {
                  projectCode = true;
                  flag = false;
                });
              }
            } else {
              if (mounted) {
                setState(() {
                  projectCode = false;
                  flag = true;
                });
              }
            }
            if (_projectname.text == null || _projectname.text == '') {
              if (mounted) {
                setState(() {
                  projectName = true;
                  flag = false;
                });
              }
            } else {
              if (mounted) {
                setState(() {
                  projectName = false;
                  flag = true;
                });
              }
            }
            if (_scheduledStartDate.text == null ||
                _scheduledStartDate.text == '') {
              if (mounted) {
                setState(() {
                  scheduledStartDate = true;
                  flag1 = false;
                });
              }
            } else {
              if (mounted) {
                setState(() {
                  scheduledStartDate = false;
                  flag1 = true;
                });
              }
            }
            if (_ActualStartDate.text == null || _ActualStartDate.text == '') {
              if (mounted) {
                setState(() {
                  actualStartDate = true;
                  flag = false;
                });
              }
            } else {
              if (mounted) {
                setState(() {
                  actualStartDate = false;
                  flag = true;
                });
              }
            }
            if (flag == true && flag1 == true) {
              ProjectModel projectModel = ProjectModel();

              if (projmgrdropdownValue != null && projmgrdropdownValue != "") {
                projectModel.projectManagerID =
                    int.parse(projmgrdropdownValue.toString());
              } else {
                projectModel.projectManagerID = 0;
              }

              projectModel.projectCode = _projectCode.text;
              projectModel.projectName = _projectname.text;
              projectModel.description = _description.text;
              projectModel.scheduledStartDate = scheduledStartDateval;
              projectModel.scheduledEndDate = scheduledEndDateval;
              projectModel.actualStartDate = actualStartDateval;
              projectModel.actualEndDate = actualEndDateval;

              projectModel.createdBy = CreatedBY ?? 0;
              projectModel.employeeIDs = _selectedEmpValues;
              projectModel.taskIDs = _selectedTaskValues;
              projectModel.projectID = widget.ProjectID ?? 0;
              projectModel.status = status;
              projectModel.savedDate = DateTime.now().toString();
              projectModel.projectStatus = ProjstatusdropdownValue;
              projectModel.employees = ArraytoString(_selectedEmpValues);
              projectModel.tasks = ArraytoString(_selectedTaskValues);
              // int? res = await _ProjectService.CreateProject(projectModel);

              blocStream.createProject(projectModel);
              Navigator.of(context).pushNamed(PageRoutes.project,
                  arguments: {"bloc": blocStream});

              // if (res != null && res >= 1) {
              //   int? projectID = widget.ProjectID ?? 0;
              //   if (projectID > 0) {
              //     Navigator.pop(context, 'refresh');
              //   } else {
              //     Navigator.pop(context, 'refresh');
              //     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //     //   content: Text(
              //     //     "Project created successfully",
              //     //     style: TextStyle(fontSize: 15),
              //     //   ),
              //     //   backgroundColor: Colors.blue[600],
              //     // ));
              //   }
              // } else {
              //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              //     content: Text(
              //       "Something went wrong!",
              //       style: TextStyle(fontSize: 15),
              //     ),
              //     backgroundColor: Colors.red,
              //   ));
              // }
            }
          } on Exception catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "Something went wrong, try again after sometime.",
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.red,
            ));
            Navigator.pop(context);
            throw e;
          }
        },
        child: Icon(Icons.done),
      ),
    );
  }

  ProjectCode() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: _projectCode,
        decoration: InputDecoration(
            labelText: 'Project Code',
            prefixIcon: Icon(Icons.numbers),
            hintText: 'Enter Project Code',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(1.0))),
        onChanged: (value) {
          if (value == null || value == '') {
            if (mounted) {
              setState(() {
                projectCode = true;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                projectCode = false;
              });
            }
          }
        },
      ),
    );
  }

  ProjectName() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: _projectname,
        decoration: InputDecoration(
            labelText: 'Project Name',
            prefixIcon: Icon(Icons.post_add_rounded),
            hintText: 'Enter Project Name',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(1.0))),
        onChanged: (value) {
          if (value == null || value == '') {
            if (mounted) {
              setState(() {
                projectName = true;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                projectName = false;
              });
            }
          }
        },
      ),
    );
  }

  Description() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: 4,
        controller: _description,
        decoration: InputDecoration(
            labelText: 'Description',
            prefixIcon: Icon(Icons.description),
            hintText: 'Enter Description',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(1.0))),
        onChanged: (value) {},
      ),
    );
  }

  ScheduledStartDate(context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
          readOnly: true,
          controller: _scheduledStartDate,
          decoration: InputDecoration(
              labelText: 'Scheduled Start Date',
              prefixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
              )),
          onTap: () async {
            final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedScheduledtartDate,
                firstDate: DateTime(2015, 8),
                lastDate: DateTime(2101));
            if (picked != null) {
              if (mounted) {
                setState(() {
                  scheduledStartDate = false;
                  selectedScheduledtartDate = picked;
                  _scheduledStartDate.text =
                      DateFormat('dd-MM-yyyy').format(picked);
                  scheduledStartDateval =
                      DateFormat('MM-dd-yyyy').format(picked);
                });
              }
            }
          }),
    );
  }

  ScheduledEndDate(context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
          readOnly: true,
          controller: _scheduledEndDate,
          decoration: InputDecoration(
              labelText: 'Scheduled End Date',
              prefixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
              )),
          onTap: () async {
            final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedScheduledtartDate,
                firstDate: selectedScheduledtartDate,
                lastDate: DateTime(2101));
            if (picked != null) {
              if (mounted) {
                setState(() {
                  selectedScheduledEndDate = picked;
                  _scheduledEndDate.text =
                      DateFormat('dd-MM-yyyy').format(picked);
                  scheduledEndDateval = DateFormat('MM-dd-yyyy').format(picked);
                });
              }
            }
          }),
    );
  }

  ActualStartDate(context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        readOnly: true,
        controller: _ActualStartDate,
        decoration: InputDecoration(
            labelText: 'Actual Start Date',
            prefixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(1.0),
            )),
        onTap: () async {
          final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedActualStartDate,
              firstDate: DateTime(2015, 8),
              lastDate: DateTime(2101));
          if (picked != null) {
            if (mounted) {
              setState(() {
                actualStartDate = false;
                selectedActualStartDate = picked;
                _ActualStartDate.text = DateFormat('dd-MM-yyyy').format(picked);
                actualStartDateval = DateFormat('MM-dd-yyyy').format(picked);
              });
            }
          }
        },
      ),
    );
  }

  ActualEndDate(context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
          readOnly: true,
          controller: _ActualEndDate,
          decoration: InputDecoration(
              labelText: 'Actual End Date',
              prefixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
              )),
          onTap: () async {
            final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedActualStartDate,
                firstDate: selectedActualStartDate,
                lastDate: DateTime(2101));
            if (picked != null) {
              if (mounted) {
                setState(() {
                  selectedActualEndDate = picked;
                  _ActualEndDate.text = DateFormat('dd-MM-yyyy').format(picked);
                  actualEndDateval = DateFormat('MM-dd-yyyy').format(picked);
                });
              }
            }
          }),
    );
  }

  Projectmanager() {
    return Container(
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Container(
            child: DropdownButton<String>(
              value: projmgrdropdownValue,
              icon: Icon(Icons.arrow_downward),
              elevation: 16,
              hint: Text('Select Project Manager'),
              isExpanded: true,
              underline: Container(
                height: 2,
                color: Colors.blue[700],
              ),
              onChanged: (String? value) {
                if (mounted) {
                  setState(() {
                    projmgrdropdownValue = value;
                  });
                }
              },
              items: projmanagerlist
                  .map<DropdownMenuItem<String>>((ProjectManagerList value) {
                return DropdownMenuItem<String>(
                  value: value.value.toString(),
                  child: Text(value.text ?? ""),
                );
              }).toList(),
            ),
          )),
    );
  }

  ProjectStatus() {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: DropdownButton<String>(
            hint: Text('Select Project Status'),
            isExpanded: true,
            value: ProjstatusdropdownValue,
            icon: Icon(Icons.arrow_downward),
            elevation: 16,
            underline: Container(
              height: 2,
              color: Colors.blue[700],
            ),
            onChanged: (String? value) {
              if (mounted) {
                setState(() {
                  ProjstatusdropdownValue = value;
                });
              }
            },
            items: const [
              DropdownMenuItem(
                child: Text('Open'),
                value: 'Open',
              ),
              DropdownMenuItem(
                child: Text('Closed'),
                value: 'Closed',
              )
            ]));
  }

  EmployeeList() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: MultiSelectDialogField(
        initialValue: edit ? _selectedemployeeValuesint : [],
        searchable: true,
        buttonText: Text('Employee List(s)'),
        title: Text('Select Employee'),
        items:
            emplists.map((e) => MultiSelectItem(e.value, '${e.text}')).toList(),
        listType: MultiSelectListType.CHIP,
        onConfirm: (values) {
          _selectedEmpValues = values;
        },
      ),
    );
  }

  TaskList() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: MultiSelectDialogField(
        searchable: true,
        buttonText: Text('Task List(s)'),
        initialValue: edit ? _selectedTaskValuesint : [],
        title: Text('Select Task'),
        items: tasklists
            .map((e) => MultiSelectItem(e.value, '${e.text}'))
            .toList(),
        listType: MultiSelectListType.CHIP,
        onConfirm: (values) {
          _selectedTaskValues = values;
        },
      ),
    );
  }

  ActiveStatus() {
    return Container(
      margin: EdgeInsets.only(left: 130),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: ToggleSwitch(
          minWidth: 75.0,
          cornerRadius: 20.0,
          activeBgColors: [
            [Colors.blue[300]!],
            [Colors.blue[300]!]
          ],
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.grey,
          inactiveFgColor: Colors.white,
          initialLabelIndex: statusindex,
          totalSwitches: 2,
          labels: ['Active', 'Inactive'],
          radiusStyle: true,
          onToggle: (index) {
            if (index == 0) {
              status = 'Active';
            } else {
              status = 'Inactive';
            }
          },
        ),
      ),
    );
  }

  ProjectCodeValidation() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: Text('Please enter project code ',
              style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  ProjectNameValidation() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: Text('Please enter project name ',
              style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  ScheduledStartDateValidation() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: Text('Please enter scheduled start date ',
              style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  ActualStartDateValidation() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: Text(
            'Please enter actual start date ',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  ArraytoString(values) {
    final list = values;
    final sb = StringBuffer();
    sb.writeAll(list, ', ');
    return sb.toString();
  }

  StringtoDateTime(String? date) {
    DateTime dateval = new DateFormat("yyyy-MM-dd").parse(date.toString());

    return dateval;
  }
}
