import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:objecto_detecto_app/HomePage.dart';

final player = AudioCache();
const colorizeColors = [
  Colors.purple,
  Colors.blue,
  Colors.yellow,
  Colors.red,
];

const colorizeTextStyle = TextStyle(
  fontSize: 30.0,
  fontFamily: 'Horizon',
  fontWeight: FontWeight.bold,
);

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(seconds: 2), () {
    //   player.play('hehto.mp3');
    // });
    // Future.delayed(Duration(seconds: 5), () {
    //   player.play('welcome.mp3');
    // });

    Future.delayed(Duration(seconds: 8), () {
      // 5 seconds over, navigate to Page2.
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
    });
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black54,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/wp2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/p2.png'),
                  backgroundColor: Colors.white24,
                ),

                AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'Melanoma Detecto App',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                  ],
                  isRepeatingAnimation: true,
                  repeatForever: true,
                  onTap: null,
                ),

                // TypewriterAnimatedTextKit(
                //   speed: Duration(milliseconds: 300),
                //   totalRepeatCount: 1,
                //   text: ['Objecto Detecto App'],
                //   textStyle: TextStyle(
                //     fontFamily: 'Source Sans Pro',
                //     fontSize: 30.0,
                //     color: Colors.white,
                //     fontWeight: FontWeight.w900,
                //   ),
                // ),
                Image.asset(
                  'assets/cc.png',
                  height: MediaQuery.of(context).size.height * 0.62,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome !!',
                      style: TextStyle(
                        fontFamily: 'Source Sans Pro',
                        fontSize: 30,
                        color: Colors.black,
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                      width: 150,
                      child: Divider(
                        color: Colors.teal.shade100,
                        indent: 10,
                      ),
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    AnimatedTextKit(
                      animatedTexts: [
                        RotateAnimatedText('Loading...',
                            textStyle:
                                TextStyle(color: Colors.black, fontSize: 18)),
                        RotateAnimatedText('Please wait moment',
                            textStyle:
                                TextStyle(color: Colors.black, fontSize: 18)),
                        RotateAnimatedText('╭∩╮(◉..◉)╭∩╮',
                            textStyle:
                                TextStyle(color: Colors.black, fontSize: 18)),
                      ],
                      repeatForever: true,
                      onTap: null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
