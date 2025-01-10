class Song {
  String trackName;
  String collectionName;
  String artworkUrl100;
  String previewUrl;

  Song({
    required this.trackName,
    required this.collectionName,
    required this.artworkUrl100,
    required this.previewUrl,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      trackName: json['trackName'] as String,
      collectionName: json['collectionName'] as String,
      artworkUrl100: json['artworkUrl100'] as String,
      previewUrl: json['previewUrl'] as String,
    );
  }
}