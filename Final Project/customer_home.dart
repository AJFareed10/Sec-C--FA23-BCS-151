import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/hotel_controller.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import 'hotel_list.dart';
import 'hotel_detail.dart' as hotel_detail;

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HotelController>().loadHotels();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            return Text('A & H Hotels', style: AppTextStyles.headline2.copyWith(
              fontSize: screenWidth < 600 ? screenWidth * 0.04 : screenWidth * 0.05,
            ));
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // TODO: Profile
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          // Responsive scaling factors
          double padding = screenWidth < 600 ? screenWidth * 0.03 : screenWidth * 0.04;
          double titleFontSize = screenWidth < 600 ? screenWidth * 0.06 : screenWidth * 0.08;
          double subtitleFontSize = screenWidth < 600 ? screenWidth * 0.035 : screenWidth * 0.04;
          double sectionFontSize = screenWidth < 600 ? screenWidth * 0.04 : screenWidth * 0.05;
          double buttonHeight = screenHeight * 0.06;
          double buttonFontSize = screenWidth < 600 ? screenWidth * 0.035 : screenWidth * 0.04;
          double hotelCardHeight = screenHeight * 0.25;
          double spacing = screenHeight * 0.025;

          return Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
            child: Consumer<HotelController>(
              builder: (context, hotelController, child) {
                if (hotelController.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Luxury',
                        style: AppTextStyles.headline1.copyWith(
                          fontSize: titleFontSize,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'Choose your perfect stay',
                        style: AppTextStyles.bodyText1.copyWith(
                          fontSize: subtitleFontSize,
                        ),
                      ),
                      SizedBox(height: spacing),
                      Text('Featured Hotels', style: AppTextStyles.headline3.copyWith(
                        fontSize: sectionFontSize,
                      )),
                      SizedBox(height: screenHeight * 0.0125),
                      SizedBox(
                        height: hotelCardHeight,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: hotelController.hotels.length,
                          itemBuilder: (context, index) {
                            final hotel = hotelController.hotels[index];
                            return _buildHotelCard(hotel, screenWidth, screenHeight);
                          },
                        ),
                      ),
                      SizedBox(height: spacing),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HotelList()),
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
                          height: buttonHeight,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              'View All Hotels',
                              style: AppTextStyles.button.copyWith(
                                fontSize: buttonFontSize,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: spacing),
                      Text('Quick Actions', style: AppTextStyles.headline3.copyWith(
                        fontSize: sectionFontSize,
                      )),
                      SizedBox(height: screenHeight * 0.0125),
                      Row(
                        children: [
                          Expanded(child: _buildQuickActionCard('My Bookings', Icons.book_online, screenWidth, screenHeight)),
                          SizedBox(width: screenWidth * 0.025),
                          Expanded(child: _buildQuickActionCard('My Orders', Icons.restaurant, screenWidth, screenHeight)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHotelCard(dynamic hotel, double screenWidth, double screenHeight) {

    return Container(
      width: screenWidth * 0.6,
      margin: EdgeInsets.only(right: screenWidth * 0.04),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              height: screenHeight * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                image: DecorationImage(
                  image: NetworkImage(hotel.images.isNotEmpty ? hotel.images[0] : 'https://via.placeholder.com/300'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    style: AppTextStyles.headline3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    hotel.city,
                    style: AppTextStyles.bodyText2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => hotel_detail.HotelDetail(hotel: hotel)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Book Now', style: AppTextStyles.button.copyWith(fontSize: screenWidth * 0.035)),
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

  Widget _buildQuickActionCard(String title, IconData icon, double screenWidth, double screenHeight) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: SingleChildScrollView(
        child: InkWell(
          onTap: () {
            // TODO: Navigate to respective screen
          },
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              children: [
                Icon(icon, size: screenWidth * 0.1, color: AppColors.primary),
                SizedBox(height: screenHeight * 0.01),
                Text(title, style: AppTextStyles.bodyText1.copyWith(
                  fontSize: screenWidth * 0.035,
                ), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}