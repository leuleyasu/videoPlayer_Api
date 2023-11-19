import 'package:flutter/material.dart';
import '../model/video_model.dart';
import '../screen/video_view.dart';
class VideoPlayingGridView extends StatelessWidget {
  final List<VideoPlaying> videoPlayings;

  const VideoPlayingGridView({super.key, required this.videoPlayings});



  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: videoPlayings.length,
      itemBuilder: (context, index) {
        VideoPlaying videoPlaying = videoPlayings[index];
        return GestureDetector(
          onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (context) =>
         CustomVideoPlayer(videoUrl: videoPlaying.videoUrl, desciprition: videoPlaying.description, title: videoPlaying.title,),
         ));
                  // print('Tapped on ${videoPlaying.title}');)
          },
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
               height: 20,
              child: Padding(
                  padding: const  EdgeInsets.all(2.0),
                  child: Text(
                    videoPlaying.title,
                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),),
                 Image.network(
                    videoPlaying.thumbanail,
                    height: 120.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),


              ],
            ),
          ),
        );
      },
    );
  }
}
