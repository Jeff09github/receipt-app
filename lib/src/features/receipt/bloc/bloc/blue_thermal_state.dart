part of 'blue_thermal_bloc.dart';

enum BlueThermalStatus {
  notAvailable,
  isAvailable,
  on,
  off,
  connected,
  disconnected,
  loading,
  error,
}

class BlueThermalState extends Equatable {
  const BlueThermalState({
    this.status = BlueThermalStatus.loading,
    this.bluetoothIsEnabled = false,
    this.devices = const [],
    this.selectedDevice,
  });

  final BlueThermalStatus status;
  final bool bluetoothIsEnabled;
  final List<BluetoothDevice> devices;
  final BluetoothDevice? selectedDevice;

  BlueThermalState copyWith({
    BlueThermalStatus? status,
    bool? bluetoothIsEnabled,
    List<BluetoothDevice>? devices,
    BluetoothDevice? selectedDevice,
  }) =>
      BlueThermalState(
        status: status ?? this.status,
        bluetoothIsEnabled: bluetoothIsEnabled ?? this.bluetoothIsEnabled,
        devices: devices ?? this.devices,
        selectedDevice: selectedDevice ?? this.selectedDevice,
      );

  @override
  List<Object?> get props =>
      [status, bluetoothIsEnabled, devices, selectedDevice];
}
