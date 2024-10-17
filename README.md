# iCloud_Storage_Sync Plugin 📦☁️

A Flutter plugin for seamless iCloud integration in your iOS apps.

![iCloud Storage Sync Banner](https://raw.githubusercontent.com/DevCodeSpace/icloud_storage_sync/main/assets/icloud_storage_sync_pub_dev_banner.jpg)

## Introduction 🌟

iCloud_Storage_Sync simplifies iCloud storage integration for your Flutter iOS apps:

Backup and sync app data effortlessly 🔄

Ensure consistent user experience across devices 📱💻

Securely store and retrieve important information 🔒

Seamlessly integrate with the iCloud ecosystem ☁️

<br>

## Features ✨

📂 Get iCloud files

⬆️ Upload files to iCloud

✏️ Rename iCloud files

🗑️ Delete iCloud files

↔️ Move iCloud files

<br>

## Getting Started 🚀

### 1. Installation 🛠️

Add to your `pubspec.yaml`:

```yaml
dependencies:
  icloud_storage_sync: ^1.0.0
```

### 2. Install the Plugin ⚙️

Run:

```bash
flutter pub get
```

### 3. Usage 💻

Import in your Dart code:

```dart
import 'package:icloud_storage_sync/icloud_storage_sync.dart';
```

## Prerequisites 📋

Before using the plugin, ensure you have:

☑️ Apple Developer account

☑️ App ID and iCloud Container ID

☑️ iCloud capability enabled and assigned

☑️ iCloud capability in Xcode

See [How to set up iCloud Container](#how-to-set-up-icloud-container-and-enable-the-capability) for detailed instructions.

<br>

## API Examples

### Getting iCloud Files

```dart
Future<List<CloudFiles>> getCloudFiles({required String containerId}) async {
  return await icloudSyncPlugin.getCloudFiles(containerId: containerId);
}
```

### Uploading Files to iCloud

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

## How to set up iCloud Container and enable the capability

1. Log in to your Apple Developer account and select 'Certificates, IDs & Profiles'.

2. Create an App ID (if needed) and an iCloud Containers ID:

   ![iCloud Container ID](https://raw.githubusercontent.com/DevCodeSpace/icloud_storage_sync/main/assets/icloud_container_id.png)

3. Assign the iCloud Container to your App ID:

   ![Assign iCloud Capability](https://raw.githubusercontent.com/DevCodeSpace/icloud_storage_sync/main/assets/assign_icloud_capability.png)

4. In Xcode, enable iCloud capability and select your container:

   ![Xcode Capability](https://raw.githubusercontent.com/DevCodeSpace/icloud_storage_sync/main/assets/xcode_capability.png)