import 'dart:isolate';
import 'dart:async';

import 'package:photofilters/filters/filters.dart';
import 'package:image/image.dart' as imageLib;

class IsolateWorker {
  Completer<List<int>> _filteredImage;
  SendPort _mainStreamToIsolateStream;
  ReceivePort _isolateToMainStream;
  Isolate _isolateInstance;

  final _isolateReady = Completer<bool>();

  Future<bool> get isReady => _isolateReady.future;

  IsolateWorker() {
    initIsolate();
  }

  void dispose() {
    _isolateInstance.kill(/*priority: Isolate.immediate*/);
  }

  initIsolate() async {
    //Listen for information going to main thread
    _isolateToMainStream = ReceivePort();
    ReceivePort isolateToMainStreamError = ReceivePort();
    isolateToMainStreamError.listen(print);
    _isolateToMainStream.listen(_handleMessages);

    _isolateInstance = await Isolate.spawn(
        myIsolate, _isolateToMainStream.sendPort,
        onError: isolateToMainStreamError.sendPort);

    return _filteredImage?.future;
  }

  void _handleMessages(message) {
    if (message is SendPort) {
      //If the message going to main thread is a sendPort from the isolate
      _mainStreamToIsolateStream = message;
      _isolateReady.complete(true);
      return;
    }
    if (message is List<int>) {
      //If the message going to main thread is a list of filtered images from isolate
      _filteredImage?.complete(message);
      _filteredImage = null;
      return;
    }
  }

  static void myIsolate(dynamic message) {
    SendPort sendPort;
    final isolateReceivePort = ReceivePort();
    print("myIsolate entryPoint called");

    isolateReceivePort.listen((message) async {
      assert(message is Map<String, dynamic>);
      List<int> filteredImage = applyFilter(
          filter: message['filter'],
          filename: message['filename'],
          image: message['image']);

      sendPort.send(filteredImage);
    });

    if (message is SendPort) {
      sendPort = message;
      sendPort.send(isolateReceivePort.sendPort);
      return;
    }
  }

  ///Call this function from the main ui thread
  ///paramaters: position of filter, optional parament intensity
  Future<List<int>> getFilteredImage(
      {Filter filter,
      imageLib.Image image,
      String filename,
      double intensity}) async {
    print("Filter[#${filter.intensity.toString()}]");
    _mainStreamToIsolateStream.send(<String, dynamic>{
      'filter': filter,
      'image': image,
      'filename': filename,
    });

    _filteredImage = Completer<List<int>>();
    return _filteredImage?.future;
  }

  ///The global applyfilter function
  static List<int> applyFilter({
    Filter filter,
    imageLib.Image image,
    String filename,
  }) {
    print("Calling Apply Filter");
    Filter nfilter =
        filter; //presetFiltersList[filterPosition]; //params["filter"];
    //imageLib.Image image = params["image"];
    //String filename = params["filename"];

    List<int> _bytes = image.getBytes();
    if (nfilter != null) {
      nfilter.apply(_bytes, image.width, image.height);
    }

    imageLib.Image _image =
        imageLib.Image.fromBytes(image.width, image.height, _bytes);
    _bytes = imageLib.encodeNamedImage(_image, filename);

    return _bytes;
  }
}
