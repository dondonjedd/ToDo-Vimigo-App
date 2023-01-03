import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_vimigo_app/Views/Screens/tabsScreen.dart';
import 'package:todo_vimigo_app/utils.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onStartTuto(context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("showHome", true);
    Navigator.of(context).popAndPushNamed(TabsScreen.routeName);
  }

  void _onSkipTuto(context) async {
    resetTutorial(true);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("showHome", true);
    Navigator.of(context).popAndPushNamed(TabsScreen.routeName);
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.only(top: 20),
      imageFlex: 2,
      bodyFlex: 3,
      footerPadding: EdgeInsets.only(top: 150),
    );

    return Scaffold(
        body: IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          image: _buildImage('vimigo_logo_vertical_color.png'),
          title: "Welcome To\nVimigo To Do App",
          body: "This is an Application to Keep Track of All Your ToDos ",
          footer: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text(
                "An interactive tutorial will guide you\nwhenever you enter a new page",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          decoration: pageDecoration.copyWith(
            bodyAlignment: Alignment.center,
          ),
        ),
      ],
      skipOrBackFlex: 0,
      dotsFlex: 0,
      showSkipButton: false,
      onDone: () {},
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () => _onSkipTuto(context),
            child: const Text('Skip Tutorial',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () => _onStartTuto(context),
            child: const Text('Start Tutorial',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      isProgress: false,
    ));
  }
}