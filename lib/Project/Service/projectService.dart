import 'package:unify/Project/Model/projectModel.dart';
import 'dart:convert';

import '../../Util/dio_helper.dart';

class ProjectService {
  Future<List<ProjectManagerList>> getProjectMgrList() async {
    try {
      DioApiBaseHelper helper = DioApiBaseHelper();
      var dio = await helper.getApiClient();
      var response = await dio.get('Project/GetProjectMgrList');
      if (response.statusCode == 200 && response.data != null) {
        final result = List<Map<String, dynamic>>.from(response.data);
        var dataLst =
            result.map((x) => ProjectManagerList.fromJson(x)).toList();
        return Future.value(dataLst);
      } else if (response.statusCode == 500) {
        return Future.value([]);
      }
      return Future.value([]);
    } catch (e) {
      return [];
    }
  }

  Future<List<EmployeeListModel>> getEmpList() async {
    try {
      DioApiBaseHelper helper = DioApiBaseHelper();
      var dio = await helper.getApiClient();
      var response = await dio.get('Project/GetEmployeeList');
      if (response.statusCode == 200 && response.data != null) {
        final result = List<Map<String, dynamic>>.from(response.data);
        var dataLst = result.map((x) => EmployeeListModel.fromJson(x)).toList();

        return Future.value(dataLst);
      } else if (response.statusCode == 500) {
        return Future.value([]);
      }
      return Future.value([]);
    } catch (e) {
      return [];
    }
  }

  Future<List<TaskModel>> getTaskList() async {
    try {
      DioApiBaseHelper helper = DioApiBaseHelper();
      var dio = await helper.getApiClient();
      var response = await dio.get('Project/GetTaskList');
      if (response.statusCode == 200 && response.data != null) {
        final result = List<Map<String, dynamic>>.from(response.data);
        var dataLst = result.map((x) => TaskModel.fromJson(x)).toList();

        return Future.value(dataLst);
      } else if (response.statusCode == 500) {
        return Future.value([]);
      }
      return Future.value([]);
    } catch (e) {
      return [];
    }
  }

  Future<int?> CreateProject(ProjectModel projectModel) async {
    try {
      DioApiBaseHelper helper = DioApiBaseHelper();
      var dio = await helper.getApiClient();
      var x = jsonEncode(projectModel);

      var response = await dio.post('Project/SaveProject', data: projectModel);

      if (response.statusCode == 200 && response.data != null) {
        print(response.data);
        return response.data;
      } else if (response.statusCode == 500) {
        return Future.value(null);
      }
      return Future.value(null);
    } catch (e) {
      return Future.value(null);
    }
  }

  Future<List<ProjectModel>> GetProjectList() async {
    try {
      DioApiBaseHelper helper = DioApiBaseHelper();
      var dio = await helper.getApiClient();
      var response = await dio.get('Project/GetProjectList');
      if (response.statusCode == 200 && response.data != null) {
        final result = List<Map<String, dynamic>>.from(response.data);
        var dataLst = result.map((x) => ProjectModel.fromJson(x)).toList();

        return Future.value(dataLst);
      } else if (response.statusCode == 500) {
        return Future.value([]);
      }
      return Future.value([]);
    } catch (e) {
      return [];
    }
  }

  Future<ProjectModel> GetEditProject(int? ID) async {
    ProjectModel _projectModel = ProjectModel();
    try {
      DioApiBaseHelper helper = DioApiBaseHelper();
      var dio = await helper.getApiClient();
      var response = await dio.get('Project/ProjectGetByID?ProjectID=$ID');
      if (response.statusCode == 200 && response.data != null) {
        final result = Map<String, dynamic>.from(response.data);
        _projectModel = ProjectModel.fromJson(result);
        return Future.value(_projectModel);
      } else if (response.statusCode == 500) {
        return ProjectModel();
      }
      return ProjectModel();
    } catch (e) {
      return ProjectModel();
    }
  }

  Future<bool?> DeleteProject(int? ProjectID) async {
    try {
      DioApiBaseHelper helper = DioApiBaseHelper();
      var dio = await helper.getApiClient();

      var response =
          await dio.get('Project/DeleteProject?ProjectID=$ProjectID');

      if (response.statusCode == 200 && response.data != null) {
        if (response.data == true) {
          return true;
        } else {
          return false;
        }
      } else if (response.statusCode == 500) {
        return Future.value(null);
      }
      return Future.value(null);
    } catch (e) {
      return Future.value(null);
    }
  }
}
