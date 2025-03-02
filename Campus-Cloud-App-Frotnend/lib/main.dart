import 'package:campus_cloud/routes/RouteNames.dart';
import 'package:campus_cloud/routes/route.dart';
import 'package:campus_cloud/services/geofencingService.dart';
import 'package:campus_cloud/services/storageService.dart';
import 'package:campus_cloud/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  // Get.put(SupabaseService());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  requestNotificationPermission();

  runApp(const MyApp()); // Run app immediately
}
Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: 'Cloud Campus',
      getPages: Routes.pages,
      initialRoute: box.read('authToken') != null ? RouteNames.Home : RouteNames.Login,
    );
  }
}
