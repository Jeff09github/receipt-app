part of 'profile_details_bloc.dart';

enum ProfileDetailsStatus { initial, loading, success, failure }

class ProfileDetailsState extends Equatable {
  const ProfileDetailsState({
    this.profile,
    this.status = ProfileDetailsStatus.initial,
  });

  final ProfileDetailsStatus status;
  final Profile? profile;

  ProfileDetailsState copyWith(
          {ProfileDetailsStatus? status, Profile? profile}) =>
      ProfileDetailsState(
          profile: profile ?? this.profile, status: status ?? this.status);

  @override
  List<Object?> get props => [status, profile];
}
