part of 'payments_bloc.dart';

abstract class PaymentsEvent extends Equatable {
  const PaymentsEvent();

  @override
  List<Object> get props => [];
}

class PaymentsStreamSubscriptionRequest extends PaymentsEvent {
  const PaymentsStreamSubscriptionRequest();
}

class AddNewPayment extends PaymentsEvent {
  const AddNewPayment();
}

class ToggleDialog extends PaymentsEvent {
  const ToggleDialog();
}

class SetAmount extends PaymentsEvent {
  const SetAmount({required this.amount});
  final String amount;

  @override
  List<Object> get props => [amount];
}

class SetBalance extends PaymentsEvent {
  const SetBalance({required this.balance});
  final String balance;

  @override
  List<Object> get props => [balance];
}
