import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do_x/db/db_helper.dart';
import 'package:to_do_x/services/theme_services.dart';
import 'package:to_do_x/ui/pages/home_page.dart';
import 'ui/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.inttDb();
  await GetStorage.init();

  runApp(const MyApp());
  //NotifyHelper().initializeNotification();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
