import 'package:flutter/material.dart';
import 'package:unify/Bloc/blocStream.dart';
import 'package:unify/Project/Model/projectModel.dart';
import 'package:unify/Project/Page/CreateProject.dart';
import 'package:unify/Project/Service/projectService.dart';
import 'package:unify/Util/common_ui.dart';
import 'package:unify/Util/hive_helper.dart';

import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';

class Project extends StatefulWidget {
  final BlocStream? bloc;
  const Project({super.key, this.bloc});

  @override
  State<Project> createState() => _Project();
}

class _Project extends State<Project> {
  final ProjectService _projectService = ProjectService();
  List<ProjectModel> ProjectList = [];
  Map<String, bool> modPrivilege = {};
  final _hivehelper = HiveHelper();
  bool _isLoading = true;
  BlocStream blocStream = BlocStream();

  GetProjectList() async {
    var projectlist = await _projectService.GetProjectList();
    if (this.mounted) {
      setState(() {
        ProjectList = projectlist;
      });
    }
    loaderFalse();
  }

  Future<void> loaderFalse() async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (this.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  privilege() async {
    var data = await _hivehelper.getHiveLoginData();

    String keysString = data["UserPrivileges"] ?? "";
    List<String> keysList = keysString.split(',');

    for (String key in keysList) {
      modPrivilege[key] = true;
    }
  }

  @override
  void initState() {
    super.initState();
    GetProjectList();
    privilege();
  }

  @override
  void dispose() {
    super.dispose();
    blocStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project'),
        actions: [
          modPrivilege["PROJECTCREATE"] == true
              ? IconButton(
                  icon: const Icon(Icons.add_box_rounded),
                  onPressed: () async {
                    String? refresh = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProjectCreate()),
                    );
                    if (refresh == 'refresh') {
                      GetProjectList();
                      msg('Project Created Succesfully');
                    }
                  },
                )
              : SizedBox()
        ],
      ),
      body: StreamBuilder(
          stream: blocStream.stream_projList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data as List<ProjectModel>;
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Card(
                        elevation: 3,
                        margin: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ListTile(
                            title: Text(
                              "${data[index].projectName ?? ""}",
                              style: TextStyle(
                                  height: 1.5, color: Colors.grey.shade800),
                            ),
                            subtitle: Container(
                                margin: EdgeInsets.only(top: 14, bottom: 5),
                                child: Text(
                                  "${data[index].projectCode ?? ""}",
                                  style: TextStyle(color: Colors.grey.shade600),
                                )),
                            leading: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: (data[index].status ?? "")
                                              .toLowerCase() ==
                                          'active'
                                      ? Colors.green[400]
                                      : Colors.red[400],
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: (data[index].status ?? "")
                                                .toLowerCase() ==
                                            'active'
                                        ? Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          )
                                        : Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          )),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                modPrivilege["PROJECTEDIT"] == true
                                    ? IconButton(
                                        tooltip: 'Edit',
                                        onPressed: () async {
                                          String? refresh =
                                              await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProjectCreate(
                                                            ProjectID:
                                                                data[index]
                                                                    .projectID,
                                                          )));
                                          if (refresh == "refresh") {
                                            GetProjectList();
                                            msg('Project Updated');
                                          }
                                        },
                                        icon: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 6,
                                                bottom: 8,
                                                left: 6.5,
                                                right: 8),
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  width: 2,
                                ),
                                modPrivilege["PROJECTDELETE"] == true
                                    ? IconButton(
                                        icon: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 6,
                                                bottom: 8,
                                                left: 6.5,
                                                right: 8),
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          delete(data[index].projectID ?? 0);
                                        })
                                    : SizedBox()
                              ],
                            ),
                          ),
                        ));
                  });
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Handle the loading state here if needed
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  void delete(int id) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text('Are you sure?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                var res = _projectService.DeleteProject(id);
              });
              // if (res == true) {

              Navigator.pop(context);
              GetProjectList();
              msg('Deleted Successfully');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  msg(String description) {
    return MotionToast.success(
      description: Text(description),
      displayBorder: true,
      displaySideBar: false,
    ).show(context);
  }

  stringtoDateTime(String? date) {
    String dateval2;
    if (date != null && date != "") {
      DateTime dateval = DateFormat('yyyy-MM-dd').parse(date.toString());
      dateval2 = DateFormat('dd-MM-yyyy').format(dateval);
      return dateval2;
    }
    dateval2 = DateFormat('dd-MM-yyyy').format(DateTime.now());
    return dateval2;
  }
}
