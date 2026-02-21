import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:islami_mobile/core/theme.dart';
import 'package:islami_mobile/features/home/home_page.dart';
import 'package:islami_mobile/features/prayer_times/prayer_times_page.dart';
import 'package:islami_mobile/features/quran/quran_page.dart';
import 'package:islami_mobile/features/qibla/qibla_page.dart';
import 'package:islami_mobile/features/azkar/azkar_page.dart';

void main() {
  runApp(const IslamiApp());
}

class IslamiApp extends StatelessWidget {
  const IslamiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Islami',
      theme: IslamiTheme.light,
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    PrayerTimesPage(),
    QuranPage(),
    QiblaPage(),
    AzkarPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Islami'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.clock),
            label: 'Prayers',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bookQuran),
            label: 'Quran',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.compass),
            label: 'Qibla',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.handHoldingHeart),
            label: 'Azkar',
          ),
        ],
      ),
    );
  }
}
