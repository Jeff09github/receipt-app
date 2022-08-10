import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:receipt_app/src/shared/classes/classes.dart';

part 'blue_thermal_event.dart';
part 'blue_thermal_state.dart';

class BlueThermalBloc extends Bloc<BlueThermalEvent, BlueThermalState> {
  BlueThermalBloc() : super(const BlueThermalState()) {
    on<LoadInitialBlueThermalData>(_onLoadInitialBlueThermalData);
    on<StreamRequestOnStateChanged>(_onStreamRequestOnStateChanged);
    on<SelectDevice>(_onSelectDevice);
    on<ConnectDevice>(_onConnectDevice);
    on<DisconnectDevice>(_onDisconnectDevice);
    on<Print>(_onPrint);
  }

  FutureOr<void> _onLoadInitialBlueThermalData(
      LoadInitialBlueThermalData event, Emitter<BlueThermalState> emit) async {
    final bluetoothThermal = BlueThermalPrinter.instance;
    try {
      final bluetoothRequest = await Permission.bluetooth.request().isGranted;
      final blutoothScan = await Permission.bluetoothScan.request().isGranted;
      final bluetoothConnect =
          await Permission.bluetoothConnect.request().isGranted;
      final bluetoothAdvertise =
          await Permission.bluetoothAdvertise.request().isGranted;

      final isBluetoothAvaiable = await bluetoothThermal.isAvailable;
      if ((bluetoothRequest ||
              blutoothScan ||
              bluetoothConnect ||
              bluetoothAdvertise) &&
          isBluetoothAvaiable == true) {
        final devices = await bluetoothThermal.getBondedDevices();
        emit(
          state.copyWith(
            devices: devices,
            status: BlueThermalStatus.isAvailable,
          ),
        );
        add(const StreamRequestOnStateChanged());
      } else {
        emit(
          state.copyWith(
            status: BlueThermalStatus.notAvailable,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: BlueThermalStatus.error));
    }
  }

  FutureOr<void> _onStreamRequestOnStateChanged(
      StreamRequestOnStateChanged event, Emitter<BlueThermalState> emit) async {
    final bluetoothThermal = BlueThermalPrinter.instance;
    try {
      await emit.forEach(
        bluetoothThermal.onStateChanged(),
        onData: (data) {
          switch (data) {
            case BlueThermalPrinter.STATE_OFF:
              {
                return state.copyWith(status: BlueThermalStatus.off);
              }
            case BlueThermalPrinter.STATE_ON:
              {
                return state.copyWith(status: BlueThermalStatus.on);
              }
            case BlueThermalPrinter.DISCONNECTED:
              {
                return state.copyWith(status: BlueThermalStatus.disconnected);
              }
            case BlueThermalPrinter.CONNECTED:
              {
                return state.copyWith(status: BlueThermalStatus.connected);
              }
            case BlueThermalPrinter.ERROR:
              return state.copyWith(
                status: BlueThermalStatus.error,
              );
            default:
              return state;
          }
        },
        onError: (_, __) {
          return state.copyWith(status: BlueThermalStatus.error);
        },
      );
    } catch (e) {
      emit(state.copyWith(status: BlueThermalStatus.error));
    }
  }

  FutureOr<void> _onSelectDevice(
      SelectDevice event, Emitter<BlueThermalState> emit) async {
    final bluetoothThermal = BlueThermalPrinter.instance;
    final isConnected = await bluetoothThermal.isDeviceConnected(event.device);

    emit(state.copyWith(
        selectedDevice: event.device,
        status: isConnected == true
            ? BlueThermalStatus.connected
            : BlueThermalStatus.disconnected));
  }

  FutureOr<void> _onConnectDevice(
      ConnectDevice event, Emitter<BlueThermalState> emit) async {
    final bluetoothThermal = BlueThermalPrinter.instance;
    emit(state.copyWith(status: BlueThermalStatus.loading));
    try {
      final result = await bluetoothThermal.connect(state.selectedDevice!);
      if (result == true) {
        emit(state.copyWith(status: BlueThermalStatus.connected));
      }
    } catch (e) {
      emit(state.copyWith(status: BlueThermalStatus.error));
    }
  }

  FutureOr<void> _onDisconnectDevice(
      DisconnectDevice event, Emitter<BlueThermalState> emit) async {
    final bluetoothThermal = BlueThermalPrinter.instance;
    emit(state.copyWith(status: BlueThermalStatus.loading));
    try {
      await bluetoothThermal.disconnect();
      emit(state.copyWith(status: BlueThermalStatus.disconnected));
    } catch (e) {
      emit(state.copyWith(status: BlueThermalStatus.error));
    }
  }

  FutureOr<void> _onPrint(Print event, Emitter<BlueThermalState> emit) {
    final bluetoothThermal = BlueThermalPrinter.instance;
    emit(state.copyWith(status: BlueThermalStatus.loading));
    try {
      bluetoothThermal.printCustom('CASH RECEIPT', 3, 1);
      bluetoothThermal.printCustom(
          'ID NO. ${event.receiptDetails.payment.id}', 0, 1);
      bluetoothThermal.printCustom(
          'Customer ID. ${event.receiptDetails.payment.customerId}', 0, 1);
      bluetoothThermal.printCustom('--------------------------------', 1, 1);
      bluetoothThermal.printNewLine();
      bluetoothThermal.printLeftRight('Connection', 'PPPOE', 0);
      bluetoothThermal.printLeftRight(
          'Speed', '${event.receiptDetails.profile.speed.toString()} Mbps', 0);
      bluetoothThermal.printLeftRight(
          'Amount', event.receiptDetails.profile.price.toString(), 0);
      bluetoothThermal.printCustom('--------------------------------', 1, 1);
      bluetoothThermal.printLeftRight(
          'Total', event.receiptDetails.profile.price.toString(), 2);
      bluetoothThermal.printLeftRight(
          'Cash', event.receiptDetails.payment.amount.toString(), 0);
      bluetoothThermal.printLeftRight(
          'Change',
          (event.receiptDetails.payment.amount -
                  event.receiptDetails.profile.price)
              .toString(),
          0);
      bluetoothThermal.printCustom('--------------------------------', 1, 1);
      bluetoothThermal.printNewLine();
      bluetoothThermal.printCustom(
          'Date of Trans. ${DateFormat.yMMMd('en_US').format(event.receiptDetails.payment.dateCreated)}',
          1,
          1);
      bluetoothThermal.printCustom('FB Page: /zzigg.biz', 1, 1);
      emit(state.copyWith(status: BlueThermalStatus.connected));
    } catch (e) {
      emit(state.copyWith(status: BlueThermalStatus.error));
    }
  }
}
