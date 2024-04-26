import 'package:flutter/material.dart';

class LoaderWidget extends StatefulWidget {
  // if function is provided, call it in build
  // when function finished, set loading false and update the widget
  final Future Function() loadFunc;

  // this function should return the child widget
  // it is not the child widget itself but
  // a function because it can be that the child widget
  // has to wait for values of the load function
  // it is called when the load function is done
  final Widget Function() childFunc;

  const LoaderWidget({
    super.key,
    required this.childFunc,
    required this.loadFunc,
  });

  @override
  State<LoaderWidget> createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget> {
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    // if the widget is not loaded yet
    if (!_loaded) {
      // call the future
      // after it is done, set loaded to true
      widget.loadFunc().then((value) {
        // call the future
        setState(() {
          _loaded = true;
        });
      });
    }

    // return the child widget if loaded, else return a loading indicator
    return _loaded
        ? widget.childFunc()
        : const Center(child: CircularProgressIndicator());
  }
}
