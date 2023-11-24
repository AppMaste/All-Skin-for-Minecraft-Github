class Skin {
  final String id;
  final String title;
  final List<File> files;
  final String date;
  final String views;
  final String likes;
  final String downloads;
  final String description;

  Skin({
    required this.id,
    required this.title,
    required this.files,
    required this.date,
    required this.views,
    required this.likes,
    required this.downloads,
    required this.description,
  });

  factory Skin.fromJson(Map<String, dynamic> json) {
    return Skin(
      id: json['id'],
      title: json['title'],
      files: List<File>.from(json['files'].map((file) => File.fromJson(file))),
      date: json['date'],
      views: json['views'],
      likes: json['likes'],
      downloads: json['downloads'],
      description: json['description'],
    );
  }
}

class File {
  final String fileId;
  final String url;
  final String desc;
  final String downloads;

  File({
    required this.fileId,
    required this.url,
    required this.desc,
    required this.downloads,
  });

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      fileId: json['file_id'],
      url: json['url'],
      desc: json['desc'],
      downloads: json['downloads'],
    );
  }
}
