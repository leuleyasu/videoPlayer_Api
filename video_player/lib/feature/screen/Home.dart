import 'package:flutter/material.dart';
import 'dart:developer' as devloper show log;
import '../model/video_model.dart';
import '../widget/VideoPlayingGridView.dart';


class HomeScreen extends StatelessWidget {
  final String apiUrl="https://app.et/devtest/list.json";
 const  HomeScreen({Key? key, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Videos'),
          actions: [
            IconButton(onPressed: (){}, icon: const Icon(Icons.share)),
            IconButton(onPressed: (){}, icon: const Icon(Icons.star)),

          ],
        ),
        body: FutureBuilder(
          future: VideoPlaying.fetchVideoPlayings(apiUrl),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none) {
           List<VideoPlaying> videoPlayings = snapshot.data as List<VideoPlaying>;
              return VideoPlayingGridView(videoPlayings: videoPlayings);
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Ensure that the response from fetchVideoPlayings is a List<VideoPlaying>
              List<VideoPlaying> videoPlayings = snapshot.data as List<VideoPlaying>;
              return VideoPlayingGridView(videoPlayings: videoPlayings);
            }
          },
        ),
      ),
    );
  }
}
