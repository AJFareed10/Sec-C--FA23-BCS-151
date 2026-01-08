import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import 'admin/admin_login.dart';
import 'customer/customer_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          // Responsive scaling factors
          double logoSize = screenWidth < 600 ? screenWidth * 0.3 : screenWidth * 0.4;
          double titleFontSize = screenWidth < 600 ? screenWidth * 0.06 : screenWidth * 0.08;
          double subtitleFontSize = screenWidth < 600 ? screenWidth * 0.05 : screenWidth * 0.06;
          double roleFontSize = screenWidth < 600 ? screenWidth * 0.04 : screenWidth * 0.05;
          double buttonFontSize = screenWidth < 600 ? screenWidth * 0.035 : screenWidth * 0.04;
          double buttonWidth = screenWidth < 600 ? screenWidth * 0.8 : screenWidth * 0.5;
          double buttonHeight = screenHeight * 0.08;

          return Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        ClipRRect(
                          borderRadius: BorderRadius.circular(logoSize / 2),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: logoSize,
                            height: logoSize,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Company name
                        Text(
                          'A & H Hotels',
                          style: AppTextStyles.headline1.copyWith(
                            color: AppColors.primary,
                            fontSize: titleFontSize,
                          ),
                        ),

                        const SizedBox(height: 50),

                        Text(
                          'Welcome to A & H Hotels',
                          style: AppTextStyles.headline1.copyWith(
                            fontSize: subtitleFontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 50),

                        Text(
                          'Choose your role',
                          style: AppTextStyles.headline3.copyWith(
                            fontSize: roleFontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 40),

                        // Admin Button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AdminLogin()),
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
                            width: buttonWidth,
                            height: buttonHeight,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                'Admin',
                                style: AppTextStyles.button.copyWith(
                                  fontSize: buttonFontSize,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Customer Button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CustomerHome()),
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
                            width: buttonWidth,
                            height: buttonHeight,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                'Customer',
                                style: AppTextStyles.button.copyWith(
                                  fontSize: buttonFontSize,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}