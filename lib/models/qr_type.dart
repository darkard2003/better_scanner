enum QrType {
  unknown,
  text,
  url,
  wifi,
}

extension QrExtention on QrType {
  String get name {
    switch (this) {
      case QrType.unknown:
        return 'Unknown';
      case QrType.text:
        return 'Text';
      case QrType.url:
        return 'URL';
      case QrType.wifi:
        return 'WiFi';
    }
  }
}
