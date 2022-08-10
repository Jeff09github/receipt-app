part of 'edit_profile_bloc.dart';

enum EditProfileStatus { initial, loading, success, failed }

class EditProfileState extends Equatable {
  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.profile,
    this.customerName = '',
    this.speed = '',
    this.amount = '',
  });

  final EditProfileStatus status;
  final Profile? profile;
  final String customerName;
  final String speed;
  final String amount;

  EditProfileState copyWith({
    EditProfileStatus? status,
    Profile? profile,
    String? customerName,
    String? speed,
    String? amount,
  }) =>
      EditProfileState(
        status: status ?? this.status,
        profile: profile ?? this.profile,
        customerName: customerName ?? this.customerName,
        speed: speed ?? this.speed,
        amount: amount ?? this.amount,
      );

  @override
  List<Object?> get props => [
        status,
        profile,
        customerName,
        speed,
        amount,
      ];
}
