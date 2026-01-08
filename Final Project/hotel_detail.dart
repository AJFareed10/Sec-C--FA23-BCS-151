import 'package:flutter/material.dart';
import '../../models/hotel.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import 'room_booking.dart';

class HotelDetail extends StatelessWidget {
  final Hotel hotel;

  const HotelDetail({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(hotel.name, style: AppTextStyles.headline2.copyWith(
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hotel Header Image
              Container(
                height: screenHeight * 0.25,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: AppColors.primaryGradient,
                ),
                child: Center(
                  child: Icon(
                    Icons.hotel,
                    size: screenWidth * 0.15,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Hotel Info
              Text(hotel.name, style: AppTextStyles.headline1.copyWith(
                fontSize: screenWidth * 0.08,
              )),
              SizedBox(height: screenHeight * 0.01),
              Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.primary, size: screenWidth * 0.05),
                  SizedBox(width: screenWidth * 0.02),
                  Text(hotel.city, style: AppTextStyles.bodyText1.copyWith(
                    fontSize: screenWidth * 0.04,
                  )),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(hotel.description, style: AppTextStyles.bodyText2.copyWith(
                fontSize: screenWidth * 0.04,
              )),
              SizedBox(height: screenHeight * 0.03),

              // Available Rooms
              Text('Available Rooms', style: AppTextStyles.headline3.copyWith(
                fontSize: screenWidth * 0.06,
              )),
              SizedBox(height: screenHeight * 0.015),
              ...hotel.rooms.map((room) => Card(
                margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(room.type, style: AppTextStyles.headline3.copyWith(
                        fontSize: screenWidth * 0.045,
                      )),
                      SizedBox(height: screenHeight * 0.005),
                      Text(room.description, style: AppTextStyles.bodyText2.copyWith(
                        fontSize: screenWidth * 0.035,
                      )),
                      SizedBox(height: screenHeight * 0.01),
                      Text('PKR ${room.price}/night', style: AppTextStyles.bodyText1.copyWith(
                        fontSize: screenWidth * 0.04,
                        color: AppColors.primary,
                      )),
                      SizedBox(height: screenHeight * 0.01),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RoomBooking(hotel: hotel, room: room),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.01),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.01),
                            child: Text(
                              'Book Now',
                              style: AppTextStyles.button.copyWith(
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              SizedBox(height: screenHeight * 0.03),

              // Cafeteria Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/cafeteria', arguments: hotel);
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
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'View Cafeteria Menu',
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
