import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';
import 'result.dart';

// Entry point of the application
void main() {
  runApp(const MyApp());
}

// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp is the top-level widget that holds the app's configuration
    return MaterialApp(
      title: 'QR Scanner',
      debugShowCheckedModeBanner: false, // Disables the debug banner
      home: QRScanner(), // Sets QRScanner as the home widget
    );
  }
}

// Stateful widget to handle QR scanner functionality
class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

// State class for QRScanner
class _QRScannerState extends State<QRScanner> {
  bool isFlashOn = false; // To track if flash is on or off
  bool isFrontCamera = false; // To track if front camera is used
  bool isScanCompleted = false; // To track if scan is completed
  MobileScannerController cameraController = MobileScannerController(); // Controller for the scanner

  // Function to reset scan completion status
  void closeScreen() {
    isScanCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the structure for the app screen
    return Scaffold(
      backgroundColor: Color(0xFFf5f2e8), // Background color of the screen
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0, // Removes AppBar shadow
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.qr_code_scanner, color: Colors.black), // QR scanner icon
        ),
        actions: [
          // Flash toggle button
          IconButton(
            onPressed: () {
              setState(() {
                isFlashOn = !isFlashOn;
              });
              cameraController.toggleTorch(); // Toggles the flashlight
            },
            icon: Icon(
              Icons.flash_on,
              color: isFlashOn ? Colors.white : Colors.black, // Changes icon color based on flash status
            ),
          ),
          // Camera switch button
          IconButton(
            onPressed: () {
              setState(() {
                isFrontCamera = !isFrontCamera;
              });
              cameraController.switchCamera(); // Switches the camera
            },
            icon: Icon(
              Icons.flip_camera_android,
              color: isFrontCamera ? Colors.white : Colors.black, // Changes icon color based on camera status
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity, // Takes full width of the screen
        padding: EdgeInsets.all(10), // Padding around the container
        child: Column(
          children: [
            // Display the app logo
            Image.asset(
              'assets/logo.png',
              height: 150,
            ),
            Expanded(
              flex: 2, // Takes twice the space of other Expanded widgets
              child: Stack(
                children: [
                  // QR code scanner
                  MobileScanner(
                    controller: cameraController,
                    allowDuplicates: true, // Allows duplicate scan results
                    onDetect: (barcode, args) {
                      if (!isScanCompleted) {
                        isScanCompleted = true;
                        String code = barcode.rawValue ?? "---"; // Gets the scanned QR code value
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return QRResult(
                                code: code,
                                closeScreen: closeScreen,
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                  // Overlay for QR scanner
                  QRScannerOverlay(
                    overlayColor: Color(0xFFf5f2e8),
                    borderColor: Color(0xff3d3d3e),
                    borderRadius: 20,
                    borderStrokeWidth: 7,
                    scanAreaWidth: 250,
                    scanAreaHeight: 250,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10), // Space between scanner and text
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centers the text vertically
                children: [
                  // Instruction text
                  Text(
                    "Scannen Sie den QR-Code",
                    textAlign: TextAlign.center, // Center align the text
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Sub-instruction text
                  Text(
                    "Let the scan do the magic - It starts on its own!",
                    textAlign: TextAlign.center, // Center align the text
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
