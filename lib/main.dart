import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'song_provider.dart';
import 'song.dart';
import 'audio_player.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SongProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iTunes Search App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('iTunes Search App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // 搜索框
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search songs',
              ),
              onSubmitted: (String value) async {
                songProvider.setSearchTerm(value);
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 按歌曲名排序选项
                Radio(
                  value: 'trackName',
                  groupValue: songProvider.sortBy,
                  onChanged: (value) {
                    songProvider.setSortBy(value as String);
                    songProvider.sortSongs();
                  },
                ),
                Text('Sort by Song Name'),
                SizedBox(width: 16),
                // 按专辑名排序选项
                Radio(
                  value: 'collectionName',
                  groupValue: songProvider.sortBy,
                  onChanged: (value) {
                    songProvider.setSortBy(value as String);
                    songProvider.sortSongs();
                  },
                ),
                Text('Sort by Album Name'),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              // 搜索列表
              child: songProvider.isSearching
                  ? Center(child: CircularProgressIndicator())
                  : SongList(),
            ),
            SizedBox(height: 16),
            Visibility(
              visible: songProvider.canPaly,
              child: Opacity(
                opacity: songProvider.canPaly ? 1.0 : 0.0,
                child: AudioPlayerScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 歌曲列表
class SongList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context);

    if (songProvider.filteredSongs.isEmpty) {
      return Center(
        child: Text('No songs found. You can try other keywords.'),
      );
    }

    return ListView.builder(
        itemCount: songProvider.filteredSongs.length,
        itemBuilder: (context, index) {
          Song song = songProvider.filteredSongs[index];
          return GestureDetector(
            onTap: () {
              songProvider.setCurrentSong(song);
            },
            child: ListTile(
              leading: Image.network(song.artworkUrl100),
              title: Text(song.trackName),
              subtitle: Text(song.collectionName),
            ),
          );
        });
  }
}
