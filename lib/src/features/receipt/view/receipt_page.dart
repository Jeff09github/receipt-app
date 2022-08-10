import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:receipt_app/src/features/receipt/bloc/bloc/blue_thermal_bloc.dart';

import '../../../shared/classes/classes.dart';

class ReceiptPage extends StatelessWidget {
  const ReceiptPage({
    Key? key,
    required this.receiptDetails,
  }) : super(key: key);

  final ReceiptDetails receiptDetails;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlueThermalBloc()
        ..add(
          const LoadInitialBlueThermalData(),
        ),
      child: ReceiptView(
        receiptDetails: receiptDetails,
      ),
    );
  }
}

class ReceiptView extends StatelessWidget {
  const ReceiptView({
    Key? key,
    required this.receiptDetails,
  }) : super(key: key);

  final ReceiptDetails receiptDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ReceiptCard(
            receiptDetails: receiptDetails,
          ),
          ThermalWidget(
            receiptDetails: receiptDetails,
          ),
        ],
      ),
    );
  }
}

class ReceiptCard extends StatelessWidget {
  const ReceiptCard({Key? key, required this.receiptDetails}) : super(key: key);

  final ReceiptDetails receiptDetails;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(12.0),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'CASH RECEIPT',
                textAlign: TextAlign.center,
              ),
              Text(
                'ID No: ${receiptDetails.payment.id}',
                textAlign: TextAlign.center,
              ),
              const Divider(
                thickness: 2.0,
              ),
              const Text('Connection: PPPOE'),
              Text('Speed: ${receiptDetails.profile.speed} Mbps'),
              Text('Price: ${receiptDetails.profile.price}'),
              const Divider(
                thickness: 2.0,
              ),
              Text('Total: ${receiptDetails.profile.price}'),
              Text('Cash: ${receiptDetails.payment.amount}'),
              Text(
                  'Change: ${receiptDetails.profile.price - receiptDetails.payment.amount}'),
              Text(
                  'Trans Date: ${DateFormat.yMMMd('en_US').format(receiptDetails.payment.dateCreated)}'),
              const Divider(
                thickness: 2.0,
              ),
              const Text('FB Page:/zzigg.biz'),
            ],
          ),
        ),
      ),
    );
    // return BlocBuilder<ReceiptBloc, ReceiptState>(
    //   buildWhen: (previous, current) =>
    //       (previous.status != current.status &&
    //           current.status == ReceiptStatus.success) ||
    //       (previous.status == current.status &&
    //           previous.blueThermalStatus != current.blueThermalStatus),
    //   builder: (context, state) {
    //     if (state.status == ReceiptStatus.loading) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     } else if (state.status == ReceiptStatus.success) {
    //       final details = state.receiptDetails!;

    //     } else {
    //       return Text('Status Failed');
    //     }
    //   },
    // );
  }
}

class ThermalWidget extends StatelessWidget {
  const ThermalWidget({Key? key, required this.receiptDetails})
      : super(key: key);

  final ReceiptDetails receiptDetails;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlueThermalBloc, BlueThermalState>(
      builder: (context, state) {
        switch (state.status) {
          case BlueThermalStatus.loading:
            return const CircularProgressIndicator();
          case BlueThermalStatus.notAvailable:
            return const Text('Bluetooth not Available!');
          case BlueThermalStatus.off:
            return const Text('Bluetooth is OFF!');
          case BlueThermalStatus.error:
            return const Text('Thermal State Error!');
          default:
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton(
                      value: state.selectedDevice,
                      hint: const Icon(Icons.print_rounded),
                      items: state.devices
                          .map<DropdownMenuItem<BluetoothDevice>>(
                            (e) => DropdownMenuItem<BluetoothDevice>(
                              value: e,
                              child: Text(e.name!),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        context.read<BlueThermalBloc>().add(
                            SelectDevice(device: value as BluetoothDevice));
                      },
                    ),
                    if (state.selectedDevice == null)
                      const Text('Select a Device')
                    else
                      state.status == BlueThermalStatus.connected
                          ? OutlinedButton(
                              onPressed: () {
                                context
                                    .read<BlueThermalBloc>()
                                    .add(const DisconnectDevice());
                              },
                              child: const Text('Disconnect'),
                            )
                          : OutlinedButton(
                              onPressed: () {
                                context
                                    .read<BlueThermalBloc>()
                                    .add(const ConnectDevice());
                              },
                              child: const Text('Connect'),
                            ),
                  ],
                ),
                OutlinedButton(
                  onPressed: state.status == BlueThermalStatus.connected
                      ? () {
                          context
                              .read<BlueThermalBloc>()
                              .add(Print(receiptDetails: receiptDetails));
                        }
                      : null,
                  child: const Text('PRINT'),
                ),
              ],
            );
        }
      },
    );
  }
}
