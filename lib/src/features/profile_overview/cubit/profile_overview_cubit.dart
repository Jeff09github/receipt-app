import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_overview_state.dart';

class ProfileOverviewCubit extends Cubit<ProfileOverviewState> {
  ProfileOverviewCubit({
    required this.profileId,
    required this.index,
  }) : super(ProfileOverviewState(profileId: profileId, index: index));

  final String profileId;
  final int index;

  void changeTabIndex(int index) {
    emit(state.copyWith(index: index));
  }
}
