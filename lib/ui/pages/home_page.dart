// ignore_for_file: unused_field
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_x/controllers/task_controller.dart';
import 'package:to_do_x/models/task.dart';
import 'package:to_do_x/services/notification_services.dart';
import 'package:to_do_x/services/theme_services.dart';
import 'package:to_do_x/ui/pages/add_task_page.dart';
import 'package:to_do_x/ui/theme.dart';
import 'package:to_do_x/ui/widgets/button.dart';
import 'package:to_do_x/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  late NotifyHelper notifHelper;
  @override
  void initState() {
    super.initState();
    notifHelper = NotifyHelper();
    notifHelper.requestIOSPermissions();
    notifHelper.initializeNotification();
    //_taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    //SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 10,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          ThemeServices().switchTheme();
          //notifHelper.displayNotification(title: 'Them Changed', body: 'GGGo ');
          //notifHelper.scheduledNotification();
        },
        icon: Icon(
          Get.isDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round_outlined,
          size: 24,
          color: Get.isDarkMode ? Colors.white : darkGreyClr,
        ),
      ),
      elevation: 0.0,
      backgroundColor: Theme.of(context).backgroundColor,
      actions: [
        IconButton(
          onPressed: () {
            _taskController.deleteAllTasks();
            notifHelper.cancelAllNotification();
          },
          icon: Icon(
            Icons.cleaning_services_outlined,
            size: 24,
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
        ),
        const CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 18,
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              ),
            ],
          ),
          MyButton(
            lable: '+ Add Task',
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(
        top: 6,
        left: 20,
      ),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: DateTime.now(),
        width: 70,
        height: 100,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (nweSelectedDate) {
          setState(() {
            _selectedDate = nweSelectedDate;
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _taskController.getTasks();
  }

  _showTasks() {
    return Expanded(
      child: Obx(
        () {
          if (_taskController.taskList.isEmpty) {
            return _noTaskMsg();
          } else {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                scrollDirection: (MediaQuery.of(context).orientation ==
                        Orientation.landscape)
                    ? Axis.horizontal
                    : Axis.vertical,
                itemCount: _taskController.taskList.length,
                itemBuilder: (context, index) {
                  var task = _taskController.taskList[index];
                  if (task.repeat == 'Daily' ||
                      task.date == DateFormat.yMd().format(_selectedDate) ||
                      (task.repeat == 'Weekly' &&
                          _selectedDate
                                      .difference(
                                          DateFormat.yMd().parse(task.date!))
                                      .inDays %
                                  7 ==
                              0) ||
                      (task.repeat == 'Monthly' &&
                          DateFormat.yMd().parse(task.date!).day ==
                              _selectedDate.day)) {
                    // var hour = task.startTime.toString().split(':')[0];
                    // var minutes = task.startTime.toString().split(':')[1];

                    var date = DateFormat.jm().parse(task.startTime!);
                    var myTime = DateFormat('HH:mm').format(date);

                    notifHelper.scheduledNotification(
                      int.parse(myTime.toString().split(':')[0]),
                      int.parse(myTime.toString().split(':')[1]),
                      task,
                    );
                    return AnimationConfiguration.staggeredList(
                      duration: const Duration(milliseconds: 1000),
                      position: index,
                      child: SlideAnimation(
                        horizontalOffset: 300,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () => _showBottomSheet(context, task),
                            child: TaskTile(task),
                          ),
                        ),
                      ),
                    );
                  } else
                    return Container();
                },
              ),
            );
          }
        },
      ),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(
            milliseconds: 2000,
          ),
          curve: Curves.easeInCirc,
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                direction:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? Axis.horizontal
                        : Axis.vertical,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 6,
                        )
                      : const SizedBox(
                          height: 200,
                        ),
                  SvgPicture.asset(
                    'images/task.svg',
                    height: 100,
                    color: primaryClr.withOpacity(0.5),
                    semanticsLabel: 'Task',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      'You don\'t have any tasks yet! \n Add new task to make your days productive. ',
                      style: subTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 120,
                        )
                      : const SizedBox(
                          height: 180,
                        ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            top: 4,
          ),
          width: double.infinity,
          height: (MediaQuery.of(context).orientation == Orientation.landscape)
              ? (task.isCompleted == 1
                  ? MediaQuery.of(context).size.height * 0.6
                  : MediaQuery.of(context).size.height * 0.8)
              : (task.isCompleted == 1
                  ? MediaQuery.of(context).size.height * 0.30
                  : MediaQuery.of(context).size.height * 0.39),
          color: Get.isDarkMode ? darkGreyClr : Colors.white,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: 6,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color:
                        Get.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              task.isCompleted == 1
                  ? Container()
                  : _buildBottomSheet(
                      context,
                      label: 'Task Completed',
                      onTap: () {
                        notifHelper.cancelNotification(task);
                        _taskController.markTasksCompleted(id: task.id!);
                        Get.back();
                      },
                      clr: primaryClr,
                    ),
              _buildBottomSheet(
                context,
                label: 'Delete Taske',
                onTap: () {
                  notifHelper.cancelNotification(task);
                  _taskController.deleteTasks(task: task);
                  Get.back();
                },
                clr: Colors.red[300]!,
              ),
              Divider(
                color: Get.isDarkMode ? Colors.grey : darkGreyClr,
              ),
              _buildBottomSheet(
                context,
                label: 'Cansel ',
                onTap: () {
                  Get.back();
                },
                clr: primaryClr,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildBottomSheet(
    BuildContext context, {
    required String label,
    required Function() onTap,
    required Color clr,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}
