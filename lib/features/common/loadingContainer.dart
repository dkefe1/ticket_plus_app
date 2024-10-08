import 'package:flutter/material.dart';
import 'package:ticketing_app/core/constants.dart';

class LoadingContainer extends StatefulWidget {
  final double width, height, borderRadius;
  LoadingContainer(
      {super.key,
      required this.width,
      required this.height,
      required this.borderRadius});

  @override
  State<LoadingContainer> createState() => _LoadingContainerState();
}

class _LoadingContainerState extends State<LoadingContainer>
    with TickerProviderStateMixin {
  late AnimationController colorAnimationController;
  late Animation containerAnimationColor;

  @override
  void initState() {
    colorAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    containerAnimationColor =
        ColorTween(begin: surfaceColor.withOpacity(0.4), end: surfaceColor)
            .animate(colorAnimationController)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              colorAnimationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              colorAnimationController.forward();
            }
          });
    colorAnimationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    colorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          color: containerAnimationColor.value,
          borderRadius: BorderRadius.circular(widget.borderRadius)),
    );
  }
}
