import 'package:better_scanner/models/model_error.dart';
import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/wifi_security.dart';

class WifiCredQr extends QrRecordModel {
  String ssid = '';
  String password = '';
  WifiSecurity security = WifiSecurity.wpa;
  bool hidden = false;

  WifiCredQr({
    required super.id,
    required super.name,
    required super.data,
    required super.type,
    required super.createdAt,
  }) {
    var split = data.split('WIFI:');
    if (split.length != 2) return;
    try {
      var parts = parseWifiQrString(data);
      ssid = parts.$1;
      password = parts.$2;
      security = parts.$3;
      hidden = parts.$4;
    } catch (e) {
      throw ModelPageError("Invalid wifi qr data");
    }
  }

  @override
  String get displayName => name.isEmpty ? ssid : name;

  @override
  String get displayData => ssid;

  @override
  String get copyData => password;

  static String getWifiQrString(
    String ssid,
    String password, {
    WifiSecurity security = WifiSecurity.wpa,
    bool hidden = false,
  }) {
    return "WIFI:T:${security.name};S:$ssid;P:$password;H:${hidden ? 'true' : ''};;";
  }

  static (String, String, WifiSecurity, bool) parseWifiQrString(String data) {
    if (!data.startsWith('WIFI:')) throw ModelPageError("Invalid wifi qr data");
    var raw = data.split('WIFI:')[1];
    var parts = raw.split(';');
    var ssid = '';
    var password = '';
    var security = WifiSecurity.none;
    var hidden = false;
    for (var part in parts) {
      if (part.startsWith('S:')) {
        ssid = part.split(':')[1];
      } else if (part.startsWith('P:')) {
        password = part.split(':')[1];
      } else if (part.startsWith('T:')) {
        var securityString = part.split(':').last;
        switch (securityString.toUpperCase()) {
          case 'wep':
            security = WifiSecurity.wep;
            break;
          case 'wpa':
            security = WifiSecurity.wpa;
            break;
          case 'nopass':
            security = WifiSecurity.none;
            break;
          default:
            security = WifiSecurity.none;
            break;
        }
      } else if (part.startsWith('H:')) {
        hidden = part.split(':').last.toLowerCase() == 'true';
      }
    }
    return (ssid, password, security, hidden);
  }
}

class GeoLocationQr extends QrRecordModel {
  late double? latitude;
  late double? longitude;

  GeoLocationQr({
    required super.id,
    required super.name,
    required super.data,
    required super.type,
    required super.createdAt,
  }) {
    var parsed = parseGeoQrString(data);
    latitude = parsed.$1;
    longitude = parsed.$2;
  }

  String get latStr => latitude?.toString() ?? "";
  String get lonStr => longitude?.toString() ?? "";

  @override
  String get displayName => name.isEmpty ? 'Location' : name;

  @override
  String get displayData => '${latitude ?? ""},${longitude ?? ""}';

  @override
  String get copyData => '${latitude ?? ""},${longitude ?? ""}';

  @override
  bool get canOpen => (latitude != null && longitude != null);

  static String getGeoQrString(double latitude, double longitude) {
    return 'geo:$latitude,$longitude';
  }

  static (double, double) parseGeoQrString(String data) {
    if (!data.startsWith('geo:')) throw ModelPageError("Invalid geo qr data");
    var parts = data.split(':');
    if (parts.length != 2) return (0, 0);
    var cords = parts[1].split(',');
    if (cords.length != 2) return (0, 0);
    var lat = double.tryParse(cords[0]);
    var lon = double.tryParse(cords[1]);
    return (lat ?? 0, lon ?? 0);
  }

  String toGoogleMapsUrl() {
    return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  }
}

class UrlQrModel extends QrRecordModel {
  late Uri url;

  UrlQrModel({
    required super.id,
    required super.name,
    required super.data,
    required super.type,
    required super.createdAt,
  }) {
    url = parseUri(data);
  }

  @override
  String get displayName => name.isEmpty ? domain : name;

  @override
  String get copyData => data;

  @override
  bool get canOpen => true;

  Uri parseUri(String data) {
    var uri = Uri.parse(data);
    if (uri.scheme.isEmpty) {
      var hostnamePattern =
          RegExp(r'^(www\.)?([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}$');
      if (hostnamePattern.hasMatch(data)) {
        uri = Uri.parse('https://$data');
      }
    }
    return uri;
  }

  String get domain {
    var uri = parseUri(data);
    var host = uri.host;
    var domainPattern = RegExp(r'([a-z0-9|-]+)\.([a-z]{2,})$');
    var match = domainPattern.firstMatch(host);
    if (match != null && match.groupCount >= 1) {
      host = match.group(1)!;
    }
    return host;
  }
}

class PhoneQr extends QrRecordModel {
  late String number;

  PhoneQr({
    required super.id,
    required super.name,
    required super.data,
    required super.type,
    required super.createdAt,
  }) {
    number = parsePhoneQrString(data);
  }

  @override
  String get displayName => name.isEmpty ? 'Phone' : name;

  @override
  String get displayData => number;

  @override
  String get copyData => number;

  static String getPhoneQrString(String number) {
    return 'tel:$number';
  }

