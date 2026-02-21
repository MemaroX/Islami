import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
      title: 'إسلامي',
      theme: IslamiTheme.light,
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SA'), // Default to Arabic
      supportedLocales: const [
        Locale('ar', 'SA'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
        title: const Text('إسلامي'),
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
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.clock),
            label: 'الصلاة',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bookQuran),
            label: 'القرآن',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.compass),
            label: 'القبلة',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.handHoldingHeart),
            label: 'الأذكار',
          ),
        ],
      ),
    );
  }
}
