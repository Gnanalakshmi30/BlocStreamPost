import 'dart:async';

import 'package:unify/Project/Model/projectModel.dart';
import 'package:unify/Project/Service/projectService.dart';

class BlocStream {
  BlocStream() {
    getData();
  }

  dispose() {
    _projectStreamController.close();
  }

  final service = ProjectService();
  List<ProjectModel> projectlist = [];
  final _projectStreamController = StreamController<List<ProjectModel>>();
  StreamSink<List<ProjectModel>> get projList_sink =>
      _projectStreamController.sink;
  Stream<List<ProjectModel>> get stream_projList =>
      _projectStreamController.stream;

  getData() async {
    try {
      var res = await service.GetProjectList();
      projectlist = res;
      // Emit the fetched data through the stream
      projList_sink.add(projectlist);
    } catch (e) {
      // Handle errors here, e.g., emit an empty list or show an error message
      projList_sink.addError("Failed to fetch data: $e");
    }
  }

  //post

  Future<void> createProject(ProjectModel projectModel) async {
    try {
      // Emit a loading event to indicate the request is in progress
      projList_sink.add([]);

      // Call your CreateProject method to make the POST request
      final int? result = await service.CreateProject(projectModel);

      if (result != null) {
        // Emit a success event with the result
        projectlist.add(projectModel);
        projList_sink.add(projectlist);
      } else {
        // Emit an error event
        projList_sink.addError("Failed to create project");
      }
    } catch (e) {
      // Emit an error event
      projList_sink.addError("Failed to create project: $e");
    }
  }
}
