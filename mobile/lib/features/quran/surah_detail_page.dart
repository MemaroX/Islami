import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:islami_mobile/core/theme.dart';
import 'package:islami_mobile/features/quran/quran_service.dart';
import 'package:audioplayers/audioplayers.dart';

class SurahDetailPage extends StatefulWidget {
  final int surahNumber;

  const SurahDetailPage({super.key, required this.surahNumber});

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  final _quranService = QuranService();
  final _audioPlayer = AudioPlayer();
  int? _playingVerse;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playVerse(int verseNumber) async {
    if (_playingVerse == verseNumber) {
      await _audioPlayer.stop();
      setState(() => _playingVerse = null);
      return;
    }

    final url = _quranService.getAudioUrl(widget.surahNumber, verseNumber);
    try {
      await _audioPlayer.play(UrlSource(url));
      setState(() => _playingVerse = verseNumber);
      
      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) setState(() => _playingVerse = null);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error playing audio: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int verseCount = _quranService.getVerseCount(widget.surahNumber);
    String surahName = _quranService.getSurahName(widget.surahNumber);

    return Scaffold(
      appBar: AppBar(title: Text(surahName)),
      body: ListView.separated(
        itemCount: verseCount,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          int verseNumber = index + 1;
          bool isPlaying = _playingVerse == verseNumber;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: IslamiTheme.primaryColor.withOpacity(0.1),
                      child: Text('$verseNumber', style: const TextStyle(fontSize: 10)),
                    ),
                    IconButton(
                      icon: Icon(isPlaying ? Icons.stop_circle : Icons.play_circle),
                      color: IslamiTheme.primaryColor,
                      onPressed: () => _playVerse(verseNumber),
                    ),
                  ],
                ),
                Text(
                  _quranService.getVerse(widget.surahNumber, verseNumber),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Amiri', // Assuming you'll add an Arabic font
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _quranService.getVerseTranslation(widget.surahNumber, verseNumber),
                  style: const TextStyle(
                    color: IslamiTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
