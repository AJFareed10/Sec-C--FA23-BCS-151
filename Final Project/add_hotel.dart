import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/hotel_controller.dart';
import '../../models/hotel.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../../utils/custom_text_field.dart';

class AddHotel extends StatefulWidget {
  const AddHotel({super.key});

  @override
  State<AddHotel> createState() => _AddHotelState();
}

class _AddHotelState extends State<AddHotel> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Hotel', style: AppTextStyles.headline2),
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
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Hotel Name',
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _cityController,
                  labelText: 'City',
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _addressController,
                  labelText: 'Address',
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  maxLines: 3,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _addHotel,
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
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        'Add Hotel',
                        style: AppTextStyles.button,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addHotel() {
    if (_formKey.currentState?.validate() ?? false) {
      // Create hotel with default values
      final hotel = Hotel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        city: _cityController.text,
        address: _addressController.text,
        description: _descriptionController.text,
        images: [],
        rooms: [], // Add default rooms
        cafeteria: Cafeteria(menu: []), // Add default menu
        parking: Parking(totalSpots: 100, availableSpots: 100, pricePerHour: 2.0),
        customerService: CustomerService(phone: '', email: '', whatsapp: ''),
      );

      context.read<HotelController>().addHotel(hotel);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}