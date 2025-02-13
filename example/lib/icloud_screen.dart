import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icloud_storage_sync/models/icloud_file_download.dart';
import 'package:icloud_storage_sync_example/controller/icloud_plugin_controller.dart';
import 'package:icloud_storage_sync_example/icloud_state.dart';
import 'package:path/path.dart' as path;

/// Widget for displaying and managing iCloud files
class IcloudScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const IcloudScreen({super.key, this.userData});

  @override
  State<IcloudScreen> createState() => _IcloudScreenState();
}

class _IcloudScreenState extends State<IcloudScreen> {
  // Get instance of IcloudController
  final IcloudController icloudController = Get.find<IcloudController>();

  @override
  void initState() {
    super.initState();
    // Fetch cloud files after widget is built
    Future.delayed(Duration.zero, () {
      getCloudFiles();
    });
  }

  /// Fetch cloud files and update the UI
  Future<void> getCloudFiles() async {
    icloudController.cloudFiles!.value = [];
    icloudController.cloudFiles!.value = await icloudController.getCloudFiles();
    icloudController.cloudFilesNameList.clear();

    for (var file in icloudController.cloudFiles!) {
      icloudController.cloudFilesNameList
          .add(TextEditingController(text: file.title));
    }
    icloudController.cloudFiles!.sort((a, b) => b.lastSyncDt!
        .compareTo(a.lastSyncDt!)); // Descending order (latest first)

    icloudController.cloudFiles!.refresh();
    icloudController.cloudFilesNameList.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('iCloud Files'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        body: Obx(() => _buildBody()),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await icloudController.pickMultipleFile().whenComplete(() async {
              if (icloudController.iCloudIsAutoSync.value) {
                await getCloudFiles();
              }
            });
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Files'),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  /// Build the main body of the screen
  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        // Auto sync toggle
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                    child: Text("Auto sync",
                        style: Theme.of(context).textTheme.bodyLarge)),
                Switch.adaptive(
                    value: icloudController.iCloudIsAutoSync.value,
                    onChanged: (e) {
                      icloudController.iCloudIsAutoSync.value = e;
                    })
              ],
            ),
          ),
        ),
        _buildSectionHeader('Selected Files', isUploadAll: true),
        _buildSelectedFilesList(),
        _buildSectionHeader('Cloud Files', deleteMultiple: true),
        _buildCloudFilesList(),
      ],
    );
  }

  /// Build section header with optional buttons
  Widget _buildSectionHeader(String title,
      {bool isUploadAll = false, bool deleteMultiple = false}) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            // "Sync All" button for selected files
            !isUploadAll
                ? const SizedBox()
                : icloudController.iCloudIsAutoSync.value == true
                    ? const SizedBox()
                    : ElevatedButton.icon(
                        onPressed: () async {
                          await icloudController
                              .uploadMultipleFileToICloud()
                              .then((e) async {
                            if (e == SynciCloudResult.completed) {
                              await getCloudFiles();
                            }
                          });
                        },
                        icon: const Icon(Icons.cloud_upload),
                        label: const Text("Sync All"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
            // "Delete multiple" button for cloud files
            !deleteMultiple
                ? const SizedBox()
                : ElevatedButton(
                    onPressed: () async {
                      icloudController.isDeleteMultipleFiles.value =
                          !icloudController.isDeleteMultipleFiles.value;
                      log("-=-=-=-  !icloudController.isDeleteMultipleFiles.value ${!icloudController.isDeleteMultipleFiles.value} ");
                      icloudController.isDeleteMultipleFiles.refresh();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      foregroundColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    child: const Text("Delete multiple"),
                  ),
          ],
        ),
      ),
    );
  }

  /// Build list of selected files
  Widget _buildSelectedFilesList() {
    return icloudController.selectedFiles.isEmpty
        ? SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No Selected Files',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ),
          )
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildSelectedFileItem(index),
              childCount: icloudController.selectedFiles.length,
            ),
          );
  }

  /// Build list of cloud files
  Widget _buildCloudFilesList() {
    return icloudController.cloudFiles?.isEmpty ?? true
        ? SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No Cloud Files',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ),
          )
        : SliverList.list(children: [
            // "Delete" button for multiple cloud files
            icloudController.selectedFilesRelativePath.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        icloudController
                            .deleteMultipleFileFromiCloud()
                            .then((e) async {
                          if (e == SynciCloudResult.completed) {
                            await getCloudFiles();
                          }
                        });
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text("Delete"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  )
                : const SizedBox(),
            // List of cloud files
            ListView.builder(
              itemCount: icloudController.cloudFiles?.length ?? 0,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _buildCloudFileItem(index);
              },
            ),
          ]);
  }

  /// Build individual selected file item
  Widget _buildSelectedFileItem(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: Icon(Icons.insert_drive_file,
            color: Theme.of(context).colorScheme.primary),
        title: Text(
          icloudController.selectedFiles[index].path.split("/").last,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: ElevatedButton.icon(
          onPressed: () async {
            await icloudController
                .uploadFileToICloud(icloudController.selectedFiles[index].path)
                .then((e) async {
              if (e == SynciCloudResult.completed) {
                icloudController.selectedFiles.removeAt(index);
                await getCloudFiles();
              }
            });
          },
          icon: const Icon(Icons.cloud_upload),
          label: const Text("Upload"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  /// Build individual cloud file item
  Widget _buildCloudFileItem(int index) {
    CloudFiles cloudFile = icloudController.cloudFiles![index];
    return Obx(
      () => !icloudController.cloudFilesNameList[index].text
              .contains(icloudController.searchIcloudFileController.value.text)
          ? const SizedBox()
          : Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              child: ExpansionTile(
                leading: icloudController.isDeleteMultipleFiles.value == true
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: icloudController.selectedFilesRelativePath
                                .any((e) => e == cloudFile.relativePath),
                            onChanged: (e) {
                              if (e == true) {
                                icloudController.selectedFilesRelativePath
                                    .add(cloudFile.relativePath ?? "");
                              } else {
                                icloudController.selectedFilesRelativePath
                                    .remove(cloudFile.relativePath);
                              }
                            }),
                      )
                    : Icon(Icons.cloud,
                        color: Theme.of(context).colorScheme.secondary),
                title: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryContainer
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            // Editable file name
                            Expanded(
                              child: TextField(
                                controller:
                                    icloudController.cloudFilesNameList[index],
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Cancel rename
                                InkWell(
                                  onTap: () {
                                    icloudController.cloudFilesNameList[index]
                                        .text = cloudFile.title;
                                    icloudController.cloudFilesNameList
                                        .refresh();
                                  },
                                  child: Icon(Icons.close,
                                      color:
                                          Theme.of(context).colorScheme.error),
                                ),
                                // Confirm rename
                                InkWell(
                                  onTap: () async {
                                    await icloudController
                                        .renameFile(
                                      cloudFile,
                                      icloudController
                                          .cloudFilesNameList[index].text,
                                    )
                                        .then((dat) {
                                      getCloudFiles();
                                    });
                                  },
                                  child: Icon(Icons.check,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Delete single file
                    InkWell(
                        onTap: () async {
                          await icloudController
                              .deleteFileFromiCloud(
                                  relativePath: cloudFile.relativePath ?? '')
                              .then((dat) async {
                            await Future.delayed(const Duration(seconds: 2),
                                () async {
                              await getCloudFiles();
                            });
                          });
                        },
                        child: Icon(Icons.delete,
                            color: Theme.of(context).colorScheme.error)),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(Icons.folder, "Path", cloudFile.filePath),
                        const SizedBox(height: 8),
                        _buildInfoRow(Icons.storage, "Size",
                            "${(cloudFile.sizeInBytes / (1024 * 1024)).toStringAsFixed(3)} MB"),
                        const SizedBox(height: 8),
                        _buildInfoRow(Icons.calendar_today, "File Date",
                            cloudFile.fileDate.toString()),
                        const SizedBox(height: 8),
                        ElevatedButton(
                            onPressed: () async {
                              // Replace file
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type: FileType.image,
                              );

                              if (result != null) {
                                List<File> files = result.paths
                                    .map((path) => File(path!))
                                    .toList();
                                for (var file in files) {
                                  String fileName =
                                      path.basenameWithoutExtension(file.path);
                                  if (fileName.contains(".")) {
                                    Get.snackbar("Warning",
                                        "$fileName Please rename this file (.) not allow in file name",
                                        duration: const Duration(seconds: 2));
                                  } else {
                                    await icloudController
                                        .replaceFile(
                                            updatedFilePath: file.path,
                                            relativePath:
                                                cloudFile.relativePath!)
                                        .then((e) async {
                                      await getCloudFiles();
                                    });
                                  }
                                }
                              } else {
                                Get.snackbar("Warning", "Please select file");
                              }
                            },
                            child: const Text("Replace File"))
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// Build information row for cloud file details
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text("$label: ",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        Expanded(
          child: Text(value,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
