import 'dart:convert';

String extractTextFromJson(String jsonString) {
  try {
    final decoded = jsonDecode(jsonString);
    if (decoded is Map && decoded.containsKey('text')) {
      return decoded['text'] as String;
    } else if (decoded is String) {
      return decoded;
    } else if (decoded is List) {
      // Handle top-level list (common for Quill Delta)
      return _tryExtractFromQuillDeltaList(decoded);
    }
    return _tryExtractFromQuillDeltaMap(decoded);
  } catch (e) {

    return jsonString;
  }
}

String _tryExtractFromQuillDeltaMap(dynamic decoded) {
  if (decoded is Map && decoded.containsKey('ops') && decoded['ops'] is List) {
    return _tryExtractFromQuillDeltaList(decoded['ops']);
  }
  return ''; // Return empty string if not a recognized format
}

String _tryExtractFromQuillDeltaList(List ops) {
  StringBuffer buffer = StringBuffer();
  for (var op in ops) {
    if (op is Map && op.containsKey('insert')) {
      final insertContent = op['insert'];
      if (insertContent is String) {
        buffer.write(insertContent);
      } else if (insertContent is Map && insertContent.containsKey('image')) {
        // Optionally handle images, e.g., by adding a placeholder
        buffer.write('[Image]');
      }
    }
  }
  return buffer.toString().trim();
}
