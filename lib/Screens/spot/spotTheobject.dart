import 'dart:typed_data';
import 'dart:ui';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:frontend/Screens/Introductions/completion_screen.dart';
import 'package:frontend/Screens/spot/RibbonBanner.dart';
import 'package:frontend/Screens/spot/cute_info_dialog.dart';

class SpotGameScreen extends StatefulWidget {
  final int chapterIndex;
  final int topicIndex;

  SpotGameScreen(
      {super.key, required this.chapterIndex, required this.topicIndex});

  @override
  State<SpotGameScreen> createState() => _SpotGameScreenState();
}

class _SpotGameScreenState extends State<SpotGameScreen> {
  // Uint8List? _imageData;
  int? _originalImageWidth;
  int? _originalImageHeight;
  List<dynamic> _detections = [];
  bool _isLoading = true;
  String? _errorMessage;
  final GlobalKey _imageContainerKey = GlobalKey();
  final String apiEndpoint =
      "https://saran-2021-backend-kitlang.hf.space/spot_the_object";

  final double imageDisplayWidth = 400;
  final double imageDisplayHeight = 300;
  final Map<int, bool> _foundObjects = {};

  @override
  void initState() {
    super.initState();
    _fetchGameData();
  }

  Future<void> _fetchGameData() async {
    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));

      final response = await dio.get(
        "$apiEndpoint/${widget.chapterIndex}/99",
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        print("API Response: $data"); // Debug print

        // Handle image data
        // if (data.containsKey('image_base64') && data['image_base64'] != null) {
        //   try {
        //     // Remove data:image/...;base64, prefix if present
        //     String base64String = data['image_base64'];
        //     if (base64String.contains(',')) {
        //       base64String = base64String.split(',').last;
        //     }
        //     // _imageData = base64.decode(base64String);
        //   } catch (e) {
        //     print("Base64 decode error: $e");
        //     setState(() {
        //       _errorMessage = 'Invalid image data';
        //       _isLoading = false;
        //     });
        //     return;
        //   }
        // }

        // Handle detections
        if (data.containsKey('bounding_boxes')) {
          _detections = data['bounding_boxes'];
        } else {
          print("No bounding boxes in response");
        }

        // Handle original size
        if (data.containsKey('original_size')) {
          final Map<String, dynamic> originalSize = data['original_size'];
          _originalImageWidth = originalSize['width'];
          _originalImageHeight = originalSize['height'];
        }

        setState(() {
          _isLoading = false;
          _errorMessage = null;
          for (int i = 0; i < _detections.length; i++) {
            _foundObjects[i] = false;
          }
        });
      } else {
        setState(() {
          _errorMessage =
              'Failed to load game data. Status code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error fetching data: $error';
        _isLoading = false;
      });
      print('Error fetching data: $error');
    }
  }

  Rect? _getScaledRectForIndex(BuildContext context, int index) {
    if (_originalImageWidth == null ||
        _originalImageHeight == null ||
        _detections.isEmpty ||
        index >= _detections.length) {
      return null;
    }

    final RenderBox? imageBox =
        _imageContainerKey.currentContext?.findRenderObject() as RenderBox?;
    if (imageBox == null) {
      print("Error: RenderBox for image container is null in getScaledRect.");
      return null;
    }
    final Size containerSize = imageBox.size;
    final currentDetection = _detections[index];
    final List box2d = currentDetection['box_2d'];
    final Rect targetArea = Rect.fromLTWH(
      box2d[0].toDouble(),
      box2d[1].toDouble(),
      (box2d[2] - box2d[0]).toDouble(),
      (box2d[3] - box2d[1]).toDouble(),
    );

    final double imageAspectRatio =
        _originalImageWidth! / _originalImageHeight!;
    final double containerAspectRatio =
        containerSize.width / containerSize.height;

    double scaleX;
    double scaleY;
    double offsetX = 0;
    double offsetY = 0;

    if (imageAspectRatio > containerAspectRatio) {
      scaleX = containerSize.width / _originalImageWidth!;
      scaleY = scaleX;
      offsetY = (containerSize.height - _originalImageHeight! * scaleY) / 2;
    } else {
      scaleY = containerSize.height / _originalImageHeight!;
      scaleX = scaleY;
      offsetX = (containerSize.width - _originalImageWidth! * scaleX) / 2;
    }

    return Rect.fromLTWH(
      targetArea.left * scaleX + offsetX,
      targetArea.top * scaleY + offsetY,
      targetArea.width * scaleX,
      targetArea.height * scaleY,
    );
  }

  void _handleTap(BuildContext context, TapUpDetails details) {
    if (_detections.isEmpty) return;

    final RenderBox? imageBox =
        _imageContainerKey.currentContext?.findRenderObject() as RenderBox?;
    if (imageBox == null) {
      print("Error: RenderBox for image container is null.");
      return;
    }

    final Offset localOffset = imageBox.globalToLocal(details.globalPosition);

    for (int i = 0; i < _detections.length; i++) {
      final scaledTarget = _getScaledRectForIndex(context, i);
      if (scaledTarget != null &&
          scaledTarget.contains(localOffset) &&
          !_foundObjects[i]!) {
        setState(() {
          _foundObjects[i] = true;
        });
        break; // Found one, no need to check others for this tap
      }
    }

    if (_foundObjects.values.every((found) => found)) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => CompletionScreen(
              chapterIndex: widget.chapterIndex,
              topicIndex: widget.topicIndex,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 184, 77),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        actions: [
          GestureDetector(
            onTapDown: (details) {
              // Get tap position to open dialog at that position
              final tapPosition = details.globalPosition;
              showCuteDialog(
                context,
                tapPosition,
              ); // 👈 Your custom dialog function
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.info_outline,
                size: 28,
                color: const Color.fromARGB(255, 3, 92, 144),
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/spot/spotBack.jpg'),
            fit: BoxFit.cover, // Makes sure the image covers the entire screen
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, right: 8.0, left: 8.0),
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 60, 117, 182),
                    ),
                  )
                : _errorMessage != null
                    ? Text('Error: $_errorMessage')
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const RibbonBanner(),
                            const SizedBox(height: 15),

                            //Main container
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(204, 255, 255, 255),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 255, 207, 175),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 9,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              constraints: BoxConstraints(
                                maxWidth: 450,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        GestureDetector(
                                          onTapUp: (details) =>
                                              _handleTap(context, details),
                                          child: Container(
                                              key: _imageContainerKey,
                                              width: imageDisplayWidth,
                                              height: imageDisplayHeight,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  12,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    offset: Offset(0, 9),
                                                    blurRadius: 8,
                                                  ),
                                                ],
                                              ),
                                              child:
                                                  // _imageData != null ?
                                                  ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.asset(
                                                    "assets/spot/0${widget.chapterIndex}_99.png"),
                                                // child: Image.memory(
                                                //   _imageData!,
                                                //   fit: BoxFit.cover,
                                                //   width: imageDisplayWidth,
                                                //   height: imageDisplayHeight,
                                                //   errorBuilder: (context,
                                                //       error, stackTrace) {
                                                //     return Center(
                                                //         child: Text(
                                                //             'Failed to load image'));
                                                //   },
                                                // ),
                                              )
                                              // : const Center(
                                              //     child:
                                              //         CircularProgressIndicator(),
                                              //   ),
                                              ),
                                        ),
                                        Positioned(
                                          top: 12,
                                          right: 12,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            child: Text(
                                              'Found: ${_foundObjects.values.where((v) => v).length} / ${_foundObjects.length}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ..._detections
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          final int index = entry.key;
                                          final scaledRect =
                                              _getScaledRectForIndex(
                                            context,
                                            index,
                                          );
                                          final found =
                                              _foundObjects[index] ?? false;
                                          if (_foundObjects[index] == true &&
                                              scaledRect != null) {
                                            return Positioned(
                                              left: scaledRect.left,
                                              top: scaledRect.top,
                                              width: scaledRect.width,
                                              height: scaledRect.height,
                                              child: IgnorePointer(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          Colors.green.shade400,
                                                      width: 3,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return const SizedBox.shrink();
                                          }
                                        }),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    if (_detections.isNotEmpty)
                                      SingleChildScrollView(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            top: 10,
                                          ),
                                          padding: const EdgeInsets.only(
                                            top: 3,
                                            left: 3,
                                            right: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                              133,
                                              255,
                                              224,
                                              186,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors
                                                    .deepOrange.shade100
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Wrap(
                                            spacing: 8,
                                            runSpacing: 9,
                                            children: List.generate(
                                              _detections.length,
                                              (index) {
                                                final objectName =
                                                    _detections[index]['label'];
                                                final isFound =
                                                    _foundObjects[index] ==
                                                        true;

                                                return AnimatedContainer(
                                                  duration: const Duration(
                                                    milliseconds: 500,
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 5,
                                                    vertical: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: isFound
                                                        ? Colors.greenAccent
                                                            .shade100
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                      color: isFound
                                                          ? Colors.green
                                                          : Colors
                                                              .grey.shade300,
                                                      width: 2,
                                                    ),
                                                    boxShadow: [
                                                      const BoxShadow(
                                                        color: Colors.black12,
                                                        blurRadius: 4,
                                                        offset: Offset(2, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text(
                                                    objectName,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isFound
                                                          ? Colors
                                                              .green.shade800
                                                          : Colors.black87,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
