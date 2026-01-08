import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/hotel_controller.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import 'hotel_detail.dart' as hotel_detail;

class HotelList extends StatelessWidget {
  const HotelList({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hotels', style: AppTextStyles.headline2.copyWith(
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
            if (hotelController.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              padding: EdgeInsets.all(screenWidth * 0.04),
              itemCount: hotelController.hotels.length,
              itemBuilder: (context, index) {
                final hotel = hotelController.hotels[index];
                return _buildHotelCard(context, hotel);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildHotelCard(BuildContext context, dynamic hotel) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: SingleChildScrollView(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => hotel_detail.HotelDetail(hotel: hotel)),
            );
          },
          borderRadius: BorderRadius.circular(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: screenHeight * 0.1875,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  image: DecorationImage(
                    image: NetworkImage(hotel.images.isNotEmpty ? hotel.images[0] : 'https://via.placeholder.com/300'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(hotel.name, style: AppTextStyles.headline3.copyWith(
                    fontSize: screenWidth * 0.045,
                  )),
                  SizedBox(height: screenHeight * 0.005),
                  Text(hotel.city, style: AppTextStyles.bodyText2.copyWith(
                    fontSize: screenWidth * 0.035,
                  )),
                  SizedBox(height: screenHeight * 0.005),
                  Text(hotel.address, style: AppTextStyles.caption.copyWith(
                    fontSize: screenWidth * 0.03,
                  )),
                  SizedBox(height: screenHeight * 0.015),
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.accent, size: screenWidth * 0.05),
                      Text('4.5', style: AppTextStyles.bodyText2.copyWith(
                        fontSize: screenWidth * 0.035,
                      )),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => hotel_detail.HotelDetail(hotel: hotel)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('View Details', style: AppTextStyles.button.copyWith(fontSize: screenWidth * 0.035)),
                      ),
                    ],
                  ),
                ],
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}