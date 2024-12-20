import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> cardTitles = ["German A1", "German A2", "German B1"];
  final List<String> cardTime = ["2hrs", "3hrs", "5hrs"];
  // final List<String> cardTopics = ["2hrs", "3hrs", "5hrs"];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            // Background image and content
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/home/bg.jpg'),
                  fit: BoxFit
                      .cover, // Ensure the image covers the entire container
                ),
              ),
            ),

            // Positioned Text (Hello User) at the top
            Positioned(
              top: 90,
              left: 20,
              child: Container(
                child: Text(
                  "Hello User !",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 27,
                    color: const Color.fromARGB(255, 57, 57, 57),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Positioned Text (This is a card) in the center
            Positioned(
              top: 250,
              left: 0,
              right: 0,
              child: Text(
                "Learn something new today",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 57, 57, 57),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Positioned(
              top: 290,
              left: 40,
              right: 40,
              bottom: 120,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cardTitles.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    height: 370,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: Color(0xFFA09E9D), width: 1),
                      ),
                      color: Color(0xFFE7DDFF), // Pastel purple
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/home/cardImage.png',
                                width: 150,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                cardTitles[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF966DFC),
                                ),
                              ),
                            ),
                            // SizedBox(height: 5),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Time Estimate: ${cardTime[index]}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF7A62B7),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 25),
                            Center(
                              child: ElevatedButton(
                                onPressed: () => (),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF966DFC),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset('assets/home/buttonIcon.png'),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Let's Learn",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom App Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomAppBar(
                padding: EdgeInsets.all(0),
                color: Color.fromARGB(121, 211, 222, 250),
                notchMargin: 0,
                child: SizedBox(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.house),
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.bookOpen),
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.trophy),
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.solidUser),
                        onPressed: () {
                          setState(() {});
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
