import 'package:flutter/material.dart';

import 'package:frontend/Screens/HomePage/HomePage.dart';

class Completed extends StatefulWidget {
  const Completed({Key? key}) : super(key: key);

  @override
  _CompletedState createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/flashcards/bg.png'),
            fit: BoxFit.contain,
          ),
        ),
        child: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[300], // Purple background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => (Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        )),
                    child: Icon(
                      Icons.home,
                      color: Colors.white,
                    )),
              ),
            ),
            SizedBox(
              height: 150,
            ),
            Image.asset(
              'assets/flashcards/completed.png',
              width: 250, // Set the desired width
              height: 200, // Set the desired height
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 100,
            ),
            Text(
              "You Completed The Story !",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 150,
            ),
          ],
        )),
      )),
    );
  }
}
