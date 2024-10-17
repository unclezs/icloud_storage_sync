// Enum to represent the connection state of iCloud
enum ICloudState {
  notConnected, // iCloud is not connected
  connected, // iCloud is successfully connected
  connecting, // iCloud is in the process of connecting
}

// Enum to represent the result of syncing with iCloud
enum SynciCloudResult {
  failed, // Sync operation failed
  completed, // Sync operation completed successfully
  skipped // Sync operation was skipped
}
