import 'package:http/http.dart' as http;

enum UrlType { image, video, audio, unknown }

class UrlTypeHelper {
  static Future<UrlType> getType(url) async {
    try {
      if(await isImageUrl(url)){
        return UrlType.image;
      }
      if(await isVideoUrl(url)){
        return UrlType.video;
      }
      if(await isAudioUrl(url)){
        return UrlType.audio;
      }
    } catch (e) {
      return UrlType.unknown;
    }
    return UrlType.unknown;
  }
}

Future<String> getContentType(String url) async {
  try {
    final response = await http.head(Uri.parse(url));
    return response.headers['content-type'] ?? '';
  } catch (e) {
    // print('Error: $e');
    return '';
  }
}

Future<bool> isImageUrl(String url) async {
  final contentType = await getContentType(url);
  return contentType.startsWith('image/');
}

Future<bool> isVideoUrl(String url) async {
  final contentType = await getContentType(url);
  return contentType.startsWith('video/');
}

Future<bool> isAudioUrl(String url) async {
  final contentType = await getContentType(url);
  return contentType.startsWith('audio/');
}