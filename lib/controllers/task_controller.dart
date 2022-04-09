import 'package:get/get.dart';
import 'package:to_do_x/db/db_helper.dart';
import 'package:to_do_x/models/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async{
    return await DBHelper.insert(task!);
  }

  Future<void> getTasks() async {
     List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void deleteTasks({Task? task}) async {
    await DBHelper.delete(task);
    getTasks();
  }

   void deleteAllTasks({Task? task}) async {
    await DBHelper.deleteAll(task);
    getTasks();
  }

  void markTasksCompleted({required int id}) async {
    await DBHelper.update(id);
    getTasks();
  }
}

// Task(
//   title: 'Title 1',
//   note: 'Note Somthing',
//   isCompleted: 0,
//   startTime: DateFormat('hh:mm a')
//       .format(DateTime.now().add(const Duration(minutes: 1)))
//       .toString(),
//   endTime: DateFormat('hh:mm a')
//       .format(DateTime.now().add(const Duration(minutes: 5)))
//       .toString(),
//   color: 2,
// ),
