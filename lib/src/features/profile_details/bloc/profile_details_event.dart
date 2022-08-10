part of 'profile_details_bloc.dart';

abstract class ProfileDetailsEvent extends Equatable {
  const ProfileDetailsEvent();

  @override
  List<Object> get props => [];
}

class ProfileStreamSubscriptionRequest extends ProfileDetailsEvent {
  const ProfileStreamSubscriptionRequest();
}
