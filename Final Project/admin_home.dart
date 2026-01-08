import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/hotel_controller.dart';
import '../../services/supabase_service.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import 'add_hotel.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _totalBookings = 0;
  int _totalOrders = 0;
  int _totalParkingBookings = 0;
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HotelController>().loadHotels();
      _loadStats();
    });
  }

  Future<void> _loadStats() async {
    try {
      final supabaseService = SupabaseService();
      final bookings = await supabaseService.getAllBookings();
      final orders = await supabaseService.getAllOrders();
      final parkingBookings = await supabaseService.getAllParkingBookings();

      setState(() {
        _totalBookings = bookings.length;
        _totalOrders = orders.length;
        _totalParkingBookings = parkingBookings.length;
        _isLoadingStats = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingStats = false;
      });
      // Handle error silently for now
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard', style: AppTextStyles.headline2.copyWith(
          fontSize: screenWidth * 0.05,
        )),
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
        child: Consumer<HotelController>(
          builder: (context, hotelController, child) {
            return hotelController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  children: [
                    _buildStatCard('Total Hotels', hotelController.hotels.length.toString()),
                    _buildStatCard('Total Bookings', _isLoadingStats ? '...' : _totalBookings.toString()),
                    _buildStatCard('Total Orders', _isLoadingStats ? '...' : _totalOrders.toString()),
                    _buildStatCard('Total Parking Bookings', _isLoadingStats ? '...' : _totalParkingBookings.toString()),
                    SizedBox(height: screenHeight * 0.025),
                    Text('Manage Hotels', style: AppTextStyles.headline3.copyWith(
                      fontSize: screenWidth * 0.05,
                    )),
                    SizedBox(height: screenHeight * 0.0125),
                    ...hotelController.hotels.map((hotel) => _buildHotelCard(hotel)),
                SizedBox(height: screenHeight * 0.025),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddHotel()),
                    );
                  },
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
                        'Add New Hotel',
                        style: AppTextStyles.button.copyWith(
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.05),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.bodyText1.copyWith(color: Colors.white, fontSize: screenWidth * 0.04)),
            Text(value, style: AppTextStyles.headline2.copyWith(color: Colors.white, fontSize: screenWidth * 0.06)),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelCard(dynamic hotel) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        title: Text(hotel.name, style: AppTextStyles.headline3.copyWith(
          fontSize: screenWidth * 0.045,
        )),
        subtitle: Text(hotel.city, style: AppTextStyles.bodyText2.copyWith(
          fontSize: screenWidth * 0.035,
        )),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primary),
              onPressed: () {
                // TODO: Edit hotel
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error),
              onPressed: () {
                // TODO: Delete hotel
              },
            ),
          ],
        ),
      ),
    );
  }
}
