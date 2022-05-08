import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:objecto_detecto_app/HomePage.dart';
import 'package:splashscreen/splashscreen.dart';

// AudioPlayer player = AudioPlayer();

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   player.setAsset('assets/welcome.wav');
  // }
  //
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   player.dispose();
  // }
  //
  // Function playSound = () {
  //   player.play();
  //   return 1;
  // };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          "Objecto Detecto App",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info_sharp),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      'This is Simple Object Detection App made by Narayan')));
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SplashScreen(
            backgroundColor: Colors.black87,
            seconds: 9000,
            navigateAfterSeconds: HomePage(),
            imageBackground: Image.asset(
              "assets/Anime_Robo-removebg.png",
            ).image,
            useLoader: true,
            loaderColor: Colors.red,
            loadingText: Text(
              "Objecto Loading...",
              style: TextStyle(
                color: Colors.redAccent,
                backgroundColor: Colors.white54,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                decorationThickness: 5.5,
              ),
            ),
          ),
          TypewriterAnimatedTextKit(
            speed: Duration(milliseconds: 1000),
            totalRepeatCount: 1,
            text: ['Welcome Master !!!'],
            textStyle: TextStyle(
              fontSize: 40.0,
              color: Colors.red,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
