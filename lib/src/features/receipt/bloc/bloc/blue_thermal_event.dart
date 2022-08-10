part of 'blue_thermal_bloc.dart';

abstract class BlueThermalEvent extends Equatable {
  const BlueThermalEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialBlueThermalData extends BlueThermalEvent {
  const LoadInitialBlueThermalData();
}

class StreamRequestOnStateChanged extends BlueThermalEvent {
  const StreamRequestOnStateChanged();
}

class SelectDevice extends BlueThermalEvent {
  const SelectDevice({required this.device});
  final BluetoothDevice device;

  @override
  List<Object> get props => [device];
}

class CheckDeviceConnection extends BlueThermalEvent {
  const CheckDeviceConnection();
}

class ConnectDevice extends BlueThermalEvent {
  const ConnectDevice();
}

class DisconnectDevice extends BlueThermalEvent {
  const DisconnectDevice();
}

class Print extends BlueThermalEvent {
  const Print({required this.receiptDetails});
  final ReceiptDetails receiptDetails;
  @override
  List<Object> get props => [receiptDetails];
}
