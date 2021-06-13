import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final String image;
  final double borderRadius;
  final double elevation;
  final Function onTap;

  CustomCard({this.image, this.borderRadius,@required this.onTap, this.elevation: 0});

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      //margin: const EdgeInsets.all(10.0),
      elevation: widget.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius)
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: widget.image != null? NetworkImage(widget.image): AssetImage('assets/events/place_holder.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.black.withOpacity(0.6),
            onTap: widget.onTap,
          ),
        ),
      ),
    );
  }
}