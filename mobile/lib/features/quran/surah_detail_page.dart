import 'package:flutter/material.dart';
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
    try {
      if (_playingVerse == verseNumber) {
        await _audioPlayer.stop();
        setState(() => _playingVerse = null);
        return;
      }
      // Using the highly reliable Global Quran Audio CDN
      final url =
          "https://cdn.islamic.network/quran/audio/128/ar.alafasy/${surahFirstAyahIndex[widget.surahNumber]! + verseNumber - 1}.mp3";

      await _audioPlayer.play(UrlSource(url));
      setState(() => _playingVerse = verseNumber);

      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) setState(() => _playingVerse = null);
      });
    } catch (e) {
      print('Audio Player Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error playing audio. Check internet connection.'),
        ),
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
                      backgroundColor: IslamiTheme.primaryColor.withOpacity(
                        0.1,
                      ),
                      child: Text(
                        '$verseNumber',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.stop_circle : Icons.play_circle,
                      ),
                      color: IslamiTheme.primaryColor,
                      onPressed: () => _playVerse(verseNumber),
                    ),
                  ],
                ),
                Text(
                  _quranService.getVerse(widget.surahNumber, verseNumber),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _quranService.getVerseTranslation(
                    widget.surahNumber,
                    verseNumber,
                  ),
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

const Map<int, int> surahFirstAyahIndex = {
  1: 1,
  2: 8,
  3: 294,
  4: 494,
  5: 670,
  6: 790,
  7: 955,
  8: 1161,
  9: 1236,
  10: 1365,
  11: 1474,
  12: 1597,
  13: 1708,
  14: 1751,
  15: 1803,
  16: 1902,
  17: 2030,
  18: 2141,
  19: 2251,
  20: 2349,
  21: 2484,
  22: 2596,
  23: 2674,
  24: 2792,
  25: 2856,
  26: 2933,
  27: 3160,
  28: 3253,
  29: 3341,
  30: 3410,
  31: 3470,
  32: 3504,
  33: 3534,
  34: 3607,
  35: 3661,
  36: 3706,
  37: 3789,
  38: 3971,
  39: 4059,
  40: 4134,
  41: 4219,
  42: 4273,
  43: 4326,
  44: 4415,
  45: 4474,
  46: 4511,
  47: 4546,
  48: 4584,
  49: 4613,
  50: 4631,
  51: 4676,
  52: 4736,
  53: 4785,
  54: 4847,
  55: 4902,
  56: 4980,
  57: 5076,
  58: 5105,
  59: 5127,
  60: 5151,
  61: 5164,
  62: 5178,
  63: 5189,
  64: 5200,
  65: 5218,
  66: 5230,
  67: 5242,
  68: 5272,
  69: 5324,
  70: 5376,
  71: 5420,
  72: 5448,
  73: 5476,
  74: 5496,
  75: 5552,
  76: 5592,
  77: 5623,
  78: 5673,
  79: 5713,
  80: 5759,
  81: 5801,
  82: 5830,
  83: 5849,
  84: 5885,
  85: 5910,
  86: 5932,
  87: 5949,
  88: 5968,
  89: 5994,
  90: 6024,
  91: 6044,
  92: 6059,
  93: 6080,
  94: 6091,
  95: 6099,
  96: 6107,
  97: 6126,
  98: 6131,
  99: 6139,
  100: 6147,
  101: 6158,
  102: 6169,
  103: 6177,
  104: 6180,
  105: 6189,
  106: 6194,
  107: 6198,
  108: 6205,
  109: 6208,
  110: 6214,
  111: 6217,
  112: 6222,
  113: 6226,
  114: 6231,
};
