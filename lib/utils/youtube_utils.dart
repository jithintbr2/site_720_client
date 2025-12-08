// bool isYoutubeLink(String url) {
//   return url.contains('youtube.com') || url.contains('youtu.be');
// }

// String extractYoutubeVideoId(String url) {
//   final uri = Uri.tryParse(url);
//   if (uri == null) return "";
//   if (uri.host.contains("youtube.com") && uri.path.contains("/embed/")) {
//     return uri.pathSegments.last;
//   } else if (uri.host.contains("youtu.be")) {
//     return uri.pathSegments.first;
//   }
//   return "";
// }
bool isYoutubeLink(String url) {
  return url.contains('youtube.com') || url.contains('youtu.be');
}

String extractYoutubeVideoId(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return "";
  if (uri.host.contains("youtube.com")) {
    if (uri.queryParameters.containsKey("v")) {
      return uri.queryParameters["v"] ?? "";
    }
    if (uri.path.contains("/embed/")) {
      return uri.pathSegments.last;
    }
  }
  if (uri.host.contains("youtu.be")) {
    return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : "";
  }

  return "";
}

