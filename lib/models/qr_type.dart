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

  String get defaultQrValue {
    switch (this) {
      case QrType.unknown:
        return '';
      case QrType.text:
        return '';
      case QrType.url:
        return 'https://';
      case QrType.wifi:
        return 'WIFI:S:';
      case QrType.geo:
        return 'geo:0,0';
      case QrType.phone:
        return 'tel:';
      case QrType.sms:
        return "SMSTO:";
      case QrType.email:
        return 'MATMSG:';
      case QrType.contact:
        return 'MECARD:';
      case QrType.calendar:
        return 'BEGIN:VEVENT\nEND:VEVENT\n';
      case QrType.event:
        return 'BEGIN:VEVENT\nEND:VEVENT\n';
    }
  }
}
