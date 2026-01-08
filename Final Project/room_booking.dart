import 'package:flutter/material.dart';
import '../../models/hotel.dart';
import '../../models/booking.dart';
import '../../services/supabase_service.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../../utils/custom_text_field.dart';

class RoomBooking extends StatefulWidget {
  final Hotel hotel;
  final dynamic room;

  const RoomBooking({super.key, required this.hotel, required this.room});

  @override
  State<RoomBooking> createState() => _RoomBookingState();
}

class _RoomBookingState extends State<RoomBooking> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _selectCheckInDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _checkInDate = picked;
      });
    }
  }

  Future<void> _selectCheckOutDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate ?? DateTime.now(),
      firstDate: _checkInDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

  Future<void> _bookRoom() async {
    if (_checkInDate == null ||
        _checkOutDate == null ||
        _nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields')),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final checkIn = _checkInDate!;
      final checkOut = _checkOutDate!;
      final nights = checkOut.difference(checkIn).inDays;
      final totalPrice = widget.room.price * nights;

      // For demo purposes, using a hardcoded user ID
      // In a real app, this would come from authentication
      const userId = 'demo-user-id';

      final booking = Booking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        hotelId: widget.hotel.id,
        roomId: widget.room.id,
        checkIn: checkIn,
        checkOut: checkOut,
        totalPrice: totalPrice.toDouble(),
        status: 'pending',
        createdAt: DateTime.now(),
      );

      await SupabaseService().createBooking(booking);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Room booked successfully!')),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error booking room: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.room.type}', style: AppTextStyles.headline2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Room Details', style: AppTextStyles.headline1.copyWith(
                fontSize: screenWidth * 0.06,
              )),
              const SizedBox(height: 10),
              Text(widget.room.description, style: AppTextStyles.bodyText1),
              Text('Price: PKR ${widget.room.price}/night', style: AppTextStyles.bodyText2),
              const SizedBox(height: 30),

              Text('Booking Information', style: AppTextStyles.headline3.copyWith(
                fontSize: screenWidth * 0.05,
              )),
              const SizedBox(height: 20),

              InkWell(
                onTap: _selectCheckInDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 10),
                      Text(
                        _checkInDate != null
                            ? '${_checkInDate!.year}-${_checkInDate!.month.toString().padLeft(2, '0')}-${_checkInDate!.day.toString().padLeft(2, '0')}'
                            : 'Select Check-in Date',
                        style: TextStyle(color: _checkInDate != null ? Colors.black : Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              InkWell(
                onTap: _selectCheckOutDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 10),
                      Text(
                        _checkOutDate != null
                            ? '${_checkOutDate!.year}-${_checkOutDate!.month.toString().padLeft(2, '0')}-${_checkOutDate!.day.toString().padLeft(2, '0')}'
                            : 'Select Check-out Date',
                        style: TextStyle(color: _checkOutDate != null ? Colors.black : Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              CustomTextField(
                controller: _nameController,
                labelText: 'Full Name',
                hintText: 'Enter your full name',
              ),
              const SizedBox(height: 15),

              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),

              CustomTextField(
                controller: _phoneController,
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 30),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _bookRoom,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: screenHeight * 0.06,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            'Book Room',
                            style: AppTextStyles.button.copyWith(
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
