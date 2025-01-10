import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'song.dart';
import 'itunes_service.dart';

class SongProvider with ChangeNotifier {
  List<Song> _songs = [];
  List<Song> _filteredSongs = [];
  String _searchTerm = '';
  bool _isSearching = false;
  String _sortBy = '';
  Song _currentSong = Song.fromJson({
    'trackName': '',
    'collectionName': '',
    'artworkUrl100': '',
    'previewUrl': '',
  });
  bool _canPaly = false;

  List<Song> get songs => _songs;
  List<Song> get filteredSongs => _filteredSongs;
  String get searchTerm => _searchTerm;
  bool get isSearching => _isSearching;
  String get sortBy => _sortBy;
  Song get currentSong => _currentSong;
  bool get canPaly => _canPaly;

  void setSearchTerm(String term) {
    _searchTerm = term;
    notifyListeners();
    fetchSongs();
  }

  void setCurrentSong(Song song) {
    _currentSong = song;
    setCanPlay(true);
    notifyListeners();
  }

  void setCanPlay(bool ready) {
    _canPaly = ready;
    notifyListeners();
  }

  void setSortBy(String by) {
    _sortBy = by;
    notifyListeners();
  }

  void fetchSongs() async {
    _isSearching = true;
    notifyListeners();

    ItunesService service = ItunesService();
    try {
      List<Song> songs = await service.fetchSongs(_searchTerm);
      _songs = songs;
      _filteredSongs = songs;
      _isSearching = false;
      notifyListeners();
    } catch (e) {
      // Handle error
      _isSearching = false;
      notifyListeners();
    }
  }

  void filterSongs(String keyword) {
    _filteredSongs = _songs
        .where((song) =>
            song.trackName.toLowerCase().contains(keyword.toLowerCase()) ||
            song.collectionName.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void sortSongs() {
    _filteredSongs.sort((a, b) {
      if (_sortBy == 'trackName') {
        return a.trackName.compareTo(b.trackName);
      } else {
        return a.collectionName.compareTo(b.collectionName);
      }
    });
    notifyListeners();
  }
}
