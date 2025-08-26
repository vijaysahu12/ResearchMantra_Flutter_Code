class PlaylistDataResponseModel {
  final List<PlaylistItem> playlists;

  PlaylistDataResponseModel({required this.playlists});

  factory PlaylistDataResponseModel.fromJson(Map<String, dynamic> json) {
    // If playlists is null or empty, return an empty list
    return PlaylistDataResponseModel(
      playlists: (json['playlist'] as List?)
              ?.map((playlistJson) => PlaylistItem.fromJson(playlistJson))
              .toList() ??
          [], // Default to an empty list if playlists is null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playlist': playlists.map((playlist) => playlist.toJson()).toList(),
    };
  }
}

class PlaylistItem {
  final String chapterTitle;
  final int id;
  final String description;
  final List<SubChapter> subChapters;

  PlaylistItem({required this.chapterTitle, required this.subChapters , required this.id, required this.description});

  factory PlaylistItem.fromJson(Map<String, dynamic> json) {
    return PlaylistItem(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      chapterTitle: json['chapterTitle'] ?? 'No Chapter Title', // Default value if null
      subChapters: (json['subChapters'] as List?)
              ?.map((subChapterJson) => SubChapter.fromJson(subChapterJson))
              .toList() ??
          [], // Default to an empty list if subChapters is null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapterTitle': chapterTitle,
      'subChapters': subChapters.map((subChapter) => subChapter.toJson()).toList(),
    };
  }
}

class SubChapter {
  final int ?id;
  final String ? title;
  final String  ?link;
  final String ? description;
  final int ?videoDuration;
  final bool ?isVisible;
  final String ?language;

  SubChapter({
  this.id,
   this.title,
     this.link,
   this.description,
this.videoDuration,
   this.isVisible,
   this.language,
  });

  factory SubChapter.fromJson(Map<String, dynamic> json) {
    return SubChapter(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title', // Default value if null
      link: json['link'] ?? '', // Default value if null
      description: json['description'] ?? 'No Description', // Default value if null
      videoDuration:json['videoDuration'] ?? 0,
      language: json['language'] ?? 'N/A',
      isVisible: json['isVisible'] ?? false, // Default value if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'description': description,
      'isVisible': isVisible,
    };
  }
}
