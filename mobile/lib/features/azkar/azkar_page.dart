import 'package:flutter/material.dart';
import 'package:islami_mobile/core/theme.dart';
import 'package:islami_mobile/features/azkar/azkar_service.dart';

class AzkarPage extends StatelessWidget {
  const AzkarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _azkarService = AzkarService();
    final _categories = ['Morning', 'Evening', 'After Prayer'];

    return DefaultTabController(
      length: _categories.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            labelColor: IslamiTheme.primaryColor,
            unselectedLabelColor: IslamiTheme.textSecondary,
            indicatorColor: IslamiTheme.primaryColor,
            tabs: _categories.map((c) => Tab(text: c)).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: _categories.map((c) {
                final azkar = _azkarService.getAzkarByCategory(c);
                return ListView.separated(
                  itemCount: azkar.length,
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (_, index) {
                    final item = azkar[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              item.content,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                              ),
                            ),
                            const Divider(height: 24),
                            Text(
                              item.translation,
                              style: const TextStyle(
                                fontSize: 14,
                                color: IslamiTheme.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
