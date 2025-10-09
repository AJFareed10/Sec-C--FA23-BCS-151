import 'package:flutter/material.dart';

void main() {
  runApp(const MyResumeApp());
}

class MyResumeApp extends StatelessWidget {
  const MyResumeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ResumeScreen(),
    );
  }
}

class ResumeScreen extends StatelessWidget {
  const ResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF8B0000)], // black to dark red
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Section (Avatar instead of picture)
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.redAccent,
                child: const Icon(
                  Icons.person,
                  size: 70,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "ALi Jan Fareed",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const Text(
                "Flutter Developer | Computer Science Student",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),

              // Info Section
              buildInfoBox(Icons.email, "sheikhfareed561@gmail.com"),
              buildInfoBox(Icons.phone, "03358111031"),
              buildInfoBox(Icons.location_on, "Vehari, Pakistan"),

              const SizedBox(height: 30),

              // Education Section
              buildSectionTitle("🎓 Education"),
              buildBox("BS Computer Science", "Comsats University Vehari"),
              buildBox("Intermediate", "Kips College"),

              const SizedBox(height: 30),

              // Skills Section
              buildSectionTitle("💻 Skills"),
              buildBox("Flutter Development", "Cross-platform Apps"),
              buildBox("Java & OOP", "Strong understanding of OOP concepts"),
              buildBox("Python & AI", "Expert system and GUI projects"),

              const SizedBox(height: 30),

              // Experience Section
              buildSectionTitle("🧑‍💻 Projects"),
              buildBox("Pick Perfect Shopping System",
                  "AI-based Shopping Expert System in Python"),
              buildBox("Number Guessing Game", "Python game project"),
              buildBox("Resume App", "This Flutter project"),

              const SizedBox(height: 40),

              // Footer
              const Text(
                "© 2025 Ali JAn Fareed | Designed with Flutter ❤️",
                style: TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Info Box Widget
  static Widget buildInfoBox(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade900.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Section Title
  static Widget buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.redAccent,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Box Widget
  static Widget buildBox(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black54, Colors.red.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(2, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
