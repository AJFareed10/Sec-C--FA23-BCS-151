import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/hotel_controller.dart';
import 'services/supabase_service.dart';
import 'views/home_screen.dart';
import 'views/customer/cafeteria_menu.dart';
import 'models/hotel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HotelController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'A & H Hotels',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
        ),
        home: const HomeScreen(),
        routes: {
          '/cafeteria': (context) {
            final hotel = ModalRoute.of(context)!.settings.arguments as Hotel;
            return CafeteriaMenu(hotel: hotel);
          },
        },
      ),
    );
  }
}
