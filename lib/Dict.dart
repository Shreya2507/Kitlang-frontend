import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  TextEditingController _controller = TextEditingController();
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
      String temp = word[0].toUpperCase() + word.substring(1);
      if (!fav.contains(temp)) {
        fav.add(temp); // Update the history list
      }
    });
    print("FAVSS :" + fav.toString());
  }

  void _searchWord() {
    setState(() {
      if (_controller.text.trim() != "") {
        if (_controller.text.trim().split(" ").length == 1) {
          _futureResponse =
              API.fetchMeaning(_controller.text.trim().toLowerCase());
        } else {
          _futureResponse = API.fetchMeaning(
              _controller.text.trim().split(" ")[0].toLowerCase());
        }
      } else {
        setState(() {
          _futureResponse = null;
        });
      }
    });
  }

  void _goHome() {
    setState(() {
      _futureResponse = null;
    });
  }

  FlutterTts flutterTts = FlutterTts();

  Future<void> configureTts() async {
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
  }

  void speakText(String text, String sourceLang) async {
    if (sourceLang != 'en-US') {
      String languageCode = sourceLang + '-' + sourceLang.toUpperCase();
      await flutterTts.setLanguage(languageCode);
      await flutterTts.speak(text);
      print("Attempting to speak: $text in $sourceLang : $languageCode");
    } else {
      await flutterTts.setLanguage('en-US');
      await flutterTts.speak(text);
      print("Attempting to speak: $text in $sourceLang : en-US");
    }
  }

  void stopSpeaking() async {
    await flutterTts.stop();
  }

  _searchFav(fav) {
    setState(() {
      _controller.text = fav;
    });
  }

  String titleWord(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
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
                Color.fromRGBO(255, 200, 117, 1),
                Color.fromRGBO(253, 220, 173, 1),
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(255, 232, 198, 1)
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
                      suffix: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite_rounded),
                            onPressed: _goHome,
                          ),
                          IconButton(
                            icon: Icon(Icons.search),
                            onPressed: _searchWord,
                          ),
                        ],
                      )),
                ),
                Expanded(
                    child: _futureResponse == null
                        ? (fav.isEmpty
                            ? Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Expanded(
                                        child: Container(
                                            width: 180,
                                            child: Lottie.asset(
                                                "assets/dict/anim.mp4.lottie.json")),
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 80,
                                            child: Lottie.asset(
                                                "assets/dict/anim.mp4.lottie.json")),
                                        SizedBox(
                                          width: 10,
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
                                      ],
                                    ),
                                    // Spacing between heading and list
                                    Expanded(
                                      // Allows the ListView to scroll if needed
                                      child: ListView.builder(
                                        itemCount: fav.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical:
                                                    8.0), // Margin between buttons
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5, // 80% of the screen width
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all(
                                                        colors[index %
                                                            colors.length]),
                                              ),
                                              onPressed: () =>
                                                  _searchFav(fav[index]),
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
                                final sourceLanguage =
                                    wordData['sourceLanguage'];
                                final originalWord = wordData['originalWord'];
                                final langCode = wordData['langCode'];

                                return ListView(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          titleWord(word),
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Align(
                                              alignment: Alignment
                                                  .topRight, // Position it at the top left
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.blue[
                                                      600], // Background color
                                                  shape: BoxShape
                                                      .circle, // Make it round
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 6,
                                                      offset: Offset(0,
                                                          2), // Shadow effect
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
                                                  onPressed: () =>
                                                      speakText(word, 'en-US'),
                                                  padding: EdgeInsets.all(
                                                      10), // Adjust padding for better touch area
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Align(
                                              alignment: Alignment
                                                  .topRight, // Position it at the top left
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red[
                                                      700], // Background color
                                                  shape: BoxShape
                                                      .circle, // Make it round
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 6,
                                                      offset: Offset(0,
                                                          2), // Shadow effect
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
                                                  onPressed: () =>
                                                      _addToFav(originalWord),
                                                  padding: EdgeInsets.all(
                                                      10), // Adjust padding for better touch area
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    if (sourceLanguage != 'english')
                                      Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (sourceLanguage.isNotEmpty)
                                            Text(
                                                '${sourceLanguage} : ${titleWord(originalWord)}'),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.green[
                                                  600], // Background color
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
                                              onPressed: () => speakText(
                                                  originalWord, langCode),
                                              padding: EdgeInsets.all(
                                                  10), // Adjust padding for better touch area
                                            ),
                                          ),
                                        ],
                                      ),
                                    SizedBox(
                                      height: 10,
                                    ),
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
