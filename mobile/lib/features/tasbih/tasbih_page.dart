import 'package:flutter/material.dart';
import 'package:islami_mobile/core/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasbihPage extends StatefulWidget {
  const TasbihPage({super.key});

  @override
  State<TasbihPage> createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> {
  int _counter = 0;
  final String _key = 'tasbih_counter';

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _counter = prefs.getInt(_key) ?? 0);
  }

  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _counter++);
    await prefs.setInt(_key, _counter);
  }

  Future<void> _resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _counter = 0);
    await prefs.setInt(_key, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'TASBIH COUNTER',
            style: TextStyle(fontSize: 18, color: IslamiTheme.textSecondary, letterSpacing: 2),
          ),
          const SizedBox(height: 20),
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: IslamiTheme.primaryColor.withOpacity(0.1),
              border: Border.all(color: IslamiTheme.primaryColor, width: 4),
            ),
            child: Center(
              child: Text(
                '$_counter',
                style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: IslamiTheme.primaryColor),
              ),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _incrementCounter,
            style: ElevatedButton.styleFrom(
              backgroundColor: IslamiTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('SUBHAN ALLAH', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _resetCounter,
            child: const Text('RESET', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
