class Task {
  final String name, taskID;
  bool isDone;
  int timeTaken;
  bool isImportant;

  Task(
      {this.name,
      this.taskID,
      this.isImportant = false,
      this.timeTaken = 0,
      this.isDone = false});

  void toggleIsDone() {
    isDone = !isDone;
  }

  void setIsImportant(bool val) {
    isImportant = val;
  }
}
