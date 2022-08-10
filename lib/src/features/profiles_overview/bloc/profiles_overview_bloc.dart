import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:receipt_app/src/shared/repository/firestore_database_repository.dart';

import '../../../shared/classes/classes.dart';

part 'profiles_overview_event.dart';
part 'profiles_overview_state.dart';

class ProfilesOverviewBloc
    extends Bloc<ProfilesOverviewEvent, ProfilesOverviewState> {
  ProfilesOverviewBloc({required this.firestoreDatabaseRepository})
      : super(const ProfilesOverviewState()) {
    on<StreamSubscriptionRequest>(_onStreamSubscriptionRequest);
    on<DeleteProfile>(_onDeleteProfile);
  }

  final FirestoreDatabaseRepository firestoreDatabaseRepository;

  FutureOr<void> _onStreamSubscriptionRequest(
    StreamSubscriptionRequest event,
    Emitter<ProfilesOverviewState> emit,
  ) async {
    emit(state.copyWith(status: ProfilesOverviewStatus.loading));
    await emit.forEach<List<Profile>>(
      firestoreDatabaseRepository.streamProfiles(filter: event.filter),
      onData: (profiles) => state.copyWith(
          status: ProfilesOverviewStatus.success, profiles: profiles),
      onError: (_, __) {
        return state.copyWith(status: ProfilesOverviewStatus.failure);
      },
    );
  }

  FutureOr<void> _onDeleteProfile(
      DeleteProfile event, Emitter<ProfilesOverviewState> emit) async {
    emit(state.copyWith(status: ProfilesOverviewStatus.loading));
    try {
      await firestoreDatabaseRepository.deleteProfile(profile: event.profile);
      emit(state.copyWith(status: ProfilesOverviewStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ProfilesOverviewStatus.failure));
    }
  }
}
