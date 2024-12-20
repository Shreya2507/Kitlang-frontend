import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './all_constants.dart';
import './ques_ans_file.dart';
import './reusable_card.dart';

class Flashcards extends StatefulWidget {
  const Flashcards({Key? key}) : super(key: key);

  @override
  _FlashcardsState createState() => _FlashcardsState();
}

class _FlashcardsState extends State<Flashcards> {
  int _currentIndexNumber = 0;
  double _initial = 0.1;

  @override
  Widget build(BuildContext context) {
    String value = (_initial * 10).toStringAsFixed(0);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: Text("Flashcards", style: TextStyle(fontSize: 30)),
              backgroundColor: mainColor,
              toolbarHeight: 80,
              elevation: 5,
              shadowColor: mainColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/flashcards/bg.png'), // Path to your image
                fit: BoxFit.contain, // Adjusts the image to cover the container
              ),
              borderRadius:
                  BorderRadius.circular(20), // Optional: Rounded corners
            ),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Text("Question $value of 10 Completed",
                      style: otherTextStyle),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                      minHeight: 5,
                      value: _initial,
                    ),
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                      width: 300,
                      height: 300,
                      child: FlipCard(
                          direction: FlipDirection.VERTICAL,
                          front: ReusableCard(
                              text: quesAnsList[_currentIndexNumber].question),
                          back: ReusableCard(
                              text: quesAnsList[_currentIndexNumber].answer))),
                  Text("Tap card to check answer",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 50),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        ElevatedButton.icon(
                            onPressed: () {
                              showPreviousCard();
                              updateToPrev();
                            },
                            icon: Icon(
                              FontAwesomeIcons.handPointLeft,
                              size: 30,
                              color: Colors.black,
                            ),
                            label: Text(""),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(
                                    255, 182, 193, 1) // LightPink
                                ,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.only(
                                    right: 20, left: 25, top: 15, bottom: 15))),
                        ElevatedButton.icon(
                            onPressed: () {
                              showNextCard();
                              updateToNext();
                            },
                            icon: Icon(
                              FontAwesomeIcons.handPointRight,
                              size: 30,
                              color: Colors.black,
                            ),
                            label: Text(""),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(
                                    255, 182, 193, 1) // LightPink
                                ,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.only(
                                    right: 20, left: 25, top: 15, bottom: 15)))
                      ])
                ])),
          )),
    );
  }

  void updateToNext() {
    setState(() {
      _initial = _initial + 0.1;
      if (_initial > 1.0) {
        _initial = 0.1;
      }
    });
  }

  void updateToPrev() {
    setState(() {
      _initial = _initial - 0.1;
      if (_initial < 0.1) {
        _initial = 1.0;
      }
    });
  }

  void showNextCard() {
    setState(() {
      _currentIndexNumber = (_currentIndexNumber + 1 < quesAnsList.length)
          ? _currentIndexNumber + 1
          : 0;
    });
  }

  void showPreviousCard() {
    setState(() {
      _currentIndexNumber = (_currentIndexNumber - 1 >= 0)
          ? _currentIndexNumber - 1
          : quesAnsList.length - 1;
    });
  }
}
