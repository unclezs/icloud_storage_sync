<img src="https://gitlab.com/mohammedbakali.codexlancers/icloud-plugin/-/raw/main/assets/icloud_storage_sync_pub_dev_banner.jpg" width="600" height="400" />

# iCloud_Storage_Sync Plugin 📦☁️


A Flutter plugin that simplifies the process of uploading, downloading, and managing files within your app's iCloud. 

## Introduction 🌟

- The iCloud_Storage_Sync Flutter plugin is a powerful tool that enables seamless integration of iCloud storage capabilities into your iOS applications 📱.
- With this plugin, you can effortlessly backup and synchronize 🔄 crucial app data to iCloud ☁️, ensuring a smooth and consistent user experience across 📱💻 multiple devices.
- By leveraging the power of iCloud, your app can store and securely retrieve 🔒 important information, documents 📄, and user preferences, keeping them safely backed up 📂 and easily accessible.
This plugin empowers you to build applications that seamlessly integrate with the iCloud ecosystem, providing your users with a reliable and convenient data management experience.

## Features ✨

 📂 Get iCloud files 

 ⬆️ Upload files to iCloud 

 ✏️ Rename iCloud files 

 🗑️ Delete iCloud files 

 ↔️ Move iCloud files 

## Getting Start  🚀

1. Installation 🛠️
- Add the iCloud_Storage_Sync plugin to your pubspec.yaml file:


```ymal
dependencies:
  iCloud_Storage_Sync: ^1.0.0
```

2. Install the Plugin ⚙️
- Run the following command to install the plugin:

```bash
flutter pub get
```
3. Usage 💻
- Import the plugin in your Dart code:

```dart
import 'package:iCloud_Storage_Sync/iCloud_Storage_Sync.dart';
```

## Prerequisites 📋

☑️ Apple Developer account

☑️ App ID and iCloud Container ID

☑️ iCloud capability enabled and assigned 

☑️ iCloud capability in Xcode

Refer to the [How to set up iCloud Container and enable the capability](#how-to-set-up-icloud-container-and-enable-the-capability) section for more detailed instructions.

`Note`: Complete these setup steps before using the plugin for proper functionality. 🔍

### Getting iCloud Files

To retrieve a list of files from iCloud:

```dart
Future<List<CloudFiles>> getCloudFiles({required String containerId}) async {
  return await icloudSyncPlugin.getCloudFiles(containerId: containerId);
}
```

### Uploading Files to iCloud

To upload a local file to iCloud:

```dart
Future<void> upload({
  required String containerId,
  required String filePath,
  String? destinationRelativePath,
  StreamHandler<double>? onProgress,
}) async {
  await icloudSyncPlugin.upload(
    containerId: containerId,
    filePath: filePath,
    destinationRelativePath: destinationRelativePath,
    onProgress: onProgress,
  );
}
```

### Renaming iCloud Files

To rename a file in iCloud:

```dart
Future<void> rename({
  required String containerId,
  required String relativePath,  
  required String newName,
}) async {
  await icloudSyncPlugin.rename(
    containerId: containerId,
    relativePath: relativePath,
    newName: newName,
  );  
}
```

### Deleting iCloud Files

To delete a file from iCloud:

```dart
Future<void> delete({
  required String containerId,
  required String relativePath,
}) async {
  await icloudSyncPlugin.delete(
    containerId: containerId,
    relativePath: relativePath,
  );
}
```

### Moving iCloud Files

To move a file within iCloud:

```dart
Future<void> move({
  required String containerId,  
  required String fromRelativePath,
  required String toRelativePath,  
}) async {
  await IcloudSyncPlatform.instance.move(
    containerId: containerId,
    fromRelativePath: fromRelativePath,
    toRelativePath: toRelativePath,
  );
}  
```
You're right, the syntax I provided for setting the image dimensions won't work in a Markdown file. Here's the correct way to do it:

## How to set up iCloud Container and enable the capability

1. Log in to your apple developer account and select 'Certificates, IDs & Profiles' from the left navigation. 🔑 

2. Select 'Identifiers' from the 'Certificates, IDs & Profiles' page, create an App ID if you haven't done so, and create an iCloud Containers ID.

<img src="https://gitlab.com/mohammedbakali.codexlancers/icloud-plugin/-/raw/main/assets/icloud_container_id.png" width="600" height="400" />

3. Click on your App ID. In the Capabilities section, select 'iCloud' and assign the iCloud Container created in step 2 to this App ID.

<img src="https://gitlab.com/mohammedbakali.codexlancers/icloud-plugin/-/raw/main/assets/assign_icloud_capability.png" width="600" height="400" />

4. Open your project in Xcode. Set your App ID as 'Bundle Identifier' if you haven't done so. Click on '+ Capability' button, select iCloud, then tick 'iCloud
Documents' in the Services section and select your iCloud container.

<img src="https://gitlab.com/mohammedbakali.codexlancers/icloud-plugin/-/raw/main/assets/xcode_capability.png" width="600" height="400" />

## Contributing 🤝

[![](https://raw.githubusercontent.com/DevCodeSpace/twilio_voice_flutter/main/assets/contributors.png)](https://github.com/DevCodeSpace/twilio_voice_flutter/graphs/contributors)