import 'package:flutter/material.dart';
import '../models/hotel.dart';
import '../services/supabase_service.dart';

class HotelController with ChangeNotifier {
  final SupabaseService _service = SupabaseService();
  List<Hotel> _hotels = [];
  bool _isLoading = false;

  List<Hotel> get hotels => _hotels;
  bool get isLoading => _isLoading;

  Future<void> loadHotels() async {
    _isLoading = true;
    notifyListeners();

    try {
      // For now, use hardcoded data
      _hotels = _getHardcodedHotels();
      // Later: _hotels = await _service.getHotels();
    } catch (e) {
      // Handle error
      // Removed print for production
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Hotel> _getHardcodedHotels() {
    return [
      Hotel(
        id: '1',
        name: 'A & H Karachi Grand',
        city: 'Karachi',
        address: '123 Main Street, Karachi, Pakistan',
        description: 'Luxury hotel in the heart of Karachi',
        images: ['https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80'],
        rooms: [
          Room(id: '1', type: 'VIP', price: 1500.0, description: 'Luxury VIP room', amenities: ['WiFi', 'AC', 'TV'], available: true),
          Room(id: '2', type: 'Business', price: 900.0, description: 'Business class room', amenities: ['WiFi', 'AC'], available: true),
          Room(id: '3', type: 'Economy', price: 450.0, description: 'Economy room', amenities: ['WiFi'], available: true),
        ],
        cafeteria: Cafeteria(menu: [
          MenuItem(id: '1', name: 'Biryani', category: 'Food', price: 60.0, description: 'Traditional Pakistani biryani'),
          MenuItem(id: '2', name: 'Karahi', category: 'Food', price: 75.0, description: 'Spicy karahi dish'),
          MenuItem(id: '3', name: 'Nihari', category: 'Food', price: 54.0, description: 'Slow-cooked beef nihari'),
          MenuItem(id: '4', name: 'Chapli Kebab', category: 'Food', price: 45.0, description: 'Juicy chapli kebab'),
          MenuItem(id: '5', name: 'Sajji', category: 'Food', price: 90.0, description: 'Traditional Balochi sajji'),
          MenuItem(id: '6', name: 'Kabuli Pulao', category: 'Food', price: 66.0, description: 'Afghani style pulao'),
          MenuItem(id: '7', name: 'Halwa Puri', category: 'Food', price: 36.0, description: 'Sweet halwa with puri'),
          MenuItem(id: '8', name: 'Daal Chawal', category: 'Food', price: 30.0, description: 'Lentils with rice'),
          MenuItem(id: '9', name: 'Seekh Kebab', category: 'Food', price: 48.0, description: 'Grilled seekh kebab'),
          MenuItem(id: '10', name: 'Chicken Tikka', category: 'Food', price: 60.0, description: 'Marinated chicken tikka'),
          MenuItem(id: '11', name: 'Coffee - Espresso', category: 'Drink', price: 15.0, description: 'Strong espresso coffee'),
          MenuItem(id: '12', name: 'Coffee - Cappuccino', category: 'Drink', price: 21.0, description: 'Creamy cappuccino'),
          MenuItem(id: '13', name: 'Coffee - Latte', category: 'Drink', price: 24.0, description: 'Smooth latte'),
          MenuItem(id: '14', name: 'Coffee - Americano', category: 'Drink', price: 18.0, description: 'Black americano'),
          MenuItem(id: '15', name: 'Tea - Green Tea', category: 'Drink', price: 12.0, description: 'Refreshing green tea'),
          MenuItem(id: '16', name: 'Tea - Black Tea', category: 'Drink', price: 9.0, description: 'Traditional black tea'),
          MenuItem(id: '17', name: 'Tea - Mint Tea', category: 'Drink', price: 12.0, description: 'Aromatic mint tea'),
          MenuItem(id: '18', name: 'Tea - Herbal Tea', category: 'Drink', price: 15.0, description: 'Medicinal herbal tea'),
          MenuItem(id: '19', name: 'Lassi', category: 'Drink', price: 18.0, description: 'Sweet yogurt drink'),
          MenuItem(id: '20', name: 'Falooda', category: 'Drink', price: 24.0, description: 'Sweet falooda with ice cream'),
          MenuItem(id: '21', name: 'Lemonade', category: 'Drink', price: 12.0, description: 'Fresh lemonade'),
          MenuItem(id: '22', name: 'Rooh Afza', category: 'Drink', price: 15.0, description: 'Traditional rooh afza drink'),
        ]),
        parking: Parking(totalSpots: 100, availableSpots: 80, pricePerHour: 6.0),
        customerService: CustomerService(phone: '+92-21-1234567', email: 'service@ahkarachi.com', whatsapp: '+92-300-1234567'),
      ),
      Hotel(
        id: '2',
        name: 'A & H Lahore Palace',
        city: 'Lahore',
        address: '456 Royal Road, Lahore, Pakistan',
        description: 'Elegant hotel in historic Lahore',
        images: ['https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1169&q=80'],
        rooms: [
          Room(id: '4', type: 'VIP', price: 1650.0, description: 'Luxury VIP room', amenities: ['WiFi', 'AC', 'TV'], available: true),
          Room(id: '5', type: 'Business', price: 960.0, description: 'Business class room', amenities: ['WiFi', 'AC'], available: true),
          Room(id: '6', type: 'Economy', price: 480.0, description: 'Economy room', amenities: ['WiFi'], available: true),
        ],
        cafeteria: Cafeteria(menu: [
          MenuItem(id: '5', name: 'Nihari', category: 'Food', price: 45.0, description: 'Famous Lahori nihari'),
          MenuItem(id: '6', name: 'Halwa Puri', category: 'Food', price: 30.0, description: 'Traditional breakfast'),
          MenuItem(id: '7', name: 'Chicken Tikka', category: 'Food', price: 60.0, description: 'Marinated chicken tikka'),
          MenuItem(id: '8', name: 'Seekh Kebab', category: 'Food', price: 48.0, description: 'Grilled seekh kebab'),
          MenuItem(id: '9', name: 'Biryani', category: 'Food', price: 60.0, description: 'Traditional Pakistani biryani'),
          MenuItem(id: '10', name: 'Karahi', category: 'Food', price: 75.0, description: 'Spicy karahi dish'),
          MenuItem(id: '11', name: 'Chapli Kebab', category: 'Food', price: 45.0, description: 'Juicy chapli kebab'),
          MenuItem(id: '12', name: 'Daal Chawal', category: 'Food', price: 30.0, description: 'Lentils with rice'),
          MenuItem(id: '13', name: 'Green Tea', category: 'Drink', price: 12.0, description: 'Refreshing green tea'),
          MenuItem(id: '14', name: 'Lassi', category: 'Drink', price: 18.0, description: 'Sweet yogurt drink'),
          MenuItem(id: '15', name: 'Coffee - Espresso', category: 'Drink', price: 15.0, description: 'Strong espresso coffee'),
          MenuItem(id: '16', name: 'Coffee - Cappuccino', category: 'Drink', price: 21.0, description: 'Creamy cappuccino'),
          MenuItem(id: '17', name: 'Tea - Black Tea', category: 'Drink', price: 9.0, description: 'Traditional black tea'),
          MenuItem(id: '18', name: 'Tea - Mint Tea', category: 'Drink', price: 12.0, description: 'Aromatic mint tea'),
          MenuItem(id: '19', name: 'Falooda', category: 'Drink', price: 24.0, description: 'Sweet falooda with ice cream'),
          MenuItem(id: '20', name: 'Lemonade', category: 'Drink', price: 12.0, description: 'Fresh lemonade'),
          MenuItem(id: '21', name: 'Coffee - Latte', category: 'Drink', price: 24.0, description: 'Smooth latte'),
          MenuItem(id: '22', name: 'Tea - Herbal Tea', category: 'Drink', price: 15.0, description: 'Medicinal herbal tea'),
        ]),
        parking: Parking(totalSpots: 120, availableSpots: 90, pricePerHour: 7.5),
        customerService: CustomerService(phone: '+92-42-7654321', email: 'service@ahlahore.com', whatsapp: '+92-300-7654321'),
      ),
      Hotel(
        id: '3',
        name: 'A & H Islamabad Elite',
        city: 'Islamabad',
        address: '789 Capital Avenue, Islamabad, Pakistan',
        description: 'Modern hotel in the capital',
        images: ['https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80'],
        rooms: [
          Room(id: '7', type: 'VIP', price: 1800.0, description: 'Luxury VIP room', amenities: ['WiFi', 'AC', 'TV'], available: true),
          Room(id: '8', type: 'Business', price: 1050.0, description: 'Business class room', amenities: ['WiFi', 'AC'], available: true),
          Room(id: '9', type: 'Economy', price: 510.0, description: 'Economy room', amenities: ['WiFi'], available: true),
        ],
        cafeteria: Cafeteria(menu: [
          MenuItem(id: '9', name: 'Chapli Kebab', category: 'Food', price: 54.0, description: 'Juicy chapli kebab'),
          MenuItem(id: '10', name: 'Daal Chawal', category: 'Food', price: 36.0, description: 'Comfort food'),
          MenuItem(id: '11', name: 'Cappuccino', category: 'Drink', price: 21.0, description: 'Italian style coffee'),
          MenuItem(id: '12', name: 'Mint Tea', category: 'Drink', price: 12.0, description: 'Refreshing mint tea'),
        ]),
        parking: Parking(totalSpots: 150, availableSpots: 100, pricePerHour: 9.0),
        customerService: CustomerService(phone: '+92-51-9876543', email: 'service@ahislamabad.com', whatsapp: '+92-300-9876543'),
      ),
      Hotel(
        id: '4',
        name: 'A & H Peshawar Heritage',
        city: 'Peshawar',
        address: '321 Heritage Street, Peshawar, Pakistan',
        description: 'Heritage hotel in ancient Peshawar',
        images: ['https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80'],
        rooms: [
          Room(id: '10', type: 'VIP', price: 1350.0, description: 'Luxury VIP room', amenities: ['WiFi', 'AC', 'TV'], available: true),
          Room(id: '11', type: 'Business', price: 840.0, description: 'Business class room', amenities: ['WiFi', 'AC'], available: true),
          Room(id: '12', type: 'Economy', price: 420.0, description: 'Economy room', amenities: ['WiFi'], available: true),
        ],
        cafeteria: Cafeteria(menu: [
          MenuItem(id: '13', name: 'Kabuli Pulao', category: 'Food', price: 66.0, description: 'Afghani style pulao'),
          MenuItem(id: '14', name: 'Seekh Kebab', category: 'Food', price: 48.0, description: 'Grilled seekh kebab'),
          MenuItem(id: '15', name: 'Black Tea', category: 'Drink', price: 9.0, description: 'Strong black tea'),
          MenuItem(id: '16', name: 'Falooda', category: 'Drink', price: 24.0, description: 'Sweet falooda drink'),
        ]),
        parking: Parking(totalSpots: 80, availableSpots: 60, pricePerHour: 4.5),
        customerService: CustomerService(phone: '+92-91-1122334', email: 'service@ahpeshawar.com', whatsapp: '+92-300-1122334'),
      ),
      Hotel(
        id: '5',
        name: 'A & H Quetta Oasis',
        city: 'Quetta',
        address: '654 Oasis Road, Quetta, Pakistan',
        description: 'Oasis of comfort in Quetta',
        images: ['https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80'],
        rooms: [
          Room(id: '13', type: 'VIP', price: 1200.0, description: 'Luxury VIP room', amenities: ['WiFi', 'AC', 'TV'], available: true),
          Room(id: '14', type: 'Business', price: 750.0, description: 'Business class room', amenities: ['WiFi', 'AC'], available: true),
          Room(id: '15', type: 'Economy', price: 390.0, description: 'Economy room', amenities: ['WiFi'], available: true),
        ],
        cafeteria: Cafeteria(menu: [
          MenuItem(id: '17', name: 'Sajji', category: 'Food', price: 90.0, description: 'Traditional Balochi sajji'),
          MenuItem(id: '18', name: 'Pulao', category: 'Food', price: 42.0, description: 'Simple pulao'),
          MenuItem(id: '19', name: 'Herbal Tea', category: 'Drink', price: 15.0, description: 'Local herbal tea'),
          MenuItem(id: '20', name: 'Lemonade', category: 'Drink', price: 12.0, description: 'Fresh lemonade'),
        ]),
        parking: Parking(totalSpots: 70, availableSpots: 50, pricePerHour: 3.0),
        customerService: CustomerService(phone: '+92-81-4455667', email: 'service@ahoasis.com', whatsapp: '+92-300-4455667'),
      ),
    ];
  }

  Future<Hotel> getHotel(String id) async {
    return await _service.getHotel(id);
  }

  Future<void> addHotel(Hotel hotel) async {
    await _service.addHotel(hotel);
    await loadHotels();
  }

  Future<void> updateHotel(Hotel hotel) async {
    await _service.updateHotel(hotel);
    await loadHotels();
  }

  Future<void> deleteHotel(String id) async {
    await _service.deleteHotel(id);
    await loadHotels();
  }
}