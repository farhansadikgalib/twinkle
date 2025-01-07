import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/routes/app_pages.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling a background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await ScreenUtil.ensureScreenSize();
  runApp(ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
            overlays: [SystemUiOverlay.bottom]);

        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark));

        return GetMaterialApp(
          title: "Twinkle",
          debugShowCheckedModeBanner: false,
          initialRoute: AppPages.INITIAL,
          builder: EasyLoading.init(),
          theme: ThemeData(
            useMaterial3: true,
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          defaultTransition: Transition.cupertino,
          getPages: AppPages.routes,
          enableLog: kDebugMode,
        );
      }));
}
