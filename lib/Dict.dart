import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(DictionaryApp());
}

class DictionaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dictionary',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DictionaryHomePage(),
    );
  }
}

class DictionaryHomePage extends StatefulWidget {
  @override
  _DictionaryHomePageState createState() => _DictionaryHomePageState();
}

class _DictionaryHomePageState extends State<DictionaryHomePage> {
  @override
  void initState() {
    super.initState();
    configureTts();
  }

  final TextEditingController _controller = TextEditingController();
  Future<Map<String, dynamic>>? _futureResponse;
  final List<Color> colors = [
    Color(0xFFE9FFB9),
    Color(0xFFDBF5FF),
    Color(0xFFFFDBF7),
    Color(0xFFFFE6C1),
    Color(0xFFFFAFAF),
  ];

  List fav = [];

  void _addToFav(word) {
    setState(() {
      if (!fav.contains(word)) {
        fav.add(word); // Update the history list
      }
    });
    print("FAVSS :" + fav.toString());
  }

  void _searchWord() {
    setState(() {
      if (_controller.text.trim() != "") {
        if (_controller.text.trim().split(" ").length == 1) {
          _futureResponse = API.fetchMeaning(_controller.text.trim());
        } else {
          _futureResponse =
              API.fetchMeaning(_controller.text.trim().split(" ")[0]);
        }
      } else {
        setState(() {
          _futureResponse = null;
        });
      }
    });
  }

  FlutterTts flutterTts = FlutterTts();

  Future<void> configureTts() async {
    await flutterTts.setLanguage('en-UK');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
  }

  void speakText(String text) async {
    print("Attempting to speak: $text");
    await flutterTts.speak(text);
  }

  void stopSpeaking() async {
    await flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(255, 200, 117, 100),
                Color.fromRGBO(253, 220, 173, 100),
                Color.fromRGBO(255, 255, 255, 100),
                Color.fromRGBO(255, 255, 255, 100),
                Color.fromRGBO(255, 255, 255, 100),
                Color.fromRGBO(255, 232, 198, 100)
              ],
              stops: [0.05, 0.1, 0.3, 0.82, 0.9, 1.0],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset("assets/dict/top.png"),
                Text(
                  "Dictionary!",
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Search Word',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _searchWord,
                    ),
                  ),
                ),
                Expanded(
                    child: _futureResponse == null
                        ? (fav.isEmpty
                            ? Center(
                                child: Column(children: [
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Container(
                                      width: 180,
                                      child: Lottie.asset(
                                          "assets/dict/anim.mp4.lottie.json")),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'No Favourites yet !',
                                    style: TextStyle(fontSize: 20),
                                  )
                                ]),
                              )
                            : Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // Minimize the size of the column
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      "Your Favorites", // Heading text
                                      style: TextStyle(
                                        fontSize:
                                            20.0, // Larger font size for heading
                                        fontWeight: FontWeight
                                            .bold, // Bold text for emphasis
                                      ),
                                    ),
                                    // Spacing between heading and list
                                    Expanded(
                                      // Allows the ListView to scroll if needed
                                      child: ListView.builder(
                                        itemCount: fav.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            color: colors[index %
                                                colors.length], // Rotate colors
                                            margin: EdgeInsets.all(8.0),
                                            child: Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Text(
                                                fav[index],
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                        : FutureBuilder<Map<String, dynamic>>(
                            future: _futureResponse,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize
                                        .min, // Minimize the size of the column
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        "Your Favorites", // Heading text
                                        style: TextStyle(
                                          fontSize:
                                              20.0, // Larger font size for heading
                                          fontWeight: FontWeight
                                              .bold, // Bold text for emphasis
                                        ),
                                      ),
                                      // Spacing between heading and list
                                      Expanded(
                                        // Allows the ListView to scroll if needed
                                        child: ListView.builder(
                                          itemCount: fav.length,
                                          itemBuilder: (context, index) {
                                            return Card(
                                              color: colors[index %
                                                  colors
                                                      .length], // Rotate colors
                                              margin: EdgeInsets.all(8.0),
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Text(
                                                  fav[index],
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                final wordData = snapshot.data!;
                                final word = wordData['word'];
                                final phonetics = wordData['phonetics'] as List;
                                final meanings = wordData['meanings'] as List;

                                return ListView(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Word: $word',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 20)),
                                        Align(
                                          alignment: Alignment
                                              .topRight, // Position it at the top left
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .black54, // Background color
                                              shape: BoxShape
                                                  .circle, // Make it round
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 6,
                                                  offset: Offset(
                                                      0, 2), // Shadow effect
                                                ),
                                              ],
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons
                                                    .volume_up, // Back arrow icon
                                                color: Colors
                                                    .white, // White color for better contrast
                                                size: 20, // Smaller size
                                              ),
                                              onPressed: () => speakText(word),
                                              padding: EdgeInsets.all(
                                                  10), // Adjust padding for better touch area
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment
                                              .topRight, // Position it at the top left
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .black54, // Background color
                                              shape: BoxShape
                                                  .circle, // Make it round
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 6,
                                                  offset: Offset(
                                                      0, 2), // Shadow effect
                                                ),
                                              ],
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons
                                                    .favorite_outline, // Back arrow icon
                                                color: Colors
                                                    .white, // White color for better contrast
                                                size: 20, // Smaller size
                                              ),
                                              onPressed: () => _addToFav(word),
                                              padding: EdgeInsets.all(
                                                  10), // Adjust padding for better touch area
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    if (phonetics.isNotEmpty)
                                      Text(
                                          'Phonetics: ${phonetics[0]['text']}'),
                                    SizedBox(height: 10),
                                    ...meanings.map((meaning) {
                                      final partOfSpeech =
                                          meaning['partOfSpeech'];
                                      final definitions =
                                          meaning['definitions'] as List;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Part of Speech: $partOfSpeech',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          ...definitions.map((definition) {
                                            final def =
                                                definition['definition'];
                                            final synonyms =
                                                (definition['synonyms'] as List)
                                                    .join(', ');
                                            final antonyms =
                                                (definition['antonyms'] as List)
                                                    .join(', ');
                                            final example =
                                                definition['example'] != null
                                                    ? (definition['example']
                                                            as List)
                                                        .join('; ')
                                                    : null;

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, top: 4.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Definition: $def'),
                                                  if (synonyms.isNotEmpty)
                                                    Text('Synonyms: $synonyms'),
                                                  if (antonyms.isNotEmpty)
                                                    Text('Antonyms: $antonyms'),
                                                  if (example != null)
                                                    Text('Example: $example'),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          Divider(),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                );
                              } else {
                                return Center(child: Text('No data found'));
                              }
                            },
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
