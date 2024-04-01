enum WifiSecurity {
  WPA,
  WEP,
  None,
}

extension WifiSecurityExtension on WifiSecurity {
  String get value {
    switch (this) {
      case WifiSecurity.WPA:
        return 'WPA/WPA2';
      case WifiSecurity.WEP:
        return 'WEP';
      case WifiSecurity.None:
        return '';
    }
  }

  static WifiSecurity fromString(String value) {
    switch (value) {
      case 'WPA/WPA2':
        return WifiSecurity.WPA;
      case 'WEP':
        return WifiSecurity.WEP;
      default:
        return WifiSecurity.None;
    }
  }
}
