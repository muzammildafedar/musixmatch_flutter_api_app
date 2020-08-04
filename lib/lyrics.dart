import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
class lyricsss extends StatefulWidget {
  final int id;
  lyricsss({Key key, this.id}) : super(key: key);
  @override
  _lyricsssState createState() => _lyricsssState();
}
class _lyricsssState extends State<lyricsss> {
//  void initState() {
//    fetchDetails(widget.id);
//  }
  Future<lyricsData> fetch_lyric(int id) async {
    final response2 = await http.get(
        'https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$id&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7');

    if ( response2.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return lyricsData.fromJson(json.decode(response2.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
  @override

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  FutureBuilder<lyricsData>(
      future: fetch_lyric(widget.id),
      builder: (context, snapshot2) {
        if (snapshot2.hasData) {
          return Column(
            children: [
              Text(
                  '${snapshot2.data.message.body}'),
              Text('${snapshot2.data.message.body}')
            ],
          );
        } else if (snapshot2.hasError) {
          return Text("${snapshot2.error}");
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }
}


class lyricsData {
  Message message;

  lyricsData({this.message});

  lyricsData.fromJson(Map<String, dynamic> json) {
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
  Lyrics lyrics;

  Body({this.lyrics});

  Body.fromJson(Map<String, dynamic> json) {
    lyrics =
    json['lyrics'] != null ? new Lyrics.fromJson(json['lyrics']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lyrics != null) {
      data['lyrics'] = this.lyrics.toJson();
    }
    return data;
  }
}

class Lyrics {
  int lyricsId;
  int explicit;
  String lyricsBody;
  String scriptTrackingUrl;
  String pixelTrackingUrl;
  String lyricsCopyright;
  String updatedTime;

  Lyrics(
      {this.lyricsId,
        this.explicit,
        this.lyricsBody,
        this.scriptTrackingUrl,
        this.pixelTrackingUrl,
        this.lyricsCopyright,
        this.updatedTime});

  Lyrics.fromJson(Map<String, dynamic> json) {
    lyricsId = json['lyrics_id'];
    explicit = json['explicit'];
    lyricsBody = json['lyrics_body'];
    scriptTrackingUrl = json['script_tracking_url'];
    pixelTrackingUrl = json['pixel_tracking_url'];
    lyricsCopyright = json['lyrics_copyright'];
    updatedTime = json['updated_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lyrics_id'] = this.lyricsId;
    data['explicit'] = this.explicit;
    data['lyrics_body'] = this.lyricsBody;
    data['script_tracking_url'] = this.scriptTrackingUrl;
    data['pixel_tracking_url'] = this.pixelTrackingUrl;
    data['lyrics_copyright'] = this.lyricsCopyright;
    data['updated_time'] = this.updatedTime;
    return data;
  }
}