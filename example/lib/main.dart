import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icloud_storage_sync_example/apple_sign.dart';
import 'package:icloud_storage_sync_example/controller/icloud_plugin_controller.dart';

// Entry point of the application
void main() {
  // Ensure that Flutter widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the IcloudController using GetX for dependency injection
  Get.lazyPut(() => IcloudController());

  // Run the app
  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // Use GetMaterialApp for GetX functionality
    return GetMaterialApp(
      // Disable the debug banner
      debugShowCheckedModeBanner: false,

      // Set the app theme
      theme: ThemeData(
          useMaterial3: false,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.green)),

      // Set the initial route to the Apple Sign In screen
      home: const AppleSignInScreen(),
    );
  }
}
