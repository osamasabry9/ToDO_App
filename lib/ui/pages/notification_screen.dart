import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_x/ui/theme.dart';

class NotificationScreen extends StatefulWidget {
  final String payload;
  const NotificationScreen({Key? key, required this.payload}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload = '';
  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          _payload.toString().split('|')[0],
          style: TextStyle(color: Get.isDarkMode ? Colors.white : darkGreyClr),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    'Hello!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Get.isDarkMode ? Colors.white : darkGreyClr,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'You have a new remindor',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Get.isDarkMode ? Colors.grey[100] : darkGreyClr,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: primaryClr,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...bodyDeccription(
                          icon: Icons.text_format,
                          index: 0,
                          title: 'Title!',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ...bodyDeccription(
                          icon: Icons.description,
                          index: 1,
                          title: 'Description!',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ...bodyDeccription(
                          icon: Icons.calendar_today_outlined,
                          index: 2,
                          title: 'Date!',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> bodyDeccription(
      {required IconData icon, required String title, required int index}) {
    return [
      Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
          const SizedBox(
            width: 20.0,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Text(
        _payload.toString().split('|')[index],
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    ];
  }
}
