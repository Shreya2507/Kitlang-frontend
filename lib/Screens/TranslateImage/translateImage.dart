import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class TranslateImage extends StatefulWidget {
  const TranslateImage({super.key});

  @override
  _TranslateImageState createState() => _TranslateImageState();
}

class _TranslateImageState extends State<TranslateImage>
    with WidgetsBindingObserver {
  double _currentZoom = 1.0;
  CameraController? _controller;

  Future<void>? _initializeControllerFuture;
  XFile? _imageFile;
  bool _isUploading = false;
  List<dynamic>? _detectionResult;
  ui.Image? _displayImage;
  bool _cameraActive = true;

  final String _apiUrl =
      'https://saran-2021-api-gateway.hf.space/api/kitlang/live_detect';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _pauseCamera() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        await _controller!.pausePreview();
      } catch (e) {
        print("Error pausing camera: $e");
      }
    }
  }

  Future<void> _resumeCamera() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        await _controller!.resumePreview();
        _cameraActive = true;
      } catch (e) {
        print("Error resuming camera: $e");
        _initializeCamera(); // Re-initialize if resuming fails
      }
    } else if (_imageFile == null) {
      _initializeCamera();
      _cameraActive = true;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _pauseCamera();
      _cameraActive = false;
    } else if (state == AppLifecycleState.resumed &&
        !_cameraActive &&
        _imageFile == null) {
      _resumeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      print("No cameras available.");
      return;
    }
    final firstCamera = cameras.first;
    // Select the front camera instead of the first one
    // final frontCamera = cameras.firstWhere(
    //   (camera) => camera.lensDirection == CameraLensDirection.front,
    //   orElse:
    //       () => cameras.first, // fallback to first camera if no front camera
    // );

    _controller = CameraController(firstCamera, ResolutionPreset.medium);

    _initializeControllerFuture = _controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("User has denied camera access.");
            break;
          default:
            print('Error: ${e.code}\nError: ${e.description}');
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pauseCamera(); // Pause before disposing
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      setState(() {
        _imageFile = image;
        _detectionResult = null;
        _displayImage = null;
        _cameraActive = false;
        _pauseCamera(); // Pause after taking picture
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _uploadImageAndDetect() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please take a picture first.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _detectionResult = null;
      _displayImage = null;
    });

    try {
      var request = http.MultipartRequest('POST', Uri.parse(_apiUrl));
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // This is the field name your backend expects for the file
          _imageFile!.path,
        ),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print('Response Body: $responseBody');

      if (response.statusCode == 200) {
        print('Image uploaded successfully!');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Detection successful!')));
        final decodedResponse =
            jsonDecode(responseBody) as Map<String, dynamic>; // Cast to Map
        setState(() {
          _isUploading = false;
// Access 'final_boxes' through 'object_data'
          _detectionResult = (decodedResponse['object_data']
              as Map<String, dynamic>?)?['final_boxes'] as List<dynamic>?;
          _loadImageForDrawing();
        });
        print('Detection Result: $_detectionResult');
      } else {
        print(
          'Failed to upload image or detect. Status code: ${response.statusCode}',
        );
        print('Response body: $responseBody');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to detect objects.')),
        );
        setState(() {
          _isUploading = false;
        });
      }
    } catch (error) {
      print('Error uploading image: $error');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error during detection.')));
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _loadImageForDrawing() async {
    if (_imageFile != null) {
      final bytes = await File(_imageFile!.path).readAsBytes();
      final image = await decodeImageFromList(bytes);
      setState(() {
        _displayImage = image;
      });
    }
  }

  Widget _buildImageWithDetections() {
    if (_displayImage == null || _detectionResult == null) {
      if (_imageFile != null) {
        return Image.file(File(_imageFile!.path)); // No padding or container
      }
      return const SizedBox.shrink();
    }

    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: _displayImage!.width.toDouble(),
        height: _displayImage!.height.toDouble(),
        child: CustomPaint(
          painter: _DetectionPainter(
            image: _displayImage!,
            detections: _detectionResult!,
          ),
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: CameraPreview(_controller!),
    );
  }

  List<double> zoomLevels = [1.0, 2.0, 3.0]; // default fallback

  //check supported zoom by device
  void _fetchZoomLevels() async {
    final min = await _controller?.getMinZoomLevel() ?? 1.0;
    final max = await _controller?.getMaxZoomLevel() ?? 3.0;

    setState(() {
      zoomLevels = {
        min,
        1.0,
        2.0,
        max,
      }.where((z) => z >= min && z <= max).toList()
        ..sort();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Allow body to go behind the AppBar
      // appBar: AppBar(
      //   title: const Text('Take Picture and Detect'),
      //   backgroundColor: const ui.Color.fromARGB(120, 0, 0, 0).withOpacity(0.3), // Translucent effect
      //   elevation: 0, // No shadow
      // ),
      body: Stack(
        children: [
          Column(
            children: [
              // Custom glass-like container at the top (replaces the AppBar)
              Container(
                padding: const EdgeInsets.only(top: 50, bottom: 10),
                height: 140, // Adjust the height of the top container
                decoration: BoxDecoration(
                  color: _imageFile != null
                      ? const ui.Color.fromARGB(255, 77, 77, 77)
                      : const ui.Color.fromARGB(141, 0, 0, 0).withOpacity(0.60),
                  // Translucent effect
                  // borderRadius: BorderRadius.only(
                  //   bottomLeft: Radius.circular(20),
                  //   bottomRight: Radius.circular(20),
                  // ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Add your first container with text here
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: const ui.Color.fromARGB(
                          108,
                          37,
                          37,
                          37,
                        ).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const ui.Color.fromARGB(
                              255,
                              60,
                              60,
                              60,
                            ).withOpacity(0.2),
                            offset: const Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Text(
                        'German',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Icon-size image between containers
                    Image.asset(
                      'assets/translateImage/icons/arrow.png', // Replace with your asset path
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 10),
                    // Add your second container with text here
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: const ui.Color.fromARGB(
                          108,
                          37,
                          37,
                          37,
                        ).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const ui.Color.fromARGB(
                              255,
                              60,
                              60,
                              60,
                            ).withOpacity(0.2),
                            offset: const Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Text(
                        'English',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _imageFile == null
                    ? _buildCameraPreview()
                    : _buildImageWithDetections(),
              ),
              if (_detectionResult != null && _displayImage == null)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detection Result (Coordinates):',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        for (var detection in _detectionResult!)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Original Text: ${detection['original_text'] ?? 'N/A'}, Translated Text: ${detection['translated_text'] ?? 'N/A'}, Box: ${detection['box_2d']?.toString() ?? 'N/A'}',
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          //zoom
          if (_imageFile == null)
            Positioned(
              bottom: 170,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const ui.Color.fromARGB(
                      47,
                      177,
                      177,
                      177,
                    ).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: zoomLevels.map((double zoom) {
                      final bool isSelected = _currentZoom == zoom;
                      final String zoomText = zoom % 1 == 0
                          ? zoom.toInt().toString()
                          : zoom.toString();

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () async {
                            try {
                              await _controller?.setZoomLevel(zoom);
                              setState(() => _currentZoom = zoom);
                            } catch (e) {
                              print("Zoom level $zoom x not supported: $e");
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(
                              horizontal: isSelected ? 16 : 14,
                              vertical: isSelected ? 15 : 9,
                            ),
                            decoration: BoxDecoration(
                              color: const ui.Color.fromARGB(
                                148,
                                25,
                                25,
                                25,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              isSelected ? '$zoomText x' : zoomText,
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.yellow : Colors.white,
                                fontSize: isSelected ? 17 : 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

          // 👇 Glass-like bottom bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              // borderRadius: const BorderRadius.only(
              //   topLeft: Radius.circular(10),
              //   topRight: Radius.circular(10),
              // ),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 40,
                  ),
                  decoration: BoxDecoration(
                    color: _imageFile != null
                        ? const ui.Color.fromARGB(255, 77, 77, 77)
                        : const ui.Color.fromARGB(
                            141,
                            0,
                            0,
                            0,
                          ).withOpacity(0.60), // Glass effect
                    // borderRadius: const BorderRadius.only(
                    //   topLeft: Radius.circular(8),
                    //   topRight: Radius.circular(8),
                    // ),
                    // border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (_imageFile != null)
                        ElevatedButton(
                          onPressed:
                              _isUploading ? null : _uploadImageAndDetect,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(14),
                            backgroundColor: const ui.Color.fromARGB(
                              255,
                              1,
                              1,
                              1,
                            ).withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.center_focus_strong,
                            color: Colors.white,
                            size: 28,
                          ),
                        )
                      else
                        const SizedBox(width: 1), // Spacer
                      // Album Button (Left)
                      if (_imageFile == null)
                        GestureDetector(
                          // onTap: _pickImageFromGallery, // add your method
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.photo,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Album',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Middle Button (Center)
                      if (_imageFile == null)
                        GestureDetector(
                          onTap: _isUploading || _imageFile != null
                              ? null
                              : _takePicture,
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              'assets/translateImage/icons/middle_button.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      if (_imageFile != null)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _imageFile = null;
                              _detectionResult = null;
                              _displayImage = null;
                              _cameraActive = true;
                              _resumeCamera(); // Resume camera
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(14),
                            backgroundColor: const ui.Color.fromARGB(
                              255,
                              1,
                              1,
                              1,
                            ).withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 28,
                          ),
                        )
                      else
                        const SizedBox(width: 90),
                      // Placeholder (Right side for spacing or future button)
                      // const SizedBox(
                      //   width: 50, // adjust as needed
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetectionPainter extends CustomPainter {
  final ui.Image image;
  final List<dynamic> detections;

  _DetectionPainter({required this.image, required this.detections});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());

    final boxPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = const ui.Color.fromARGB(0, 55, 55, 55);
    // ..color = const ui.Color.fromARGB(
    //   255,
    //   54,
    //   244,
    //   70,
    // ); // You can customize the box color

    final textPainter = TextPainter(
      textAlign: TextAlign.left,
      textDirection: ui.TextDirection.ltr,
    );

    for (var detection in detections) {
      final box = detection['box_2d'];
      final translatedText = detection['translated_text'] as String?;

      print('Detection: $detection');

      if (box != null && box is List && box.length == 4) {
        final x1 = box[0].toDouble();
        final y1 = box[1].toDouble();
        final x2 = box[2].toDouble();
        final y2 = box[3].toDouble();

        // Scale the coordinates to the displayed image size
        double scaleX = size.width / image.width;
        double scaleY = size.height / image.height;

        final scaledX1 = x1 * scaleX;
        final scaledY1 = y1 * scaleY;
        final scaledX2 = x2 * scaleX;
        final scaledY2 = y2 * scaleY;

        final rect = Rect.fromPoints(
          Offset(scaledX1, scaledY1),
          Offset(scaledX2, scaledY2),
        );

        canvas.drawRect(rect, boxPaint);

        if (translatedText != null) {
          textPainter.text = TextSpan(
            text: translatedText,
            style: const TextStyle(
              color: ui.Color.fromARGB(255, 0, 0, 0),
              backgroundColor: ui.Color.fromARGB(255, 54, 244, 181),
              fontSize: 16,
            ),
          );
          textPainter.layout();

          // Position the label inside the top-left corner of the box
          final textX = scaledX1 + 5;
          final textY = scaledY1 + 5;

          // Ensure the text doesn't go out of bounds (vertically)
          if (textY + textPainter.height < scaledY2) {
            textPainter.paint(canvas, Offset(textX, textY));
          } else if (scaledY2 - textPainter.height > scaledY1) {
            // If it doesn't fit at the top, try placing it at the bottom
            textPainter.paint(
              canvas,
              Offset(textX, scaledY2 - textPainter.height - 5),
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(_DetectionPainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.detections != detections;
  }
}
