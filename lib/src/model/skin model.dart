class SkinModel {
  final List<Skins>? skins;

  SkinModel({
    this.skins,
  });

  SkinModel.fromJson(Map<String, dynamic> json)
      : skins = (json['skins'] as List?)?.map((dynamic e) => Skins.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'skins' : skins?.map((e) => e.toJson()).toList()
  };
}

class Skins {
  final String? id;
  final String? title;
  final List<Files>? files;
  final String? date;
  final String? views;
  final String? likes;
  final String? downloads;
  final String? description;

  Skins({
    this.id,
    this.title,
    this.files,
    this.date,
    this.views,
    this.likes,
    this.downloads,
    this.description,
  });

  Skins.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        title = json['title'] as String?,
        files = (json['files'] as List?)?.map((dynamic e) => Files.fromJson(e as Map<String,dynamic>)).toList(),
        date = json['date'] as String?,
        views = json['views'] as String?,
        likes = json['likes'] as String?,
        downloads = json['downloads'] as String?,
        description = json['description'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'title' : title,
    'files' : files?.map((e) => e.toJson()).toList(),
    'date' : date,
    'views' : views,
    'likes' : likes,
    'downloads' : downloads,
    'description' : description
  };
}

class Files {
  final String? fileId;
  final String? url;
  final String? desc;
  final String? downloads;

  Files({
    this.fileId,
    this.url,
    this.desc,
    this.downloads,
  });

  Files.fromJson(Map<String, dynamic> json)
      : fileId = json['file_id'] as String?,
        url = json['url'] as String?,
        desc = json['desc'] as String?,
        downloads = json['downloads'] as String?;

  Map<String, dynamic> toJson() => {
    'file_id' : fileId,
    'url' : url,
    'desc' : desc,
    'downloads' : downloads
  };
}