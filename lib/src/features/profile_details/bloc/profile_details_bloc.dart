import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../shared/classes/classes.dart';
import '../../../shared/repository/firestore_database_repository.dart';

part 'profile_details_event.dart';
part 'profile_details_state.dart';

class ProfileDetailsBloc
    extends Bloc<ProfileDetailsEvent, ProfileDetailsState> {
  ProfileDetailsBloc({
    required this.firestoreDatabaseRepository,
    required this.customerId,
  }) : super(const ProfileDetailsState()) {
    on<ProfileStreamSubscriptionRequest>(_onProfileStreamSubscriptionRequest);
  }

  final FirestoreDatabaseRepository firestoreDatabaseRepository;
  final String customerId;

  FutureOr<void> _onProfileStreamSubscriptionRequest(
      ProfileStreamSubscriptionRequest event,
      Emitter<ProfileDetailsState> emit) async {
    emit(state.copyWith(status: ProfileDetailsStatus.loading));

    await emit
        .forEach(firestoreDatabaseRepository.streamProfile(id: customerId),
            onData: (Profile data) {
      return state.copyWith(
          status: ProfileDetailsStatus.success, profile: data);
    });
  }
}
