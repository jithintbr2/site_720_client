bool isYoutubeLink(String url) {
  return url.contains('youtube.com') || url.contains('youtu.be');
}

String extractYoutubeVideoId(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return "";
  if (uri.host.contains("youtube.com") && uri.path.contains("/embed/")) {
    return uri.pathSegments.last;
  } else if (uri.host.contains("youtu.be")) {
    return uri.pathSegments.first;
  }
  return "";
}
