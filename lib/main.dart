import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:musixmatch_flutter_api_app/details.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Autogenerated> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Music List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Music List'),
          ),
          body: Center(
            child: FutureBuilder<Autogenerated>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
//                return Text('${snapshot.data.message.body.trackList[0].track.trackName}');
//                listTrackWidget(snapshot.data);
                  return ListView.builder(
                    itemCount: snapshot.data.message.body.trackList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 60,
                        child: Card(
                          elevation: 10.0,
                          color: Colors.blue.shade100,
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  var route = new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                    new Fulldata(
                                        id: snapshot
                                            .data
                                            .message
                                            .body
                                            .trackList[index]
                                            .track
                                            .trackId),
                                  );
                                  Navigator.of(context).push(route);
                                },
                                child: Text(
                                  '${snapshot.data.message.body.trackList[index].track.trackName}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
    );
  }
//  Widget listTrackWidget(snapshot){
//    return ListView.builder(
//      itemCount: snapshot.message.body.trackList.length,
//      itemBuilder: (context, index) {
//        return ListTile(
//          title: Text('asdasd'),
//        );
//      },
//    );
//  }

}

Future<Autogenerated> fetchAlbum() async {
  final response = await http.get(
      'https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(json.decode(response.body));
    return Autogenerated.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Autogenerated {
  Message message;

  Autogenerated({this.message});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message.toJson();
    }
    return data;
  }
}

class Message {
  Header header;
  Body body;

  Message({this.header, this.body});

  Message.fromJson(Map<String, dynamic> json) {
    header =
        json['header'] != null ? new Header.fromJson(json['header']) : null;
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    if (this.body != null) {
      data['body'] = this.body.toJson();
    }
    return data;
  }
}

class Header {
  int statusCode;
  double executeTime;

  Header({this.statusCode, this.executeTime});

  Header.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    executeTime = json['execute_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['execute_time'] = this.executeTime;
    return data;
  }
}

class Body {
  List<TrackList> trackList;

  Body({this.trackList});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['track_list'] != null) {
      trackList = new List<TrackList>();
      json['track_list'].forEach((v) {
        trackList.add(new TrackList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trackList != null) {
      data['track_list'] = this.trackList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrackList {
  Track track;

  TrackList({this.track});

  TrackList.fromJson(Map<String, dynamic> json) {
    track = json['track'] != null ? new Track.fromJson(json['track']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.track != null) {
      data['track'] = this.track.toJson();
    }
    return data;
  }
}

class Track {
  int trackId;
  String trackName;
  List<Null> trackNameTranslationList;
  int trackRating;
  int commontrackId;
  int instrumental;
  int explicit;
  int hasLyrics;
  int hasSubtitles;
  int hasRichsync;
  int numFavourite;
  int albumId;
  String albumName;
  int artistId;
  String artistName;
  String trackShareUrl;
  String trackEditUrl;
  int restricted;
  String updatedTime;
  PrimaryGenres primaryGenres;

  Track(
      {this.trackId,
      this.trackName,
      this.trackNameTranslationList,
      this.trackRating,
      this.commontrackId,
      this.instrumental,
      this.explicit,
      this.hasLyrics,
      this.hasSubtitles,
      this.hasRichsync,
      this.numFavourite,
      this.albumId,
      this.albumName,
      this.artistId,
      this.artistName,
      this.trackShareUrl,
      this.trackEditUrl,
      this.restricted,
      this.updatedTime,
      this.primaryGenres});

  Track.fromJson(Map<String, dynamic> json) {
    trackId = json['track_id'];
    trackName = json['track_name'];
//    if (json['track_name_translation_list'] != null) {
//      trackNameTranslationList = new List<Null>();
//      json['track_name_translation_list'].forEach((v) {
//        trackNameTranslationList.add(new Null.fromJson(v));
//      });
//    }
    trackRating = json['track_rating'];
    commontrackId = json['commontrack_id'];
    instrumental = json['instrumental'];
    explicit = json['explicit'];
    hasLyrics = json['has_lyrics'];
    hasSubtitles = json['has_subtitles'];
    hasRichsync = json['has_richsync'];
    numFavourite = json['num_favourite'];
    albumId = json['album_id'];
    albumName = json['album_name'];
    artistId = json['artist_id'];
    artistName = json['artist_name'];
    trackShareUrl = json['track_share_url'];
    trackEditUrl = json['track_edit_url'];
    restricted = json['restricted'];
    updatedTime = json['updated_time'];
    primaryGenres = json['primary_genres'] != null
        ? new PrimaryGenres.fromJson(json['primary_genres'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['track_id'] = this.trackId;
    data['track_name'] = this.trackName;
//    if (this.trackNameTranslationList != null) {
//      data['track_name_translation_list'] =
//          this.trackNameTranslationList.map((v) => v.toJson()).toList();
//    }
    data['track_rating'] = this.trackRating;
    data['commontrack_id'] = this.commontrackId;
    data['instrumental'] = this.instrumental;
    data['explicit'] = this.explicit;
    data['has_lyrics'] = this.hasLyrics;
    data['has_subtitles'] = this.hasSubtitles;
    data['has_richsync'] = this.hasRichsync;
    data['num_favourite'] = this.numFavourite;
    data['album_id'] = this.albumId;
    data['album_name'] = this.albumName;
    data['artist_id'] = this.artistId;
    data['artist_name'] = this.artistName;
    data['track_share_url'] = this.trackShareUrl;
    data['track_edit_url'] = this.trackEditUrl;
    data['restricted'] = this.restricted;
    data['updated_time'] = this.updatedTime;
    if (this.primaryGenres != null) {
      data['primary_genres'] = this.primaryGenres.toJson();
    }
    return data;
  }
}

class PrimaryGenres {
  List<MusicGenreList> musicGenreList;

  PrimaryGenres({this.musicGenreList});

  PrimaryGenres.fromJson(Map<String, dynamic> json) {
    if (json['music_genre_list'] != null) {
      musicGenreList = new List<MusicGenreList>();
      json['music_genre_list'].forEach((v) {
        musicGenreList.add(new MusicGenreList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.musicGenreList != null) {
      data['music_genre_list'] =
          this.musicGenreList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MusicGenreList {
  MusicGenre musicGenre;

  MusicGenreList({this.musicGenre});

  MusicGenreList.fromJson(Map<String, dynamic> json) {
    musicGenre = json['music_genre'] != null
        ? new MusicGenre.fromJson(json['music_genre'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.musicGenre != null) {
      data['music_genre'] = this.musicGenre.toJson();
    }
    return data;
  }
}

class MusicGenre {
  int musicGenreId;
  int musicGenreParentId;
  String musicGenreName;
  String musicGenreNameExtended;
  String musicGenreVanity;

  MusicGenre(
      {this.musicGenreId,
      this.musicGenreParentId,
      this.musicGenreName,
      this.musicGenreNameExtended,
      this.musicGenreVanity});

  MusicGenre.fromJson(Map<String, dynamic> json) {
    musicGenreId = json['music_genre_id'];
    musicGenreParentId = json['music_genre_parent_id'];
    musicGenreName = json['music_genre_name'];
    musicGenreNameExtended = json['music_genre_name_extended'];
    musicGenreVanity = json['music_genre_vanity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['music_genre_id'] = this.musicGenreId;
    data['music_genre_parent_id'] = this.musicGenreParentId;
    data['music_genre_name'] = this.musicGenreName;
    data['music_genre_name_extended'] = this.musicGenreNameExtended;
    data['music_genre_vanity'] = this.musicGenreVanity;
    return data;
  }
}
