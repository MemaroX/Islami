import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islami_mobile/core/theme.dart';
import 'package:islami_mobile/core/database_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PrayerTrackerPage extends StatefulWidget {
  const PrayerTrackerPage({super.key});

  @override
  State<PrayerTrackerPage> createState() => _PrayerTrackerPageState();
}

class _PrayerTrackerPageState extends State<PrayerTrackerPage> {
  final _dbService = DatabaseService();
  DateTime _selectedDate = DateTime.now();
  Map<String, bool> _prayers = {
    'Fajr': false,
    'Dhuhr': false,
    'Asr': false,
    'Maghrib': false,
    'Isha': false,
  };

  @override
  void initState() {
    super.initState();
    _loadPrayers();
  }

  Future<void> _loadPrayers() async {
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final results = await _dbService.getDayPrayers(dateStr);
    setState(() => _prayers = results);
  }

  Future<void> _togglePrayer(String prayerName, bool? value) async {
    if (value == null) return;
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    await _dbService.togglePrayer(dateStr, prayerName, value);
    _loadPrayers();
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
    _loadPrayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Tracker')),
      body: Column(
        children: [
          _buildDateSelector(),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildPrayerTile('Fajr', FontAwesomeIcons.sun),
                _buildPrayerTile('Dhuhr', FontAwesomeIcons.cloudSun),
                _buildPrayerTile('Asr', FontAwesomeIcons.cloudSun),
                _buildPrayerTile('Maghrib', FontAwesomeIcons.cloudMoon),
                _buildPrayerTile('Isha', FontAwesomeIcons.moon),
                const SizedBox(height: 32),
                _buildSummaryCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    final dateStr = DateFormat('EEEE, d MMM yyyy').format(_selectedDate);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => _changeDate(-1)),
          Column(
            children: [
              Text(
                dateStr,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: IslamiTheme.primaryColor),
              ),
              if (DateFormat('yyyy-MM-dd').format(_selectedDate) == DateFormat('yyyy-MM-dd').format(DateTime.now()))
                const Text('TODAY', style: TextStyle(color: IslamiTheme.accentColor, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => _changeDate(1)),
        ],
      ),
    );
  }

  Widget _buildPrayerTile(String name, IconData icon) {
    final bool isDone = _prayers[name] ?? false;
    return Card(
      elevation: 0,
      color: isDone ? IslamiTheme.primaryColor.withOpacity(0.05) : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isDone ? IslamiTheme.primaryColor : Colors.grey.shade200),
      ),
      child: CheckboxListTile(
        value: isDone,
        onChanged: (val) => _togglePrayer(name, val),
        secondary: FaIcon(icon, color: isDone ? IslamiTheme.primaryColor : Colors.grey),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDone ? IslamiTheme.primaryColor : IslamiTheme.textPrimary,
          ),
        ),
        activeColor: IslamiTheme.primaryColor,
        checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  Widget _buildSummaryCard() {
    int completed = _prayers.values.where((v) => v).length;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: IslamiTheme.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text('DAILY PROGRESS', style: TextStyle(color: Colors.white70, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text(
            '$completed / 5',
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: completed / 5,
            backgroundColor: Colors.white24,
            color: IslamiTheme.accentColor,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
