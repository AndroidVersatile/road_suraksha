import 'package:flutter/material.dart';

class OnboardCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final firstCurve = Offset(200, size.height -100);
    final lastCurve = Offset(size.width, size.height);

    final secondFirstCurve = Offset(0, 0);
    final secondLastCurve = Offset(size.width - 30, size.height - 20);

    final thirdFirstCurve = Offset(size.width, size.height-100);
    final thirdLastCurve = Offset(size.width, size.height -100);
    path.lineTo(0, size.height);

    path.quadraticBezierTo(
        firstCurve.dx, firstCurve.dy, lastCurve.dx, lastCurve.dy);

    // path.quadraticBezierTo(secondFirstCurve.dx, secondFirstCurve.dy,
    //     secondLastCurve.dx, secondLastCurve.dy);

    // path.quadraticBezierTo(thirdFirstCurve.dx, thirdFirstCurve.dy,
    //     thirdLastCurve.dx, thirdLastCurve.dy);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class TicketCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(0, (size.height / 2) - 20);
    path.relativeArcToPoint(const Offset(0, 40),
        radius: const Radius.circular(
          2.0,
        ),
        largeArc: false);

    path.lineTo(0, size.height);

    path.lineTo(size.width, size.height);

    path.lineTo(size.width, (size.height / 2) + 20);
    path.relativeArcToPoint(const Offset(0, -40),
        radius: const Radius.circular(2.0), largeArc: false);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0.0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class ProfileCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(0, size.height);
    path.lineTo(((size.width) / 2) + 50, size.height);
    // path.relativeArcToPoint(const Offset(100, 30),
    //     radius: const Radius.circular(15.0), largeArc: false);
    path.lineTo(size.width / 2, 0);

    // path.lineTo(size.width, 0);
    path.lineTo(0, 0.0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
