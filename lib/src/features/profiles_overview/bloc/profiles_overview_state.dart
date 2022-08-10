part of 'profiles_overview_bloc.dart';

enum ProfilesOverviewStatus { initial, loading, success, failure }

class ProfilesOverviewState extends Equatable {
  final List<Profile> profiles;
  final ProfilesOverviewStatus status;

  const ProfilesOverviewState({
    this.profiles = const <Profile>[],
    this.status = ProfilesOverviewStatus.initial,
  });

  ProfilesOverviewState copyWith(
          {List<Profile>? profiles, ProfilesOverviewStatus? status}) =>
      ProfilesOverviewState(
        profiles: profiles ?? this.profiles,
        status: status ?? this.status,
      );

  @override
  List<Object> get props => [profiles, status];
}
