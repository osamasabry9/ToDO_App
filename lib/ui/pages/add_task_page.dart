import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_x/controllers/task_controller.dart';
import 'package:to_do_x/models/task.dart';
import 'package:to_do_x/ui/theme.dart';
import 'package:to_do_x/ui/widgets/button.dart';
import 'package:to_do_x/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();

  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              InputField(
                hint: 'Enter Title here',
                title: 'Title',
                controller: _titleController,
              ),
              InputField(
                hint: 'Enter Node here',
                title: 'Node',
                controller: _noteController,
              ),
              InputField(
                hint: DateFormat.yMd().format(_selectedDate),
                title: 'Date',
                widget: IconButton(
                  onPressed: () => _getDateFromUser(),
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      hint: _startTime,
                      title: 'Strat Time',
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: true),
                        icon: const Icon(
                          Icons.access_time_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InputField(
                      hint: _endTime,
                      title: 'End Time',
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: false),
                        icon: const Icon(
                          Icons.access_time_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                hint: '$_selectedRemind minutes early',
                title: 'Remind',
                widget: Row(
                  children: [
                    DropdownButton(
                      dropdownColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      items: remindList
                          .map<DropdownMenuItem<String>>(
                            (int value) => DropdownMenuItem<String>(
                              value: value.toString(),
                              child: Text(
                                value.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      elevation: 4,
                      iconSize: 32,
                      underline: Container(
                        height: 0,
                      ),
                      style: subTitleStyle,
                      onChanged: (String? newvalue) {
                        setState(() {
                          _selectedRemind = int.parse(newvalue!);
                        });
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              InputField(
                hint: _selectedRepeat,
                title: 'Repeat',
                widget: Row(
                  children: [
                    DropdownButton(
                      dropdownColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      items: repeatList
                          .map(
                            (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      elevation: 4,
                      iconSize: 32,
                      underline: Container(
                        height: 0,
                      ),
                      style: subTitleStyle,
                      onChanged: (String? newvalue) {
                        setState(() {
                          _selectedRepeat = newvalue!;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: _colorPalette(),
                  ),
                  MyButton(
                    lable: 'Create Task',
                    onTap: () {
                      _validateDate();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(
          Icons.arrow_back_ios_new,
          size: 24,
          color: primaryClr,
        ),
      ),
      elevation: 0.0,
      backgroundColor: Theme.of(context).backgroundColor,
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 18,
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksToDo();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('Required', 'All fields are required! ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ),);
    } else {
      print('################# SOMETHING BAD ##########');
    }
  }

  _addTasksToDo() async {
    int value = await _taskController.addTask(
      task: Task(
      title: _titleController.text,
      note: _noteController.text,
      isCompleted: 0,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      color: _selectedColor,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
    ));
    print('my id is $value');
  }

  Column _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        const SizedBox(
          height: 5,
        ),
        Wrap(
          children: List.generate(
            3,
            (index) => GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: CircleAvatar(
                  backgroundColor: (index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : orangeClr),
                  radius: 16,
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2030));
    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    } else
      Get.snackbar('Required', 'All fields are required! ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(minutes: 15))),
    );
    String _formatttedTime = _pickedTime!.format(context);
    if (isStartTime) {
      setState(() {
        _startTime = _formatttedTime;
      });
    } else if (!isStartTime) {
      setState(() {
        _endTime = _formatttedTime;
      });
    } else {
      print('time Canceld');
    }
  }
}
