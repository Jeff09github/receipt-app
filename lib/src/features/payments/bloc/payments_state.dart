part of 'payments_bloc.dart';

enum PaymentsStatus { initial, loading, success, failure }

class PaymentsState extends Equatable {
  const PaymentsState({
    this.status = PaymentsStatus.initial,
    this.payments = const [],
    this.amount = '0.0',
    this.showDialog = false,
  });

  final PaymentsStatus status;
  final List<Payment> payments;
  final String amount;
  final bool showDialog;

  PaymentsState copyWith(
          {PaymentsStatus? status,
          List<Payment>? payments,
          String? amount,
          bool? showDialog}) =>
      PaymentsState(
        status: status ?? this.status,
        payments: payments ?? this.payments,
        amount: amount ?? this.amount,
        showDialog: showDialog ?? this.showDialog,
      );

  @override
  List<Object> get props => [status, payments, amount, showDialog];
}
