// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
 import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:developer' as developer show log;

import '../model/video_model.dart';
class CustomVideoPlayer extends StatefulWidget {
  final String? videoUrl;
  String desciprition;
  String title;

  CustomVideoPlayer({
    Key? key,
    this.videoUrl,
    required this.desciprition,
    required this.title,
  }) : super(key: key);

  @override
  _CustomVideoPlayerState createState() {
    return _CustomVideoPlayerState();
  }
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late final VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();

    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl ?? ''))
          ..initialize().then((_) {
            setState(() {});
          });
          _controller.play();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "",
        home: Scaffold(
            body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              const   SizedBox(height: 15,),
                _controller.value.isInitialized
                    ? SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                    )
                    : Container(
                        decoration: const BoxDecoration(color: Colors.amber),
                      ),
                Text(
                  widget.desciprition,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            )),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause():
                      _controller.play();


                });
              },
              child: Icon(
                _controller.value.isPlaying ?Icons.pause:Icons.play_arrow
              ),
            )));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

Future<void> showInterstitialAd(BuildContext context, VideoPlaying videoPlaying) async {
    InterstitialAd? interstitialAd;
    bool adLoaded = false;
 final adUnitId = Platform.isAndroid
    ? 'ca-app-pub-3940256099942544/1033173712'
    : 'ca-app-pub-3940256099942544/4411468910';
    // const AdRequest request = AdRequest(
    //   testDevices: ['your-test-device-id'],
    // );

    InterstitialAd.load(
      adUnitId:adUnitId, // Replace with your ad unit ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          adLoaded = true;
        },
        onAdFailedToLoad: (error) {
          developer.log('Interstitial Ad failed to load: $error');
          // print('Interstitial Ad failed to load: $error');
        },
      ),
    );

    // Wait until the ad is loaded
    while (!adLoaded) {
      await Future.delayed(const Duration(milliseconds: 200));
    }

    // Show the interstitial ad
    if (interstitialAd != null) {
      await interstitialAd!.show();
      interstitialAd = null; // Dispose of the ad after it's shown

      // After showing the interstitial ad, navigate to the VideoPlayer
     if (context.mounted) {
       Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomVideoPlayer(videoUrl: videoPlaying.videoUrl,
           desciprition: videoPlaying.description, title: videoPlaying.title,),
        ),
      );

     }
    }
  }
