import 'package:intl/intl.dart';

class Booking {
  final String id;
  final String userId;
  final String hotelId;
  final String roomId;
  final DateTime checkIn;
  final DateTime checkOut;
  final double totalPrice;
  final String status; // confirmed, pending, cancelled
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.userId,
    required this.hotelId,
    required this.roomId,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      hotelId: json['hotel_id'],
      roomId: json['room_id'],
      checkIn: DateTime.parse(json['check_in']),
      checkOut: DateTime.parse(json['check_out']),
      totalPrice: json['total_price'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'hotel_id': hotelId,
      'room_id': roomId,
      'check_in': DateFormat('yyyy-MM-dd').format(checkIn),
      'check_out': DateFormat('yyyy-MM-dd').format(checkOut),
      'total_price': totalPrice,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class ParkingBooking {
  final String id;
  final String userId;
  final String hotelId;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;
  final String status;

  ParkingBooking({
    required this.id,
    required this.userId,
    required this.hotelId,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
  });

  factory ParkingBooking.fromJson(Map<String, dynamic> json) {
    return ParkingBooking(
      id: json['id'],
      userId: json['user_id'],
      hotelId: json['hotel_id'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      totalPrice: json['total_price'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'hotel_id': hotelId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'total_price': totalPrice,
      'status': status,
    };
  }
}

class Order {
  final String id;
  final String userId;
  final String hotelId;
  final List<OrderItem> items;
  final double totalPrice;
  final String status; // ordered, preparing, ready, delivered
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.hotelId,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      hotelId: json['hotel_id'],
      items: (json['items'] as List).map((i) => OrderItem.fromJson(i)).toList(),
      totalPrice: json['total_price'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'hotel_id': hotelId,
      'items': items.map((i) => i.toJson()).toList(),
      'total_price': totalPrice,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class OrderItem {
  final String menuItemId;
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItemId: json['menu_item_id'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu_item_id': menuItemId,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }
}