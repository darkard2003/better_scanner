import 'package:better_scanner/models/wifi_cred.dart';

class QRParser {
  static Uri parseUri(String data) {
    var uri = Uri.parse(data);
    if (uri.scheme.isEmpty) uri = Uri.parse('https://${uri.toString()}');
    return uri;
  }

  static WifiCred parseWifi(String data) {
    var ssid = RegExp(r'ssid:([^\n]+)').firstMatch(data)?.group(1) ?? '';
    var password = RegExp(r'psk:([^\n]+)').firstMatch(data)?.group(1) ?? '';
    return WifiCred(ssid: ssid, password: password);
  }

  static String getDomain(String data) {
    var uri = parseUri(data);
    var host = uri.host;
    var parts = host.split('.');
    if (parts.length > 1) {
      host = parts[parts.length - 2];
    }
    return host;
  }
}
