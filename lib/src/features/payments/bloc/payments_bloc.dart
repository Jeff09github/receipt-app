import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:receipt_app/src/shared/repository/firestore_database_repository.dart';

import '../../../shared/classes/payment.dart';

part 'payments_event.dart';
part 'payments_state.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  PaymentsBloc({
    required this.firestoreDatabaseRepository,
    required this.customerId,
  }) : super(const PaymentsState()) {
    on<PaymentsStreamSubscriptionRequest>(_onPaymentsStreamSubscriptionRequest);
    on<AddNewPayment>(_onAddNewPayment);
    on<ToggleDialog>(_onToggleDialog);
    on<SetAmount>(_onSetAmount);
  }

  final FirestoreDatabaseRepository firestoreDatabaseRepository;
  final String customerId;

  FutureOr<void> _onAddNewPayment(
      AddNewPayment event, Emitter<PaymentsState> emit) async {
    emit(state.copyWith(status: PaymentsStatus.loading));
    try {
      final payment = Payment(
        customerId: customerId,
        dateCreated: DateTime.now(),
        amount: double.parse(state.amount),
      );
      await firestoreDatabaseRepository.setPayment(payment: payment);
      emit(state.copyWith(status: PaymentsStatus.success));
    } catch (e) {
      emit(state.copyWith(status: PaymentsStatus.failure));
    }
  }

  FutureOr<void> _onPaymentsStreamSubscriptionRequest(
      PaymentsStreamSubscriptionRequest event,
      Emitter<PaymentsState> emit) async {
    emit(state.copyWith(status: PaymentsStatus.loading));
    await emit.forEach(
        firestoreDatabaseRepository.streamPayments(
          customerId: customerId,
        ), onData: (List<Payment> data) {
      return state.copyWith(status: PaymentsStatus.success, payments: data);
    }, onError: (_, __) {
      return state.copyWith(status: PaymentsStatus.failure);
    });
  }

  FutureOr<void> _onSetAmount(SetAmount event, Emitter<PaymentsState> emit) {
    emit(state.copyWith(status: PaymentsStatus.success, amount: event.amount));
  }

  FutureOr<void> _onToggleDialog(
      ToggleDialog event, Emitter<PaymentsState> emit) {
    emit(state.copyWith(
        status: PaymentsStatus.success, showDialog: !state.showDialog));
  }
}
