import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'main.dart';

// Stateless widget to display the result of the QR scan
class QRResult extends StatelessWidget {
  final String code; // The scanned QR code value
  final Function() closeScreen; // Function to reset scan completion status

  const QRResult({
    super.key,
    required this.code,
    required this.closeScreen
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar at the top of the screen
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent AppBar
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return QRScanner(); // Navigates back to the QR scanner screen
                },
              ),
            );
          },
          icon: Icon(Icons.arrow_back), // Back arrow icon
          color: Colors.black, // Icon color
        ),
        centerTitle: true, // Center the title in the AppBar
        title: Text(
          "Scanned Result",
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      // Main content of the screen
      body: Padding(
        padding: EdgeInsets.all(30), // Padding around the content
        child: Column(
          children: [
            SizedBox(
              height: 80, // Space between the AppBar and the QR image
            ),
            QrImageView(
              data: "", // Data to be encoded in the QR code (empty in this case)
              size: 300, // Size of the QR image
              version: QrVersions.auto, // Automatically determine the QR version
            ),
            // Title text for the QR image
            Text(
              "Scanned QR",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: 10, // Space between the title and the scanned code
            ),
            // Display the scanned QR code value
            Text(
              code,
              textAlign: TextAlign.center, // Center align the text
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20
              ),
            ),
            SizedBox(
              height: 20, // Space between the code and the button
            ),
            // Copy button to copy the scanned code to clipboard
            SizedBox(
              width: MediaQuery.of(context).size.width - 150, // Button width
              height: 60, // Button height
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade900 // Button color
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code)); // Copy code to clipboard
                  },
                  child: Text(
                    "Copy",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
