
import 'package:better_scanner/models/qr_type.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

extension QrTypeExtention on BarcodeType {
  QrType get qrType {
    switch (this) {
      case BarcodeType.text:
        return QrType.text;
      case BarcodeType.url:
        return QrType.url;
      case BarcodeType.wifi:
        return QrType.wifi;
      case BarcodeType.geo:
        return QrType.geo;
      case BarcodeType.phone:
        return QrType.phone;
      case BarcodeType.sms:
        return QrType.sms;
      case BarcodeType.email:
        return QrType.email;
      case BarcodeType.contactInfo:
        return QrType.contact;
      case BarcodeType.calendarEvent:
        return QrType.event;
      default:
        return QrType.unknown;
    }
  }
}
