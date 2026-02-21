import 'package:quran/quran.dart' as quran;

class QuranService {
  int getSurahCount() => quran.totalSurahCount;

  String getSurahName(int surahNumber) => quran.getSurahName(surahNumber);
  
  String getSurahNameArabic(int surahNumber) => quran.getSurahNameArabic(surahNumber);

  int getVerseCount(int surahNumber) => quran.getVerseCount(surahNumber);

  String getVerse(int surahNumber, int verseNumber) => quran.getVerse(surahNumber, verseNumber);

  String getVerseTranslation(int surahNumber, int verseNumber) {
    return quran.getVerseTranslation(surahNumber, verseNumber);
  }

  String getAudioUrl(int surahNumber, int verseNumber) {
    return quran.getAudioURLByVerse(surahNumber, verseNumber);
  }
}
