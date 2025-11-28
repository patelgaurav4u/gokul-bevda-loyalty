// lib/utils/responsive.dart
import 'package:flutter/material.dart';

class Responsive {
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isSmallScreen(BuildContext context) {
    return screenWidth(context) < 360;
  }

  static bool isMediumScreen(BuildContext context) {
    return screenWidth(context) >= 360 && screenWidth(context) < 414;
  }

  static bool isLargeScreen(BuildContext context) {
    return screenWidth(context) >= 414;
  }

  // Responsive font sizes
  static double fontSize(BuildContext context, double baseSize) {
    final width = screenWidth(context);
    if (width < 360) {
      return baseSize * 0.9; // Small screens
    } else if (width > 414) {
      return baseSize * 1.1; // Large screens
    }
    return baseSize; // Default
  }

  // Responsive padding
  static double padding(BuildContext context, double basePadding) {
    final width = screenWidth(context);
    if (width < 360) {
      return basePadding * 0.85; // Small screens
    } else if (width > 414) {
      return basePadding * 1.15; // Large screens
    }
    return basePadding; // Default
  }

  // Responsive width percentage
  static double widthPercent(BuildContext context, double percent) {
    return screenWidth(context) * (percent / 100);
  }

  // Responsive height percentage
  static double heightPercent(BuildContext context, double percent) {
    return screenHeight(context) * (percent / 100);
  }

  // Responsive icon size
  static double iconSize(BuildContext context, double baseSize) {
    final width = screenWidth(context);
    if (width < 360) {
      return baseSize * 0.9;
    } else if (width > 414) {
      return baseSize * 1.1;
    }
    return baseSize;
  }

  // Responsive spacing
  static double spacing(BuildContext context, double baseSpacing) {
    final width = screenWidth(context);
    if (width < 360) {
      return baseSpacing * 0.85;
    } else if (width > 414) {
      return baseSpacing * 1.15;
    }
    return baseSpacing;
  }

  // Get responsive dialog width
  static double dialogWidth(BuildContext context) {
    final width = screenWidth(context);
    if (width < 360) {
      return width * 0.9;
    } else if (width > 600) {
      return 600;
    }
    return width * 0.85;
  }

  // Get responsive dialog max height
  static double dialogMaxHeight(BuildContext context) {
    final height = screenHeight(context);
    return height * 0.8;
  }
}

