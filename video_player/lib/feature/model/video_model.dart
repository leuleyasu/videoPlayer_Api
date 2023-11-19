// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class VideoPlaying extends Equatable {
   String apiUrl="https://app.et/devtest/list.json";

  // Private constructor to prevent external instantiation
VideoPlaying._();

  // Singleton instance
  static final VideoPlaying _instance = VideoPlaying._();
 @override
  // TODO: implement props
  List<Object?> get props => [title,description,thumbanail,videoUrl];
  static VideoPlaying get instance => _instance;
 late String title;
  late String videoUrl;
  late String thumbanail;
  late String description;

  VideoPlaying({
    required this.title,
    required this.videoUrl,
    required this.thumbanail,
    required this.description,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'videoTitle': title,
      'videoUrl': videoUrl,
      'videoThumbnail': thumbanail,
      'videoDescription': description,
    };
  }

  factory VideoPlaying.fromMap(Map<String, dynamic> map) {
    return VideoPlaying(
      title: map['videoTitle'] as String,
      videoUrl: map['videoUrl'] as String,
      thumbanail: map['videoThumbnail'] as String,
      description: map['videoDescription'] as String,
    );
  }

  String toJson() => json.encode(toMap());

factory VideoPlaying.fromJson(Map<String, dynamic> json) {
  return VideoPlaying(
    title: json['videoTitle'] as String? ?? 'Unknown Title',
    videoUrl: json['videoUrl'] as String,
    thumbanail: json['videoThumbnail'] as String? ?? 'Unknown Thumbnail',
    description: json['videoDescription'] as String? ?? 'No Description',
  );
}


  @override
  String toString() {
    return 'VideoPlaying(title: $title, videoUrl: $videoUrl, thumbanail: $thumbanail, description: $description)';
  }




  static Future<bool> hasNetwork(String apiUrl) async {
    try {

      final response = await http.head(Uri.parse(apiUrl));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }



static Future<List<VideoPlaying>>fetchVideoPlayings(String apiUrl) async {
  try {

    if (await hasNetwork(apiUrl)) {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('videos')) {
          List<dynamic> data = responseData['videos'];
          List<VideoPlaying> videoPlayings =
              data.map((videoitem) => VideoPlaying.fromJson(videoitem)).toList();

          return videoPlayings;
        } else {
          throw Exception('videos not found');
        }
      } else {
        throw Exception('Failed to load video. HTTP Status Code: ${response.statusCode}');
      }
    } else{
      throw Exception("Something went wrong!");
    }
  } catch (e) {
    throw Exception('Error fetching VideoPlayings: $e');
  }
}
 static Future<List<VideoPlaying>> saveVideoPlayingsToLocal(List<VideoPlaying> videoPlayings) async {
  const String apiUrl = "https://app.et/devtest/list.json";

  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> videoPlayingsJsonList =
      videoPlayings.map((videoPlaying) => videoPlaying.toJson()).toList();

  // Save the list of video playings as JSON strings
   prefs.setStringList('videoPlayings',
    videoPlayingsJsonList.map((jsonItem) => json.encode(jsonItem)).toList());


  final response = await http.get(Uri.parse(apiUrl));

  try {
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      Map<String, dynamic> responseData = json.decode(response.body);

      // Check if the key 'videos' exists in the response
      if (responseData.containsKey('videos')) {
        List<dynamic> data = responseData['videos'];
        List<VideoPlaying> videoPlayings =
            data.map((videoitem) => VideoPlaying.fromJson(videoitem)).toList();
          saveVideoPlayingsToLocal(videoPlayings);

        return videoPlayings;
      }
    } else {
      // Handle other HTTP status codes if needed
      // You can add additional logic here based on your requirements
    }
  } catch (e) {
    throw Exception(e);
  }

  // Return an empty list if the response doesn't contain 'videos' or if there's an error
  return [];
}


static Future<List<VideoPlaying>> getVideoPlayingsFromLocal() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? videoPlayingsJsonList = prefs.getStringList('videoPlayings');

  if (videoPlayingsJsonList != null) {
    List<VideoPlaying> videoPlayings = videoPlayingsJsonList
        .map((jsonItem) => VideoPlaying.fromJson(json.decode(jsonItem)))
        .toList();
    return videoPlayings;
  } else {
    return [];
  }
}
}
