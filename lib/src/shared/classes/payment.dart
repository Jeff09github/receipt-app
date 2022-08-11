import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Payment extends Equatable {
  Payment({
    String? id,
    required this.customerId,
    required this.dateCreated,
    required this.balance,
    required this.amount,
  })  : assert(id == null || id.isNotEmpty),
        id = id ?? const Uuid().v4();

  final String id;
  final String customerId;
  final DateTime dateCreated;
  final double balance;
  final double amount;

  Payment copyWith(
    String? id,
    String? customerId,
    DateTime? dateCreated,
    double? balance,
    double? amount,
  ) =>
      Payment(
        id: id ?? this.id,
        customerId: customerId ?? this.customerId,
        dateCreated: dateCreated ?? this.dateCreated,
        balance: balance ?? this.balance,
        amount: amount ?? this.amount,
      );

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json['id'],
        customerId: json['customerId'],
        dateCreated: DateTime.parse(json['dateCreated'] as String),
        balance: json['balance'] ?? 0.0,
        amount: json['amount'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerId': customerId,
        'dateCreated': dateCreated.toIso8601String(),
        'balance': balance,
        'amount': amount,
      };

  @override
  List<Object?> get props => [id, customerId, dateCreated, balance, amount];
}
