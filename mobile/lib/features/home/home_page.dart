import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:islami_mobile/core/theme.dart';
import 'package:islami_mobile/features/home/prayer_tracker_page.dart';
import 'package:islami_mobile/features/home/ummah_page.dart';
import 'package:islami_mobile/features/tasbih/tasbih_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final hijri = HijriCalendar.now();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildCalendarHeader(hijri),
          const SizedBox(height: 24),
          const Text(
            'EXPLORE FEATURES',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: IslamiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
            children: [
              _buildFeatureCard(context, 'Tracker', FontAwesomeIcons.clipboardCheck, const PrayerTrackerPage()),
              _buildFeatureCard(context, 'Tasbih', FontAwesomeIcons.handsPraying, const TasbihPage()),
              _buildFeatureCard(context, 'Hajj Guide', FontAwesomeIcons.kaaba, const Center(child: Text('Hajj Guide coming soon'))),
              _buildFeatureCard(context, 'Calendar', FontAwesomeIcons.calendarCheck, const Center(child: Text('Hijri Calendar coming soon'))),
              _buildFeatureCard(context, 'Ummah', FontAwesomeIcons.users, const UmmahPage()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader(HijriCalendar hijri) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [IslamiTheme.primaryColor, Color(0xFF00695C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: IslamiTheme.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${hijri.hDay} ${hijri.longMonthName}',
            style: const TextStyle(color: IslamiTheme.accentColor, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(
            '${hijri.hYear} AH',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.location_on, color: Colors.white70, size: 16),
              SizedBox(width: 4),
              Text('Mecca, Saudi Arabia', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Widget targetPage) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(appBar: AppBar(title: Text(title)), body: targetPage)));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, color: IslamiTheme.primaryColor, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: IslamiTheme.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
