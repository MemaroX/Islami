import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:adhan/adhan.dart';
import 'package:islami_mobile/core/theme.dart';
import 'package:islami_mobile/features/prayer_times/prayer_times_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({super.key});

  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  final _prayerService = PrayerTimesService();
  PrayerTimes? _currentDayTimes;
  PrayerTimes? _tomorrowTimes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllTimes();
  }

  Future<void> _loadAllTimes() async {
    final now = DateTime.now();
    final today = await _prayerService.getPrayerTimes(date: now);
    final tomorrow = await _prayerService.getPrayerTimes(date: now.add(const Duration(days: 1)));
    
    if (mounted) {
      setState(() {
        _currentDayTimes = today;
        _tomorrowTimes = tomorrow;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_currentDayTimes == null) {
      return const Center(child: Text('Could not load prayer times. Check location.'));
    }

    final prayerTimes = _currentDayTimes!;
    final now = DateTime.now();
    
    // Manual detection of the next prayer for maximum reliability
    String nextPrayerName = 'FAJR (TOMORROW)';
    DateTime? nextTime = _tomorrowTimes?.fajr;

    if (now.isBefore(prayerTimes.fajr)) {
      nextPrayerName = 'FAJR';
      nextTime = prayerTimes.fajr;
    } else if (now.isBefore(prayerTimes.sunrise)) {
      nextPrayerName = 'SUNRISE';
      nextTime = prayerTimes.sunrise;
    } else if (now.isBefore(prayerTimes.dhuhr)) {
      nextPrayerName = 'DHUHR';
      nextTime = prayerTimes.dhuhr;
    } else if (now.isBefore(prayerTimes.asr)) {
      nextPrayerName = 'ASR';
      nextTime = prayerTimes.asr;
    } else if (now.isBefore(prayerTimes.maghrib)) {
      nextPrayerName = 'MAGHRIB';
      nextTime = prayerTimes.maghrib;
    } else if (now.isBefore(prayerTimes.isha)) {
      nextPrayerName = 'ISHA';
      nextTime = prayerTimes.isha;
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(nextPrayerName, nextTime),
          const SizedBox(height: 24),
          _buildPrayerRow('Fajr', prayerTimes.fajr, FontAwesomeIcons.sun),
          _buildPrayerRow('Sunrise', prayerTimes.sunrise, FontAwesomeIcons.solidSun),
          _buildPrayerRow('Dhuhr', prayerTimes.dhuhr, FontAwesomeIcons.cloudSun),
          _buildPrayerRow('Asr', prayerTimes.asr, FontAwesomeIcons.cloudSun),
          _buildPrayerRow('Maghrib', prayerTimes.maghrib, FontAwesomeIcons.cloudMoon),
          _buildPrayerRow('Isha', prayerTimes.isha, FontAwesomeIcons.moon),
        ],
      ),
    );
  }

  Widget _buildHeader(String prayerName, DateTime? nextTime) {
    String timeStr = nextTime != null ? DateFormat.jm().format(nextTime.toLocal()) : '--:--';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: IslamiTheme.primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'NEXT PRAYER',
            style: TextStyle(color: Colors.white70, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          Text(
            prayerName,
            style: const TextStyle(
              color: IslamiTheme.accentColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            timeStr,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerRow(String label, DateTime time, IconData icon) {
    final timeStr = DateFormat.jm().format(time.toLocal());
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            FaIcon(icon, color: IslamiTheme.primaryColor, size: 20),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const Spacer(),
            Text(timeStr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
