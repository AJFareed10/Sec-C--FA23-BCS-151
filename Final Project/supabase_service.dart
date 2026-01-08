import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../models/hotel.dart';
import '../models/booking.dart';
import '../models/user.dart' as model;

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  late final supabase.SupabaseClient _client;

  // Initialize Supabase
  Future<void> initialize() async {
    await supabase.Supabase.initialize(
      url: 'https://dueyxlfqyqimsdpzvrbt.supabase.co', // Replace with your Supabase URL
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR1ZXl4bGZxeXFpbXNkcHp2cmJ0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU5Nzg2MDgsImV4cCI6MjA4MTU1NDYwOH0.wqL-LGJ0E8ZDuUV1UvvjJXH09-Ay0hjYBzXgAXToULw', // Replace with your Supabase anon key
    );
    _client = supabase.Supabase.instance.client;
  }

  // Auth methods
  Future<supabase.AuthResponse> signUp(String email, String password, String name, String role) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name, 'role': role},
    );
  }

  Future<supabase.AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  model.User? get currentUser => _client.auth.currentUser != null
      ? model.User.fromJson(_client.auth.currentUser!.toJson())
      : null;

  // Hotel methods
  Future<List<Hotel>> getHotels() async {
    final response = await _client.from('hotels').select();
    return response.map((json) => Hotel.fromJson(json)).toList();
  }

  Future<Hotel> getHotel(String id) async {
    final response = await _client.from('hotels').select().eq('id', id).single();
    return Hotel.fromJson(response);
  }

  Future<void> addHotel(Hotel hotel) async {
    await _client.from('hotels').insert(hotel.toJson());
  }

  Future<void> updateHotel(Hotel hotel) async {
    await _client.from('hotels').update(hotel.toJson()).eq('id', hotel.id);
  }

  Future<void> deleteHotel(String id) async {
    await _client.from('hotels').delete().eq('id', id);
  }

  // Booking methods
  Future<List<Booking>> getBookings(String userId) async {
    final response = await _client.from('bookings').select().eq('user_id', userId);
    return response.map((json) => Booking.fromJson(json)).toList();
  }

  Future<void> createBooking(Booking booking) async {
    await _client.from('bookings').insert(booking.toJson());
  }

  Future<void> updateBookingStatus(String id, String status) async {
    await _client.from('bookings').update({'status': status}).eq('id', id);
  }

  // Parking booking methods
  Future<List<ParkingBooking>> getParkingBookings(String userId) async {
    final response = await _client.from('parking_bookings').select().eq('user_id', userId);
    return response.map((json) => ParkingBooking.fromJson(json)).toList();
  }

  Future<void> createParkingBooking(ParkingBooking booking) async {
    await _client.from('parking_bookings').insert(booking.toJson());
  }

  // Order methods
  Future<List<Order>> getOrders(String userId) async {
    final response = await _client.from('orders').select().eq('user_id', userId);
    return response.map((json) => Order.fromJson(json)).toList();
  }

  Future<void> createOrder(Order order) async {
    await _client.from('orders').insert(order.toJson());
  }

  Future<void> updateOrderStatus(String id, String status) async {
    await _client.from('orders').update({'status': status}).eq('id', id);
  }

  // Admin methods to get all data
  Future<List<Booking>> getAllBookings() async {
    final response = await _client.from('bookings').select();
    return response.map((json) => Booking.fromJson(json)).toList();
  }

  Future<List<Order>> getAllOrders() async {
    final response = await _client.from('orders').select();
    return response.map((json) => Order.fromJson(json)).toList();
  }

  Future<List<ParkingBooking>> getAllParkingBookings() async {
    final response = await _client.from('parking_bookings').select();
    return response.map((json) => ParkingBooking.fromJson(json)).toList();
  }
}