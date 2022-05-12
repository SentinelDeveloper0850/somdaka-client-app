import 'package:flutter/material.dart';

class BottomSheetModalComponent extends StatefulWidget {
  final String title;
  final String subtitle;
  final Widget modalData;
  final double modalHeight;

  const BottomSheetModalComponent(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.modalData,
      required this.modalHeight})
      : super(key: key);

  @override
  _BottomSheetModalComponentState createState() =>
      _BottomSheetModalComponentState();
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
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.subtitle,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              Divider(
                thickness: 2,
                indent: 16,
                endIndent: 16,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: widget.modalData,
              ))
            ],
          )),
    );
  }
}
