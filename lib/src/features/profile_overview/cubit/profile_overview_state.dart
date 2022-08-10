part of 'profile_overview_cubit.dart';

class ProfileOverviewState extends Equatable {
  const ProfileOverviewState({required this.profileId, required this.index});

  final String profileId;
  final int index;

  ProfileOverviewState copyWith({String? profileId, int? index}) =>
      ProfileOverviewState(
          profileId: profileId ?? this.profileId, index: index ?? this.index);

  @override
  List<Object> get props => [profileId, index];
}
