import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/models/wifi_security.dart';
import 'package:uuid/uuid.dart';

class WifiCred extends QrRecordModel {
  late String ssid;
  late String password;
  late WifiSecurity security;
  late bool hidden;

  WifiCred({
    required super.id,
    required super.name,
    required super.data,
    required super.type,
    required super.createdAt,
  }) {
    var raw = data.split('WIFI:')[1];
    var parts = raw.split(';');
    var securityString = "";
    for (var part in parts) {
      if (part.startsWith('S:')) {
        ssid = part.split(':')[1];
      } else if (part.startsWith('P:')) {
        password = part.split(':')[1];
      } else if (part.startsWith('T:')) {
        securityString = part.split(':').last;
      } else if (part.startsWith('H:')) {
        hidden = part.split(':').last.toLowerCase() == 'true';
      }
    }
    switch (securityString.toUpperCase()) {
      case 'wep':
        security = WifiSecurity.WEP;
        break;
      case 'wpa':
        security = WifiSecurity.WPA;
        break;
      case 'nopass':
        security = WifiSecurity.None;
        break;
      default:
        security = WifiSecurity.None;
        break;
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
    WifiSecurity security = WifiSecurity.WPA,
    bool hidden = false,
  }) {
    return "WIFI:T:${security.name};S:$ssid;P:$password;H:${hidden ? 'true' : ''};;";
  }
}

class GeoLocation extends QrRecordModel {
  late double latitude;
  late double longitude;

  GeoLocation({
    required super.id,
    required super.name,
    required super.data,
    required super.type,
    required super.createdAt,
  }) {
    var coords = data.split(':')[1].split(',');
    latitude = double.parse(coords[0]);
    longitude = double.parse(coords[1]);
  }

  @override
  String get displayName => name.isEmpty ? 'Location' : name;

  @override
  String get displayData => '$latitude,$longitude';

  @override
  String get copyData => '$latitude,$longitude';
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

class Phone extends QrRecordModel {
  late String number;

  Phone({
    required super.id,
    required super.name,
    required super.data,
    required super.type,
    required super.createdAt,
  }) {
    number = data.split(':')[1];
  }

  @override
  String get displayName => name.isEmpty ? 'Phone' : name;

  @override
  String get displayData => number;

  @override
  String get copyData => number;
}

class Sms extends QrRecordModel {
  late String number;
  late String message;

  Sms({
    required super.id,
    required super.name,
    required super.data,
    required super.type,
    required super.createdAt,
  }) {
    var parts = data.split(':');
    number = parts[1];
    message = parts[2];
  }

  @override
  String get displayName => name.isEmpty ? 'SMS' : name;

  @override
  String get displayData => '$number:$message';

  @override
  String get copyData => '$number\n$message';
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
