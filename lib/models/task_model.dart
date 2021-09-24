class TaskModel {
  late String nodeId;
  late String taskName;
  late int dt;

  TaskModel({
    required this.nodeId,
    required this.taskName,
    required this.dt,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      nodeId: map['nodeId'],
      taskName: map['taskName'],
      dt: map['dt'],
    );
  }
}