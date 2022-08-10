import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Profile extends Equatable {
  Profile(
      {String? id,
      required this.customerName,
      required this.speed,
      required this.price})
      : assert(
          id == null || id.isNotEmpty,
        ),
        id = id ?? const Uuid().v4();

  final String id;
  final String customerName;
  final int speed;
  final double price;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json['id'],
        customerName: json['customerName'],
        speed: json['speed'],
        price: json['price'],
      );

  Map<String, dynamic> toJson() =>
      {'id': id, 'customerName': customerName, 'speed': speed, 'price': price};

  Profile copyWith({
    String? id,
    String? customerName,
    int? speed,
    double? price,
  }) =>
      Profile(
          id: id ?? this.id,
          customerName: customerName ?? this.customerName,
          speed: speed ?? this.speed,
          price: price ?? this.price);

  @override
  List<Object?> get props => [id, customerName, speed, price];
}
