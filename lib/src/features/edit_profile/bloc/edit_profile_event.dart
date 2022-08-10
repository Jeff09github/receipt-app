part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class CustomerChanged extends EditProfileEvent {
  const CustomerChanged({required this.customer});
  final String customer;

  @override
  List<Object> get props => [customer];
}

class SpeedChanged extends EditProfileEvent {
  const SpeedChanged({required this.speed});
  final String speed;

  @override
  List<Object> get props => [speed];
}

class AmountChanged extends EditProfileEvent {
  const AmountChanged({required this.amount});
  final String amount;

  @override
  List<Object> get props => [amount];
}

class Submitted extends EditProfileEvent {}
