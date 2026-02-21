import 'package:flutter/material.dart';
import 'package:islami_mobile/core/theme.dart';
import 'package:islami_mobile/features/quran/quran_service.dart';
import 'package:islami_mobile/features/quran/surah_detail_page.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  final _quranService = QuranService();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _quranService.getSurahCount(),
      itemBuilder: (context, index) {
        int surahNumber = index + 1;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: IslamiTheme.primaryColor.withOpacity(0.1),
            child: Text('$surahNumber', style: const TextStyle(color: IslamiTheme.primaryColor)),
          ),
          title: Text(_quranService.getSurahName(surahNumber)),
          subtitle: Text('${_quranService.getVerseCount(surahNumber)} Ayahs'),
          trailing: Text(
            _quranService.getSurahNameArabic(surahNumber),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SurahDetailPage(surahNumber: surahNumber),
              ),
            );
          },
        );
      },
    );
  }
}
