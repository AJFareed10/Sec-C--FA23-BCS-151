class Hotel {
  final String id;
  final String name;
  final String city;
  final String address;
  final String description;
  final List<String> images;
  final List<Room> rooms;
  final Cafeteria cafeteria;
  final Parking parking;
  final CustomerService customerService;

  Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.description,
    required this.images,
    required this.rooms,
    required this.cafeteria,
    required this.parking,
    required this.customerService,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      address: json['address'],
      description: json['description'],
      images: List<String>.from(json['images']),
      rooms: (json['rooms'] as List).map((r) => Room.fromJson(r)).toList(),
      cafeteria: Cafeteria.fromJson(json['cafeteria']),
      parking: Parking.fromJson(json['parking']),
      customerService: CustomerService.fromJson(json['customer_service']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'address': address,
      'description': description,
      'images': images,
      'rooms': rooms.map((r) => r.toJson()).toList(),
      'cafeteria': cafeteria.toJson(),
      'parking': parking.toJson(),
      'customer_service': customerService.toJson(),
    };
  }
}

class Room {
  final String id;
  final String type; // VIP, Business, Economy
  final double price;
  final String description;
  final List<String> amenities;
  final bool available;

  Room({
    required this.id,
    required this.type,
    required this.price,
    required this.description,
    required this.amenities,
    required this.available,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      type: json['type'],
      price: json['price'],
      description: json['description'],
      amenities: List<String>.from(json['amenities']),
      available: json['available'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'price': price,
      'description': description,
      'amenities': amenities,
      'available': available,
    };
  }
}

class Cafeteria {
  final List<MenuItem> menu;

  Cafeteria({required this.menu});

  factory Cafeteria.fromJson(Map<String, dynamic> json) {
    return Cafeteria(
      menu: (json['menu'] as List).map((m) => MenuItem.fromJson(m)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu': menu.map((m) => m.toJson()).toList(),
    };
  }
}

class MenuItem {
  final String id;
  final String name;
  final String category; // Food, Drink, Coffee, Tea
  final double price;
  final String description;

  MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      price: json['price'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'description': description,
    };
  }
}

class Parking {
  final int totalSpots;
  final int availableSpots;
  final double pricePerHour;

  Parking({
    required this.totalSpots,
    required this.availableSpots,
    required this.pricePerHour,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      totalSpots: json['total_spots'],
      availableSpots: json['available_spots'],
      pricePerHour: json['price_per_hour'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_spots': totalSpots,
      'available_spots': availableSpots,
      'price_per_hour': pricePerHour,
    };
  }
}

class CustomerService {
  final String phone;
  final String email;
  final String whatsapp;

  CustomerService({
    required this.phone,
    required this.email,
    required this.whatsapp,
  });

  factory CustomerService.fromJson(Map<String, dynamic> json) {
    return CustomerService(
      phone: json['phone'],
      email: json['email'],
      whatsapp: json['whatsapp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'email': email,
      'whatsapp': whatsapp,
    };
  }
}