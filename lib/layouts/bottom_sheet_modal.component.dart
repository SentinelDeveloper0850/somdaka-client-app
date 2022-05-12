import 'package:flutter/material.dart';

class BottomSheetModalComponent extends StatefulWidget {

  final String title;
  final String subtitle;
  final Widget modalData;
  final double modalHeight;

  const BottomSheetModalComponent({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.modalData,
    required this.modalHeight
  }) : super(key: key);

  @override
  _BottomSheetModalComponentState createState() => _BottomSheetModalComponentState();
}

class _BottomSheetModalComponentState extends State<BottomSheetModalComponent> {


  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF737373),
      height: widget.modalHeight,
      child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
            ),
          ),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(
                    widget.subtitle
                ),
              ),
              const Divider(),
              Expanded(
                  child: widget.modalData
              )
            ],
          )
      ),
    );
  }
}
