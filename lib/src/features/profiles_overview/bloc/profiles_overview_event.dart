part of 'profiles_overview_bloc.dart';

abstract class ProfilesOverviewEvent extends Equatable {
  const ProfilesOverviewEvent();

  @override
  List<Object?> get props => [];
}

class StreamSubscriptionRequest extends ProfilesOverviewEvent {
  const StreamSubscriptionRequest({this.filter});
  final String? filter;
  @override
  List<Object?> get props => [filter];
}

class DeleteProfile extends ProfilesOverviewEvent {
  final Profile profile;

  const DeleteProfile({required this.profile});
}
