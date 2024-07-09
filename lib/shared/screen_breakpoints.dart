enum ScreenSize {
  small,
  medium,
  large,
  xlarge,
}

ScreenSize screenSizeFromSize(double width) {
  if (width < 600) {
    return ScreenSize.small;
  } else if (width < 1024) {
    return ScreenSize.medium;
  } else if (width < 1440) {
    return ScreenSize.large;
  } else {
    return ScreenSize.xlarge;
  }
}
