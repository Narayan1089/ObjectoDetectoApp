import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isWorking = false;
  String result = "";
  late CameraController cameraController;
  CameraImage? imgCamera;
  final player = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  late CarouselSlider carouselSlider;
  int _current = 0;

  List imgList = [
    'assets/b1.jpg',
    'assets/b2.jpg',
    'assets/b4.jpg',

    // 'https://images.unsplash.com/photo-1502117859338-fd9daa518a9a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    // 'https://images.unsplash.com/photo-1554321586-92083ba0a115?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    // 'https://images.unsplash.com/photo-1536679545597-c2e5e1946495?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    // 'https://images.unsplash.com/photo-1543922596-b3bbaba80649?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    // 'https://images.unsplash.com/photo-1502943693086-33b5b1cfdf2f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80'
  ];

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/trainedModel.tflite",
      labels: "assets/labels.txt",
    );
  }

  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.ultraHigh);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        cameraController.startImageStream((imagesFromStream) => {
              if (!isWorking)
                {
                  isWorking = true,
                  imgCamera = imagesFromStream,
                  runModelOnStreamFrames(),
                }
            });
      });
    });
  }

  runModelOnStreamFrames() async {
    if (imgCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: imgCamera!.height,
        imageWidth: imgCamera!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 1,
        threshold: 0.1,
        asynch: true,
      );

      result = "";

      recognitions!.forEach((response) {
        result += response["label"] +
            " " +
            "\n" +
            (response["confidence"] as double).toStringAsFixed(2) +
            "\n\n";
      });

      setState(() {
        result;
      });
      isWorking = false;
    }
  }

  @override
  void initState() {
    super.initState();
    // player.setAsset('assets/welcome.wav');

    loadModel();
  }

  @override
  void dispose() async {
    super.dispose();
    // player.dispose();

    await Tflite.close();
    cameraController.dispose();
  }

  // Function playSound = () {
  //   player.play();
  //   return 1;
  // };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/cp.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.30,
                        width: 200,
                        child: Image.asset("assets/clicko.png"),
                      ),
                    ),
                    Center(
                      child: FlatButton(
                        onPressed: () {
                          initCamera();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5),
                          height: 200,
                          width: 390,
                          child: imgCamera == null
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.30,
                                  width: 380,
                                  child: Icon(
                                    Icons.photo_camera_front,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                )
                              : AspectRatio(
                                  aspectRatio:
                                      cameraController.value.aspectRatio,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 4, color: Colors.white),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Stack(children: [
                                      CameraPreview(cameraController),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.white,
                                        ),
                                        tooltip: 'Close the stream',
                                        onPressed: () {
                                          setState(() {
                                            cameraController.stopImageStream();
                                            isWorking = false;
                                          });
                                        },
                                      ),
                                      Positioned(
                                        top: 40,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.restart_alt,
                                            color: Colors.white,
                                          ),
                                          tooltip: 'Restart the stream',
                                          onPressed: () {
                                            setState(() {
                                              cameraController.startImageStream(
                                                  (imagesFromStream) => {
                                                        if (!isWorking)
                                                          {
                                                            isWorking = true,
                                                            imgCamera =
                                                                imagesFromStream,
                                                            runModelOnStreamFrames(),
                                                          }
                                                      });
                                            });
                                          },
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30, left: 60),
                          child: Text(
                            result.toUpperCase(),
                            style: TextStyle(
                              backgroundColor: Colors.black54,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            // margin: EdgeInsets.only(top: 10),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Image.asset(
                                "assets/se.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CarouselSlider(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.34,
                                      initialPage: 0,
                                      enlargeCenterPage: true,
                                      autoPlay: true,
                                      reverse: false,
                                      enableInfiniteScroll: true,
                                      autoPlayInterval: Duration(seconds: 6),
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 200),
                                      pauseAutoPlayOnTouch:
                                          Duration(seconds: 10),
                                      scrollDirection: Axis.horizontal,
                                      onPageChanged: (index) {
                                        setState(() {
                                          _current = index;
                                        });
                                      },
                                      items: imgList.map((imgUrl) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10.0),
                                              // decoration: BoxDecoration(
                                              //   color: Colors.green,
                                              // ),
                                              child: Image.asset(
                                                imgUrl,
                                                // fit: BoxFit.fill,
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Container(
// margin: EdgeInsets.only(top: 10),
// child: Container(
// height: 200,
// child: Image.asset(
// "assets/0.png",
// ),
// ),
// ),

// Column(
// children: [
// Row(
// children: [
// Expanded(
// child: Container(
// margin: EdgeInsets.only(top: 10),
// child: Container(
// height: 200,
// child: Image.asset(
// "assets/0.png",
// ),
// ),
// ),
// ),
// ],
// )
// ],
// ),

// ImageSlideshow(
// width: 150,
// height: 220,
// initialPage: 0,
// indicatorColor: Colors.blue,
// indicatorBackgroundColor: Colors.grey,
// children: [
// Image.asset(
// 'assets/0.png',
// // fit: BoxFit.cover,
// ),
// Image.asset(
// 'assets/1.png',
// // fit: BoxFit.cover,
// ),
// Image.asset(
// 'assets/2.png',
// // fit: BoxFit.contain,
// ),
// ],
// onPageChanged: (value) {
// print('Page changed: $value');
// },
// autoPlayInterval: 50,
// ),
