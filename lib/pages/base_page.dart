import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:what_to_do/blocs/app_bloc.dart';
import 'package:what_to_do/blocs/note_bloc.dart';
import 'package:what_to_do/blocs/project_bloc.dart';
import 'package:what_to_do/blocs/task_bloc.dart';
import 'package:what_to_do/models/task_model.dart';
import 'package:what_to_do/pages/pages.dart';

class BasePage extends StatelessWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = context.read<AppBloc>();
    TaskBloc taskBloc = context.read<TaskBloc>();
    ProjectBloc projectBloc = context.read<ProjectBloc>();
    NoteBloc noteBloc = context.read<NoteBloc>();

    Color selectedColor = const Color(0xff242424);
    Color defaultColor = const Color(0xffcccccc);
    Color primaryColor = const Color(0xff39A0FF);

    final scaffoldKey = GlobalKey<ScaffoldState>();

    double themeSize = 32;

    return StreamBuilder<int>(
        stream: appBloc.bottomIndex,
        builder: (context, snapshot) {
          int bottomIndex = snapshot.data ?? 0;

          return Scaffold(
            key: scaffoldKey,
            backgroundColor: const Color(0xffFCFDFF),
            // floatingActionButton: FloatingActionButton(
            //   backgroundColor: const Color(0xffD8ECFF),
            //   foregroundColor: const Color(0xff39A0FF),
            //   elevation: 5,
            //   mini: true,
            //   child: const Icon(Icons.add),
            //   onPressed: () {},
            // ),
            endDrawer: Drawer(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Image.asset(
                    'assets/app_icon_transparent.png',
                    width: 120,
                  ),
                  Text(
                    'Organizly',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: selectedColor,
                    ),
                  ),
                  Container(
                    height: 2,
                    width: 200,
                    margin: const EdgeInsets.symmetric(vertical: 32),
                    color: const Color(0xffeaeaea),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Dark mode',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: selectedColor),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor.withOpacity(0.1)),
                        child: const Icon(
                          Icons.sunny,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor.withOpacity(0)),
                        child: Icon(
                          Icons.nightlight,
                          color: Colors.grey[350],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Theme',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: selectedColor),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: themeSize,
                        height: themeSize,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: primaryColor),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Container(
                        width: themeSize,
                        height: themeSize,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.lime),
                      ),
                      Container(
                        width: themeSize,
                        height: themeSize,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.amber),
                      ),
                      Container(
                        width: themeSize,
                        height: themeSize,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red[300]),
                      ),
                      Container(
                        width: themeSize,
                        height: themeSize,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black54),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _sendEmail();
                              },
                              child: Text(
                                'Help & Support',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: selectedColor),
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Open Source Licenses',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: selectedColor),
                              ),
                            ),
                            const SizedBox(height: 32),
                            FutureBuilder<PackageInfo>(
                                future: PackageInfo.fromPlatform(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    PackageInfo packageInfo = snapshot.data!;

                                    return Text('v${packageInfo.version}');
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                }),
                          ],
                        ),
                      )),
                  const SizedBox(height: 64),
                ],
              ),
            ),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              elevation: 0,
              titleSpacing: 20,
              title: Row(
                children: [
                  Image.asset(
                    'assets/appbar_logo.png',
                    width: 36,
                  ),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('MMMM d, E').format(DateTime.now()),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      StreamBuilder<List<TaskVM>>(
                          stream: taskBloc.tasks,
                          builder: (context, snapshot) {
                            List<TaskVM> tasks = snapshot.data ?? [];
                            int pendingCount = tasks
                                .where((element) => !element.completed)
                                .length;

                            return Text(
                              pendingCount == 0 && tasks.isNotEmpty
                                  ? 'All tasks completed'
                                  : '$pendingCount task${pendingCount == 1 ? '' : 's'} pending',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          }),
                    ],
                  ),
                ],
              ),
              centerTitle: false,
              actions: [
                IconButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      scaffoldKey.currentState?.openEndDrawer();
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const SettingsPage()));
                    },
                    icon: Image.asset(
                      'assets/icons/grid.png',
                      width: 24,
                      color: primaryColor,
                    ))
              ],
            ),
            body: IndexedStack(
              index: bottomIndex,
              children: [
                MultiProvider(
                  providers: [
                    Provider(create: (context) => appBloc),
                    Provider(create: (context) => taskBloc),
                    Provider(create: (context) => noteBloc),
                    Provider(create: (context) => projectBloc),
                  ],
                  child: const HomePage(),
                ),
                Provider(
                  create: (context) => taskBloc,
                  child: const TaskPage(),
                ),
                Provider(
                  create: (context) => projectBloc,
                  child: const ProjectPage(),
                ),
                Provider(
                  create: (context) => noteBloc,
                  child: const NotePage(),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(24),
                    topLeft: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.25),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Material(
                elevation: 0,
                color: const Color(0xffFCFDFF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    currentIndex: bottomIndex,
                    onTap: (int index) {
                      HapticFeedback.selectionClick();
                      appBloc.setBottomIndex(index);
                    },
                    selectedItemColor: selectedColor,
                    unselectedItemColor: defaultColor,
                    selectedFontSize: 12,
                    unselectedFontSize: 12,
                    showUnselectedLabels: true,
                    enableFeedback: true,
                    elevation: 0,
                    selectedLabelStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                        icon: Image.asset(
                          'assets/icons/home.png',
                          width: 24,
                          color:
                              bottomIndex == 0 ? selectedColor : defaultColor,
                        ),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                          icon: Image.asset(
                            'assets/icons/tasks.png',
                            width: 24,
                            color:
                                bottomIndex == 1 ? selectedColor : defaultColor,
                          ),
                          label: 'Tasks'),
                      BottomNavigationBarItem(
                          icon: Image.asset(
                            'assets/icons/projects.png',
                            width: 24,
                            color:
                                bottomIndex == 2 ? selectedColor : defaultColor,
                          ),
                          label: 'Projects'),
                      BottomNavigationBarItem(
                          icon: Image.asset(
                            'assets/icons/notes.png',
                            width: 24,
                            color:
                                bottomIndex == 3 ? selectedColor : defaultColor,
                          ),
                          label: 'Notes'),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

void _sendEmail() async {
  String body = await _getEmailBody();

  final Email email = Email(
    body: body,
    subject: '[Organizly] Inquiry: ',
    recipients: ['yeajeancho@gmail.com'],
    cc: [],
    bcc: [],
    attachmentPaths: [],
    isHTML: false,
  );

  try {
    await FlutterEmailSender.send(email);
  } catch (error) {
    print(error.toString());
  }
}

Future<String> _getEmailBody() async {
  String appInfo = await PackageInfo.fromPlatform()
      .then((value) => '${value.buildNumber} (${value.version})');
  Map<String, dynamic> deviceInfo = await _getDeviceInfo();

  String body = '';

  body += "\n\n\n\n---------------\n";
  body += "앱 정보\n";
  body += "버전: $appInfo\n";
  deviceInfo.forEach((key, value) {
    body += "$key: $value\n";
  });
  body += "---------------\n";

  return body;
}

Future<Map<String, dynamic>> _getDeviceInfo() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};

  try {
    if (Platform.isAndroid) {
      deviceData = _readAndroidDeviceInfo(await deviceInfoPlugin.androidInfo);
    } else if (Platform.isIOS) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
  } catch (error) {
    deviceData = {"Error": "Failed to get platform version."};
  }

  return deviceData;
}

Map<String, dynamic> _readAndroidDeviceInfo(AndroidDeviceInfo info) {
  var release = info.version.release;
  var sdkInt = info.version.sdkInt;
  var manufacturer = info.manufacturer;
  var model = info.model;

  return {
    "OS": "Android $release (SDK $sdkInt)",
    "Device": "$manufacturer $model"
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo info) {
  var systemName = info.systemName;
  var version = info.systemVersion;
  var machine = info.utsname.machine;

  return {"OS": "$systemName $version", "Device": machine};
}
