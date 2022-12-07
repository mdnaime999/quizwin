import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';

import 'controllers/drawer_cont.dart';
import 'controllers/profile_cont.dart';
import 'initial/app_const.dart';
import 'initial/dark_theme.dart';
import 'initial/initial_app.dart';
import 'initial/light_theme.dart';
import 'views/auth/login_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // firebase
  await Firebase.initializeApp();
  // admobe
  MobileAds.instance.initialize();
  // Database
  await Hive.initFlutter();
  await Hive.openBox("auth");
  // AppConst().createDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Box auth = Hive.box('auth');
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConst().appTitle,
          theme: light,
          darkTheme: dark,
          themeMode: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: LoginPage(),
          // unknownRoute: GetPage(name: '/notfound', page: () => NotFound()),
          // initialRoute: '/',
          // getPages: [
          //   GetPage(name: '/', page: () => HomePage1(), binding: InitBinding()),
          //   GetPage(name: '/login', page: () => LoginPage())
          // ],
          navigatorObservers: [FlutterSmartDialog.observer],
          builder: FlutterSmartDialog.init(),
        );
      },
    );
  }
}

class InitBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InitialApp>(() => InitialApp());
    Get.lazyPut<DrawerCont>(() => DrawerCont());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
