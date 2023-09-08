class ProjectModel {
  int? projectID;
  String? projectCode;
  String? projectName;
  String? description;
  int? projectManagerID;
  String? projectManager;
  List<ProjectManagerList>? projectManagerList;
  String? scheduledStartDate;
  String? scheduledEndDate;
  String? actualStartDate;
  String? actualEndDate;
  String? clientName;
  String? companyName;
  String? contactNumber;
  String? projectStatus;
  String? status;
  int? createdBy;
  String? savedDate;
  List<EmployeeListModel>? employeeList;
  List? employeeIDs;

  String? employeeNames;
  String? employees;
  List<TaskModel>? taskList;
  List? taskIDs;
  String? taskNames;
  String? tasks;

  ProjectModel(
      {this.projectID,
      this.projectCode,
      this.projectName,
      this.description,
      this.projectManagerID,
      this.projectManager,
      this.projectManagerList,
      this.scheduledStartDate,
      this.scheduledEndDate,
      this.actualStartDate,
      this.actualEndDate,
      this.clientName,
      this.companyName,
      this.contactNumber,
      this.projectStatus,
      this.status,
      this.createdBy,
      this.savedDate,
      this.employeeList,
      this.employeeIDs,
      this.employeeNames,
      this.employees,
      this.taskList,
      this.taskIDs,
      this.taskNames,
      this.tasks});

  ProjectModel.fromJson(Map<String, dynamic> json) {
    projectID = json['ProjectID'];
    projectCode = json['ProjectCode'];
    projectName = json['ProjectName'];
    description = json['Description'];
    projectManagerID = json['ProjectManagerID'];
    projectManager = json['ProjectManager'];
    projectManagerList = json['ProjectManagerList'];
    scheduledStartDate = json['ScheduledStartDate'];
    scheduledEndDate = json['ScheduledEndDate'];
    actualStartDate = json['ActualStartDate'];
    actualEndDate = json['ActualEndDate'];
    clientName = json['ClientName'];
    companyName = json['CompanyName'];
    contactNumber = json['ContactNumber'];
    projectStatus = json['ProjectStatus'];
    status = json['Status'];
    createdBy = json['CreatedBy'];
    savedDate = json['SavedDate'];
    employeeList = json['EmployeeList'];
    employeeIDs = json['EmployeeIDs'];
    employeeNames = json['EmployeeNames'];
    employees = json['Employees'];
    taskList = json['TaskList'];
    taskIDs = json['TaskIDs'];
    taskNames = json['TaskNames'];
    tasks = json['Tasks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProjectID'] = this.projectID;
    data['ProjectCode'] = this.projectCode;
    data['ProjectName'] = this.projectName;
    data['Description'] = this.description;
    data['ProjectManagerID'] = this.projectManagerID;
    data['ProjectManager'] = this.projectManager;
    data['ProjectManagerList'] = this.projectManagerList;
    data['ScheduledStartDate'] = this.scheduledStartDate;
    data['ScheduledEndDate'] = this.scheduledEndDate;
    data['ActualStartDate'] = this.actualStartDate;
    data['ActualEndDate'] = this.actualEndDate;
    data['ClientName'] = this.clientName;
    data['CompanyName'] = this.companyName;
    data['ContactNumber'] = this.contactNumber;
    data['ProjectStatus'] = this.projectStatus;
    data['Status'] = this.status;
    data['CreatedBy'] = this.createdBy;
    data['SavedDate'] = this.savedDate;
    data['EmployeeList'] = this.employeeList;
    data['EmployeeIDs'] = this.employeeIDs;
    data['EmployeeNames'] = this.employeeNames;
    data['Employees'] = this.employees;
    data['TaskList'] = this.taskList;
    data['TaskIDs'] = this.taskIDs;
    data['TaskNames'] = this.taskNames;
    data['Tasks'] = this.tasks;
    return data;
  }
}

class ProjectManagerList {
  String? text;
  int? value;

  ProjectManagerList({this.text, this.value});

  ProjectManagerList.fromJson(Map<String, dynamic> json) {
    text = json['EmployeeName'];
    value = json['EmployeeID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['EmployeName'] = this.text;
    data['EmployeeID'] = this.value;
    return data;
  }
}

class EmployeeListModel {
  String? text;
  int? value;

  EmployeeListModel({this.text, this.value});

  EmployeeListModel.fromJson(Map<String, dynamic> json) {
    text = json['EmployeeName'];
    value = json['EmployeeID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['Text'] = this.text;
    data['Value'] = this.value;
    return data;
  }
}

class TaskModel {
  String? text;
  int? value;

  TaskModel({this.text, this.value});

  TaskModel.fromJson(Map<String, dynamic> json) {
    text = json['Task'];
    value = json['TaskID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['Text'] = this.text;
    data['Value'] = this.value;
    return data;
  }
}
