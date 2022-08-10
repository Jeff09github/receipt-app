import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:receipt_app/src/shared/repository/firestore_database_repository.dart';

import '../../../shared/classes/classes.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc(
      {required this.firestoreDatabaseRepository, this.initialProfile})
      : super(
          EditProfileState(
            profile: initialProfile,
            customerName: initialProfile?.customerName ?? '',
            speed: initialProfile?.speed.toString() ?? '',
            amount: initialProfile?.price.toString() ?? '',
          ),
        ) {
    on<CustomerChanged>(_onCustomerChanged);
    on<SpeedChanged>(_onSpeedChanged);
    on<AmountChanged>(_onAmountChanged);
    on<Submitted>(_onSubmitted);
  }

  final FirestoreDatabaseRepository firestoreDatabaseRepository;
  final Profile? initialProfile;

  FutureOr<void> _onCustomerChanged(
      CustomerChanged event, Emitter<EditProfileState> emit) {
    emit(state.copyWith(customerName: event.customer));
  }

  FutureOr<void> _onSpeedChanged(
      SpeedChanged event, Emitter<EditProfileState> emit) {
    emit(state.copyWith(speed: event.speed));
  }

  FutureOr<void> _onAmountChanged(
      AmountChanged event, Emitter<EditProfileState> emit) {
    emit(state.copyWith(amount: event.amount));
  }

  FutureOr<void> _onSubmitted(
      Submitted event, Emitter<EditProfileState> emit) async {
    emit(state.copyWith(status: EditProfileStatus.loading));
    final profile =
        (state.profile ?? Profile(customerName: '', speed: 0, price: 0.0))
            .copyWith(
                customerName: state.customerName,
                speed: int.parse(state.speed),
                price: double.parse(state.amount));
    try {
      await firestoreDatabaseRepository.setProfile(profile: profile);
      emit(state.copyWith(status: EditProfileStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditProfileStatus.failed));
    }
  }

  bool get isNewProfile => initialProfile == null;
}
