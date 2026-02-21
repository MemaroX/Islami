class AzkarItem {
  final String title;
  final String content;
  final String translation;
  final String category;
  final int count;

  AzkarItem({
    required this.title,
    required this.content,
    required this.translation,
    required this.category,
    this.count = 1,
  });
}

class AzkarService {
  List<AzkarItem> getAzkarByCategory(String category) {
    return [
      AzkarItem(
        title: 'Morning Azkar',
        content: 'اللّهُ لاَ إِلَـهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ لاَ تَأْخُذُهُ سِنَةٌ وَلاَ نَوْمٌ',
        translation: 'Allah - there is no deity except Him, the Ever-Living, the Sustainer of [all] existence.',
        category: 'Morning',
      ),
      AzkarItem(
        title: 'Morning Azkar',
        content: 'قُلْ هُوَ اللَّهُ أَحَدٌ، اللَّهُ الصَّمَدُ، لَمْ يَلِدْ وَلَمْ يُولَدْ، وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
        translation: 'Say, "He is Allah, [who is] One, Allah, the Eternal Refuge."',
        category: 'Morning',
      ),
      AzkarItem(
        title: 'Evening Azkar',
        content: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
        translation: 'We have reached the evening and the kingdom belongs to Allah.',
        category: 'Evening',
      ),
      AzkarItem(
        title: 'After Prayer',
        content: 'أَسْتَغْفِرُ اللَّهَ (ثَلَاثًا) اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ',
        translation: 'I ask Allah for forgiveness (three times). O Allah, You are Peace and from You is peace.',
        category: 'After Prayer',
      ),
    ];
  }
}
