import 'package:flutter/material.dart';
import '../../models/hotel.dart';
import '../../models/booking.dart';
import '../../services/supabase_service.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

class CafeteriaMenu extends StatefulWidget {
  final Hotel hotel;

  const CafeteriaMenu({super.key, required this.hotel});

  @override
  State<CafeteriaMenu> createState() => _CafeteriaMenuState();
}

class _CafeteriaMenuState extends State<CafeteriaMenu> {
  final Map<String, int> _cart = {};
  bool _isPlacingOrder = false;

  Future<void> _placeOrder() async {
    if (_cart.isEmpty) return;

    setState(() => _isPlacingOrder = true);

    try {
      final items = _cart.entries.map((entry) {
        final menuItem = widget.hotel.cafeteria.menu.firstWhere((item) => item.id == entry.key);
        return OrderItem(
          menuItemId: entry.key,
          name: menuItem.name,
          quantity: entry.value,
          price: menuItem.price.toDouble(),
        );
      }).toList();

      final totalPrice = items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

      // For demo purposes, using a hardcoded user ID
      const userId = 'demo-user-id';

      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        hotelId: widget.hotel.id,
        items: items,
        totalPrice: totalPrice,
        status: 'ordered',
        createdAt: DateTime.now(),
      );

      await SupabaseService().createOrder(order);

      setState(() => _cart.clear());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error placing order: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPlacingOrder = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.hotel.name} - Cafeteria', style: AppTextStyles.headline2.copyWith(
          fontSize: screenWidth * 0.045,
        )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        actions: [
          if (_cart.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                // Navigate to cart
              },
            ),
        ],
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
              Text('Menu', style: AppTextStyles.headline1.copyWith(
                fontSize: screenWidth * 0.08,
              )),

            SizedBox(height: screenHeight * 0.025),

            // Foods
            Row(
              children: [
                Icon(Icons.restaurant, color: AppColors.primary, size: screenWidth * 0.07),
                SizedBox(width: screenWidth * 0.02),
                Text('Foods', style: AppTextStyles.headline3.copyWith(
                  fontSize: screenWidth * 0.05,
                )),
              ],
            ),
            SizedBox(height: screenHeight * 0.0125),
            ...widget.hotel.cafeteria.menu
                .where((item) => item.category == 'Food')
                .map((item) => _buildMenuItem(item)),

            SizedBox(height: screenHeight * 0.025),

            // Drinks
            Row(
              children: [
                Icon(Icons.local_drink, color: AppColors.primary, size: screenWidth * 0.07),
                SizedBox(width: screenWidth * 0.02),
                Text('Drinks', style: AppTextStyles.headline3.copyWith(
                  fontSize: screenWidth * 0.05,
                )),
              ],
            ),
            SizedBox(height: screenHeight * 0.0125),
            ...widget.hotel.cafeteria.menu
                .where((item) => item.category == 'Drink')
                .map((item) => _buildMenuItem(item)),

            SizedBox(height: screenHeight * 0.025),

            if (_cart.isNotEmpty)
              _isPlacingOrder
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _placeOrder,
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
                            'Place Order (${_cart.length} items)',
                            style: AppTextStyles.button.copyWith(
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: screenHeight * 0.025
              ),
            ],

        ),
    ),
      ),
    );
    
  }

  Widget _buildMenuItem(dynamic item) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      margin: EdgeInsets.only(bottom: screenHeight * 0.0125),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Row(
          children: [
            // Food Image
            Container(
              width: screenWidth * 0.15,
              height: screenWidth * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage('assets/images/food2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: AppTextStyles.headline3.copyWith(
                    fontSize: screenWidth * 0.045,
                  )),
                  Text(item.description, style: AppTextStyles.bodyText2.copyWith(
                    fontSize: screenWidth * 0.035,
                  )),
                  Text('PKR ${item.price}', style: AppTextStyles.bodyText1.copyWith(
                    fontSize: screenWidth * 0.04,
                    color: AppColors.primary,
                  )),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (mounted) {
                        setState(() {
                          if (_cart[item.id] != null && _cart[item.id]! > 0) {
                            _cart[item.id] = _cart[item.id]! - 1;
                            if (_cart[item.id] == 0) _cart.remove(item.id);
                          }
                        });
                      }
                    },
                  ),
                  Text(_cart[item.id]?.toString() ?? '0'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (mounted) {
                        setState(() {
                          _cart[item.id] = (_cart[item.id] ?? 0) + 1;
                        });
                      }
                    },
                  ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}