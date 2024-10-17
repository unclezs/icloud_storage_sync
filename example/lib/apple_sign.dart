// Import necessary packages and files
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icloud_storage_sync_example/controller/icloud_plugin_controller.dart';
import 'package:icloud_storage_sync_example/icloud_screen.dart';
import 'package:icloud_storage_sync_example/icloud_state.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// Widget for Apple Sign In screen
class AppleSignInScreen extends StatefulWidget {
  const AppleSignInScreen({super.key});

  @override
  State<AppleSignInScreen> createState() => _AppleSignInScreenState();
}

class _AppleSignInScreenState extends State<AppleSignInScreen> {
  // Get instance of IcloudController
  final IcloudController icloudController = Get.find<IcloudController>();

  @override
  void initState() {
    super.initState();
    checkAlreadyLogin();
  }

  /// Check if user is already logged in
  Future<void> checkAlreadyLogin() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = jsonDecode(prefs.getString("userData") ?? "{}");

    if (data.isNotEmpty) {
      icloudController.userData.value = data;
      icloudController.iCloudStorageState.value = ICloudState.connected;
      Get.offAll(() => IcloudScreen(userData: icloudController.userData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Set gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade300, Colors.green.shade700],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // App title
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'iCloud Sync Example App',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              // Cloud icon
              const Expanded(
                child: Center(
                    child: Icon(
                  Icons.cloud,
                  size: 150,
                  color: Colors.blueAccent,
                )),
              ),
              // Sign in button and policy text
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    // Apple Sign In button
                    ElevatedButton(
                      onPressed: () async {
                        await icloudController.signInWithApple(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.apple, size: 24),
                          SizedBox(width: 10),
                          Text(
                            "Sign In with Apple",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Terms and Privacy Policy text
                    const Text(
                      'By signing in, you agree to our Terms and Privacy Policy',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
