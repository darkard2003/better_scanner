import 'package:better_scanner/models/qr_record_model.dart';

class WifiCred extends QrRecordModel {
  late String ssid;
  late String password;

  WifiCred({
    required super.id,
    required super.name,
    required super.data,
    required super.type,
    required super.createdAt,
  }) {
    var parts = data.split(';');
    for (var part in parts) {
      if (part.startsWith('S:')) {
        ssid = part.split(':')[1];
      } else if (part.startsWith('P:')) {
        password = part.split(':')[1];
      }
    }
  }

  @override
  String get displayName => name.isEmpty ? ssid : name;

  @override
  String get displayData => ssid;

  @override
  String get copyData => password;

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

class Url extends QrRecordModel {
  late Uri url;

  Url({
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
