import 'package:flutter/material.dart';
import 'package:islami_mobile/core/theme.dart';
import 'package:islami_mobile/features/home/ummah_service.dart';

class UmmahPage extends StatefulWidget {
  const UmmahPage({super.key});

  @override
  State<UmmahPage> createState() => _UmmahPageState();
}

class _UmmahPageState extends State<UmmahPage> {
  final _ummahService = UmmahService();
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _ummahService.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading posts: ${snapshot.error}'));
        }
        
        final posts = snapshot.data ?? [];
        if (posts.isEmpty) {
          return const Center(child: Text('No community posts found.'));
        }

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: IslamiTheme.primaryColor.withOpacity(0.1),
                          child: Text(post.author[0], style: const TextStyle(color: IslamiTheme.primaryColor)),
                        ),
                        const SizedBox(width: 12),
                        Text(post.author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(post.content, style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.favorite, color: Colors.redAccent, size: 20),
                        const SizedBox(width: 4),
                        Text('${post.likes}'),
                        const Spacer(),
                        const Icon(Icons.share, color: IslamiTheme.textSecondary, size: 20),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