  static String parsePhoneQrString(String data) {
    if (!data.startsWith('tel:')) throw ModelPageError("Invalid phone qr data");
    return data.split(':')[1];
  }
}

class SMSQr extends QrRecordModel {
  late String number;
  late String message;

  SMSQr({
    required super.id,
    required super.name,
    required super.data,
    required super.type,
    required super.createdAt,
  }) {
    var parts = parseSmsQrString(data);
    number = parts.$1;
    message = parts.$2;
  }

  @override
  String get displayName => name.isEmpty ? 'SMS' : name;

  @override
  String get displayData => '$number:$message';

  @override
  String get copyData => '$number\n$message';

  static String getSmsQrString(String number, String message) {
    return 'SMSTO:$number:$message';
  }

  static (String, String) parseSmsQrString(String data) {
    if (!data.startsWith('SMSTO:')) throw ModelPageError("Invalid sms qr data");
    var parts = data.split(':');
    if (parts.length != 3) return ('', '');
    return (parts[1], parts[2]);
  }
}

class Email extends QrRecordModel {
  late String address;
  late String subject;
  late String body;

  Email({
    required super.id,
    required super.name,
    required super.data,
    required super.type,
    required super.createdAt,
  }) {
    var parts = data.replaceAll('MATMSG:', '').split(';');
    address = parts[0].split(':')[1];
    subject = parts[1].split(':')[1];
    body = parts[2].split(':')[1];
  }

  @override
  String get displayName => name.isEmpty ? 'Email' : name;

  @override
  String get displayData => '$address:$subject:$body';

  @override
  String get copyData => '$address\n$subject\n$body';
}

class VCard extends QrRecordModel {
  final Map<String, String> _fields = {
    'FN': 'Name',
    'ORG': 'Organization',
    'TITLE': 'Title',
    'TEL': 'Phone',
    'EMAIL': 'Email',
    'URL': 'Website',
    'ADR': 'Address',
    'NOTE': 'Note',
  };

  VCard({
    required super.id,
    required super.name,
    required super.data,
    required super.type,
    required super.createdAt,
  }) {
    var lines = data.split('\n');
    for (var line in lines) {
      var parts = line.split(':');
      var key = parts[0].split(';')[0];
      var value = parts[1];
      if (_fields.containsKey(key)) {
        _fields[key] = value;
      }
    }
  }

  String get cname => _fields['FN'] ?? 'No Name';
  String get phone => _fields['TEL'] ?? 'No Phone';
  String get email => _fields['EMAIL'] ?? 'No Email';

  @override
  String get displayName => name.isEmpty ? cname : name;

  @override
  String get displayData => '$cname:$phone:$email';

  @override
  String get copyData => '$cname\n$phone\n$email';
}

class Calendar extends QrRecordModel {
  final Map<String, String> _fields = {
    'SUMMARY': 'Event',
    'LOCATION': 'Location',
    'DESCRIPTION': 'Description',
    'DTSTART': 'Start',
    'DTEND': 'End',
  };

  Calendar({
    required super.id,
    required super.name,
    required super.data,
    required super.type,
    required super.createdAt,
  }) {
    var lines = data.split('\n');
    for (var line in lines) {
      var parts = line.split(':');
      var key = parts[0];
      var value = parts[1];
      if (_fields.containsKey(key)) {
        _fields[key] = value;
      }
    }
  }

  String get event => _fields['SUMMARY'] ?? 'No Event';
  String get location => _fields['LOCATION'] ?? 'No Location';
  String get description => _fields['DESCRIPTION'] ?? 'No Description';
  DateTime get start => DateTime.parse(_fields['DTSTART'] ?? 'No Start');
  DateTime get end => DateTime.parse(_fields['DTEND'] ?? 'No End');

  @override
  String get displayName => name.isEmpty ? event : name;

  @override
  String get displayData => '$event:$location:$description:$start:$end';

  @override
  String get copyData => '$event\n$location\n$description\n$start\n$end';
}

class Event extends QrRecordModel {
  final Map<String, String> _fields = {
    'SUMMARY': 'Event',
    'LOCATION': 'Location',
    'DESCRIPTION': 'Description',
    'DTSTART': 'Start',
    'DTEND': 'End',
  };

  Event({
    required super.id,
    required super.name,
    required super.data,
    required super.type,
    required super.createdAt,
  }) {
    var lines = data.split('\n');
    for (var line in lines) {
      var parts = line.split(':');
      var key = parts[0];
      var value = parts[1];
      if (_fields.containsKey(key)) {
        _fields[key] = value;
      }
    }
  }

  String get event => _fields['SUMMARY'] ?? 'No Event';
  String get location => _fields['LOCATION'] ?? 'No Location';
  String get description => _fields['DESCRIPTION'] ?? 'No Description';
  DateTime get start => DateTime.parse(_fields['DTSTART'] ?? 'No Start');
  DateTime get end => DateTime.parse(_fields['DTEND'] ?? 'No End');

  @override
  String get displayName => name.isEmpty ? event : name;

  @override
  String get displayData => '$event:$location:$description:$start:$end';

  @override
  String get copyData => '$event\n$location\n$description\n$start\n$end';
}
