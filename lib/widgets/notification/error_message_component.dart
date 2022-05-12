import 'package:flutter/material.dart';

class ErrorMessageComponent extends StatefulWidget {

  final String title;
  final String message;
  final int errorType;

  const ErrorMessageComponent({Key? key,required this.title, required this.message, required this.errorType}) : super(key: key);

  @override
  _ErrorMessageComponentState createState() => _ErrorMessageComponentState();
}

class _ErrorMessageComponentState extends State<ErrorMessageComponent> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
              (widget.errorType == 1) ?  Icons.error :  Icons.warning,
            size: 150,
            color: (widget.errorType == 1) ? const Color.fromRGBO(183,28,28, 1) : Colors.amber,
          ),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
