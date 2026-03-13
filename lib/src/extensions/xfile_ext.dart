import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:image_picker/image_picker.dart';

extension XFileToBase64 on XFile {
  Future<String> toBase64() async {
    try {
      // Read the file as bytes
      List<int> fileBytes = await readAsBytes();

      // Convert bytes to base64
      String base64String = base64Encode(fileBytes);

      return base64String;
    } catch (e) {
      debugPrint('Error converting XFile to base64: $e');
      rethrow;
    }
  }

  Future<String> toBase64WithMimeType() async {
    try {
      // Read the file as bytes
      List<int> fileBytes = await readAsBytes();

      // Convert bytes to base64
      String base64String = base64Encode(fileBytes);

      // Get the MIME type
      String mimeType = 'application/octet-stream';

      // Combine MIME type and base64 string
      return 'data:$mimeType;base64,$base64String';
    } catch (e) {
      debugPrint('Error converting XFile to base64 with MIME type: $e');
      rethrow;
    }
  }
}
