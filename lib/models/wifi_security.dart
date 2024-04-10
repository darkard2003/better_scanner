enum WifiSecurity {
  wpa,
  wep,
  none,
}

extension WifiSecurityExtension on WifiSecurity {
  String get value {
    switch (this) {
      case WifiSecurity.wpa:
        return 'WPA/WPA2';
      case WifiSecurity.wep:
        return 'WEP';
      case WifiSecurity.none:
        return '';
    }
  }

  static WifiSecurity fromString(String value) {
    switch (value) {
      case 'WPA/WPA2':
        return WifiSecurity.wpa;
      case 'WEP':
        return WifiSecurity.wep;
      default:
        return WifiSecurity.none;
    }
  }
}
