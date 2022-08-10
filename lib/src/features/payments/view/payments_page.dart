import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:receipt_app/src/features/payments/bloc/payments_bloc.dart';
import 'package:receipt_app/src/features/profile_details/bloc/profile_details_bloc.dart';
import 'package:receipt_app/src/shared/providers/validator.dart';

import '../../../shared/classes/classes.dart';
import '../../../shared/widgets/widgets.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return BlocProvider(
    //   create: (context) => PaymentsBloc(
    //     firestoreDatabaseRepository:
    //         context.read<FirestoreDatabaseRepository>(),
    //     profileOverviewCubit: context.read<ProfileOverviewCubit>(),
    //   )..add(const StreamSubscriptionRequest()),
    //   child: const PaymentsView(),
    // );
    return const PaymentsView();
  }
}

class PaymentsView extends StatelessWidget with Validator {
  const PaymentsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentsBloc, PaymentsState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == PaymentsStatus.success,
      listener: (context, state) {
        if (state.showDialog) {
          context.read<PaymentsBloc>().add(const ToggleDialog());
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<PaymentsBloc, PaymentsState>(
        builder: (context, state) {
          if (state.status == PaymentsStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == PaymentsStatus.success) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final payment in state.payments)
                      PaymentCard(
                        payment: payment,
                        onPressed: () {
                          final receiptDetails = ReceiptDetails(
                              profile: context
                                  .read<ProfileDetailsBloc>()
                                  .state
                                  .profile!,
                              payment: payment);
                          context.push(
                              '/${payment.customerId}/1/receipt/${payment.id}',
                              extra: receiptDetails);
                          // GoRouter.of(context).push(
                          //     '/${payment.customerId}/1/receipt/${payment.id}',
                          //     extra: payment);
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (_) => BlocProvider.value(
                          //       value: BlocProvider.of<ProfileDetailsBloc>(context),
                          //       child: ReceiptPage(payment: payment),
                          //     ),
                          //   ),
                          // );
                        },
                      )
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _showDialog(context);
                },
                child: const Icon(Icons.add),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  void _showDialog(BuildContext context) {
    context.read<PaymentsBloc>().add(const ToggleDialog());
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 16.0),
          title: const Text(
            'Payment',
            textAlign: TextAlign.center,
          ),
          children: [
            CustomTextFormField(
              labelText: 'Amount',
              onChanged: (value) {
                context.read<PaymentsBloc>().add(SetAmount(amount: value));
              },
              validate: validateString,
              textInputType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputFormatters: [
                // FilteringTextInputFormatter(RegExp(r'^[0-9]+$'), allow: true),
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    context.read<PaymentsBloc>().add(const AddNewPayment());
                  },
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<PaymentsBloc>().add(const ToggleDialog());
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                )
              ],
            )
          ],
        );
      },
    );
  }
}

class PaymentCard extends StatelessWidget {
  const PaymentCard({Key? key, required this.payment, required this.onPressed})
      : super(key: key);

  final Payment payment;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final createdDate = DateFormat.yMMMd('en_US').format(payment.dateCreated);
    final amount = NumberFormat('###.0#', 'en_US').format(payment.amount);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text('Amount: $amount'),
          subtitle: Text('Date: $createdDate'),
          trailing: TextButton(
            // onPressed: () async {
            //   // GoRouter.of(context).go('/${payment.customerId}/1/receipt/${payment.id}',extra: payment);

            //   // GoRouter.of(context).push(
            //   //     '/${payment.customerId}/1/receipt/${payment.id}',
            //   //     extra: payment);
            // },
            onPressed: onPressed,
            child: const Text('PRINT RECEIPT'),
          ),
        ),
      ),
    );
  }
}
