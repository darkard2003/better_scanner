enum QrType {
  unknown,
  text,
  url,
  wifi,
  geo,
  phone,
  sms,
  email,
  contact,
  calendar,
  event,
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
      case QrType.geo:
        return 'Geo';
      case QrType.phone:
        return 'Telephone';
      case QrType.sms:
        return 'SMS';
      case QrType.email:
        return 'Email';
      case QrType.contact:
        return 'Contact';
      case QrType.calendar:
        return 'Calendar';
      case QrType.event:
        return 'Event';
    }
  }
}
