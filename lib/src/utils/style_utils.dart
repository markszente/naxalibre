import 'dart:io';

/// Utility class for handling cross-platform style-related operations.
class StyleUtils {
  /// Formats a style path to be compatible with both iOS and Android platforms.
  ///
  /// This method handles the platform-specific requirements for local file paths:
  /// - **iOS**: Requires absolute file paths WITHOUT `file://` prefix
  /// - **Android**: Requires file URIs WITH `file://` prefix
  /// - **Web URLs**: Passed through unchanged (work on both platforms)
  /// - **JSON strings**: Passed through unchanged (work on both platforms)
  ///
  /// **Parameters:**
  /// - [path]: The style path to format (can be URL, file path, or JSON)
  ///
  /// **Returns:** 
  /// A properly formatted path string for the current platform
  ///
  /// **Example:**
  /// ```dart
  /// // Input: "/path/to/style.json"
  /// // iOS output: "/path/to/style.json"  
  /// // Android output: "file:///path/to/style.json"
  ///
  /// // Input: "https://example.com/style.json"
  /// // Both platforms: "https://example.com/style.json"
  /// ```
  static String formatStylePath(String path) {
    // Return web URLs unchanged (work on both platforms)
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    
    // Return JSON strings unchanged (work on both platforms)
    // Simple heuristic: if it starts with '{' and contains '"version"', treat as JSON
    if (path.trim().startsWith('{') && path.contains('"version"')) {
      return path;
    }
    
    // Handle local file paths based on platform
    if (Platform.isIOS) {
      // iOS needs raw file path (remove file:// prefix if present)
      return path.startsWith('file://') ? path.substring(7) : path;
    } else if (Platform.isAndroid) {
      // Android needs file:// URI (add prefix if not present)
      return path.startsWith('file://') ? path : 'file://$path';
    }
    
    // For other platforms or fallback, return as-is
    return path;
  }
  
  /// Checks if the given string appears to be a JSON style string.
  ///
  /// This is a simple heuristic that checks if the string starts with '{'
  /// and contains common MapLibre style properties.
  ///
  /// **Parameters:**
  /// - [content]: The string to check
  ///
  /// **Returns:** 
  /// `true` if the content appears to be JSON, `false` otherwise
  static bool isJsonString(String content) {
    final trimmed = content.trim();
    return trimmed.startsWith('{') && 
           (trimmed.contains('"version"') || 
            trimmed.contains('"sources"') || 
            trimmed.contains('"layers"'));
  }
  
  /// Checks if the given string appears to be a web URL.
  ///
  /// **Parameters:**
  /// - [url]: The string to check
  ///
  /// **Returns:** 
  /// `true` if the string appears to be a web URL, `false` otherwise
  static bool isWebUrl(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }
  
  /// Checks if the given string appears to be a local file path.
  ///
  /// This checks for common file path patterns and excludes web URLs and JSON.
  ///
  /// **Parameters:**
  /// - [path]: The string to check
  ///
  /// **Returns:** 
  /// `true` if the string appears to be a local file path, `false` otherwise
  static bool isLocalFilePath(String path) {
    // Not a web URL and not JSON
    if (isWebUrl(path) || isJsonString(path)) {
      return false;
    }
    
    // Check for common file path patterns
    return path.startsWith('/') ||           // Unix absolute path
           path.startsWith('file://') ||     // File URI
           path.contains(':/') ||            // Windows drive or other schemes
           path.endsWith('.json') ||         // JSON file extension
           File(path.startsWith('file://') ? path.substring(7) : path).existsSync();
  }
}
