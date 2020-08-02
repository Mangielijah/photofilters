import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path_provider/path_provider.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:photofilters/utils/isolate_worker.dart';

import '../filters/preset_filters.dart';

class PhotoFilter extends StatelessWidget {
  final imageLib.Image image;
  final String filename;
  final Filter filter;
  final BoxFit fit;
  final Widget loader;

  PhotoFilter({
    @required this.image,
    @required this.filename,
    @required this.filter,
    this.fit = BoxFit.fill,
    this.loader = const Center(child: CircularProgressIndicator()),
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: compute(applyFilter, <String, dynamic>{
        "filter": filter,
        "image": image,
        "filename": filename,
      }),
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return loader;
          case ConnectionState.active:
          case ConnectionState.waiting:
            return loader;
          case ConnectionState.done:
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            return Image.memory(
              snapshot.data,
              fit: fit,
            );
        }
        return null; // unreachable
      },
    );
  }
}

///The PhotoFilterSelector Widget for apply filter from a selected set of filters
class PhotoFilterSelector extends StatefulWidget {
  final Widget title;
  final Color appBarColor;
  final List<Filter> filters;
  final imageLib.Image image;
  final Widget loader;
  final BoxFit fit;
  final String filename;
  final bool circleShape;

  const PhotoFilterSelector({
    Key key,
    @required this.title,
    @required this.filters,
    @required this.image,
    this.appBarColor = Colors.blue,
    this.loader = const Center(child: CircularProgressIndicator()),
    this.fit = BoxFit.fill,
    @required this.filename,
    this.circleShape = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _PhotoFilterSelectorState();
}

class _PhotoFilterSelectorState extends State<PhotoFilterSelector> {
  String filename;
  Map<String, List<int>> cachedFilters = {};
  Filter _filter;
  imageLib.Image image;
  bool loading;

  List<IsolateWorker> isolateList = <IsolateWorker>[];
  int isolateCounter = 0;
  SendPort sendPort;

  int intensityOfIndex;

  bool showIntensityBox;

  double intensityValue;

  @override
  void initState() {
    super.initState();
    loading = false;
    _filter = widget.filters[0];
    filename = widget.filename;
    image = widget.image;
    isolateList.clear();
    isolateCounter = 0;
    intensityValue = 1;
    showIntensityBox = true;
    intensityOfIndex = 0;
  }

  Future<List<int>> spawnIsolateGetImage(
      Filter filter, imageLib.Image image, String filename, int index) async {
    IsolateWorker _isolateWorker = IsolateWorker();
    bool status = await _isolateWorker.isReady;
    List<int> img;
    if (status) {
      print("Isolate is ready");
      //isolateList.add(_isolateWorker);
      print("isolateList[$index + 1]");
      isolateList.add(_isolateWorker);
      img = await _isolateWorker.getFilteredImage(
          filter: filter, image: image, filename: filename);
    }
    /*setState(() {
      loading = false;
    });*/
    //isolateList.removeAt(index).dispose();
    _isolateWorker.dispose();
    return img;
  }

  Future<List<int>> spawnFIsolateGetImage(
      Filter filter, imageLib.Image image, String filename) async {
    IsolateWorker _isolateWorker = IsolateWorker();
    bool status = await _isolateWorker.isReady;
    List<int> img;
    if (status) {
      print("Isolate is ready");
      isolateList.insert(0, _isolateWorker);
      img = await _isolateWorker.getFilteredImage(
          filter: filter, image: image, filename: filename);
    }
    /*setState(() {
      loading = false;
    });*/
    //isolateList.removeAt(index).dispose();
    _isolateWorker.dispose();
    return img;
  }

  @override
  void dispose() {
    if (isolateList.isNotEmpty) {
      isolateList.forEach((isolate) {
        isolate?.dispose();
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: widget.title,
          backgroundColor: widget.appBarColor,
          actions: <Widget>[
            loading
                ? Container()
                : IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      var imageFile = await saveFilteredImage();

                      Navigator.pop(context, {'image_filtered': imageFile});
                    },
                  )
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: loading
              ? widget.loader
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: EdgeInsets.all(12.0),
                        child: _buildFilteredImage(
                          _filter,
                          image,
                          filename,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: (showIntensityBox)
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.filters.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          _buildFilterThumbnail(
                                              widget.filters[index],
                                              image,
                                              filename,
                                              index),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            widget.filters[index].name,
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () => setState(() {
                                      _filter = widget.filters[index];
                                    }),
                                    onDoubleTap: () =>
                                        _showIntensityFilter(index),
                                  );
                                },
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    //flex: 1,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.cancel,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          showIntensityBox = true;
                                          intensityValue = 1;
                                        });
                                      },
                                      iconSize: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        valueIndicatorColor: Colors.white,
                                      ),
                                      child: Slider(
                                        value: intensityValue,
                                        onChangeEnd: (value) {
                                          print("New intensity value");
                                          setState(() {
                                            intensityValue = value;

                                            cachedFilters.remove(widget
                                                .filters[intensityOfIndex]
                                                .name);
                                            widget.filters[intensityOfIndex]
                                                .intensity = value;
                                            _handleFilters(
                                              intensityOfIndex,
                                              widget.filters[intensityOfIndex]
                                                  .runtimeType
                                                  .toString(),
                                              value.toInt(),
                                            );
                                            _filter = widget
                                                .filters[intensityOfIndex];
                                          });
                                          print(
                                              "new intensity for filter type: ${widget.filters[intensityOfIndex].runtimeType.toString()} has: ${cachedFilters.containsKey(widget.filters[intensityOfIndex].name)}");
                                        },
                                        onChanged: (value) {
                                          if (value.toInt() !=
                                              intensityValue.toInt()) {
                                            intensityValue = value;
                                          } else {
                                            print(
                                                "They are same $intensityValue and $value");
                                          }
                                          //_filter.intensity = value;
                                          setState(() {});
                                        },
                                        activeColor: Colors.white,
                                        inactiveColor: Colors.grey,
                                        label: intensityValue.toString(),
                                        min: 0,
                                        max: 100,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    //flex: 1,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.check,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          showIntensityBox = true;

                                          print("intensity: $intensityValue");
                                          cachedFilters.remove(widget
                                              .filters[intensityOfIndex].name);
                                        });
                                      },
                                      iconSize: 30,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _buildFilterThumbnail(
      Filter filter, imageLib.Image image, String filename, int index) {
    if (cachedFilters[filter?.name ?? "_"] == null) {
      return FutureBuilder<List<int>>(
        future: spawnIsolateGetImage(filter, image, filename, index),
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return CircleAvatar(
                radius: 50.0,
                child: Center(
                  child: widget.loader,
                ),
                backgroundColor: Colors.white,
              );
            case ConnectionState.done:
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              cachedFilters[filter?.name ?? "_"] = snapshot.data;
              return CircleAvatar(
                radius: 50.0,
                backgroundImage: MemoryImage(
                  snapshot.data,
                ),
                backgroundColor: Colors.white,
              );
          }
          return null; // unreachable
        },
      );
    } else {
      return CircleAvatar(
        radius: 50.0,
        backgroundImage: MemoryImage(
          cachedFilters[filter?.name ?? "_"],
        ),
        backgroundColor: Colors.white,
      );
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/filtered_${_filter?.name ?? "_"}_$filename');
  }

  Future<File> saveFilteredImage() async {
    var imageFile = await _localFile;
    await imageFile.writeAsBytes(cachedFilters[_filter?.name ?? "_"]);
    return imageFile;
  }

  Widget _buildFilteredImage(
      Filter filter, imageLib.Image image, String filename) {
    if (cachedFilters[filter?.name ?? "_"] == null) {
      return FutureBuilder<List<int>>(
        future: spawnFIsolateGetImage(filter, image, filename),
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return widget.loader;
            case ConnectionState.active:
            case ConnectionState.waiting:
              return widget.loader;
            case ConnectionState.done:
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              cachedFilters[filter?.name ?? "_"] = snapshot.data;
              return widget.circleShape
                  ? SizedBox(
                      height: MediaQuery.of(context).size.width / 3,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Center(
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 3,
                          backgroundImage: MemoryImage(
                            snapshot.data,
                          ),
                        ),
                      ),
                    )
                  : Image.memory(
                      snapshot.data,
                      fit: BoxFit.contain,
                    );
          }
          return null; // unreachable
        },
      );
    } else {
      return widget.circleShape
          ? SizedBox(
              height: MediaQuery.of(context).size.width / 3,
              width: MediaQuery.of(context).size.width / 3,
              child: Center(
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 3,
                  backgroundImage: MemoryImage(
                    cachedFilters[filter?.name ?? "_"],
                  ),
                ),
              ),
            )
          : Image.memory(
              cachedFilters[filter?.name ?? "_"],
              fit: widget.fit,
            );
    }
  }

  void _showIntensityFilter(int index) {
    setState(() {
      showIntensityBox = false;
      intensityOfIndex = index;
      print("Current intensity value: $intensityValue");
      intensityValue = widget.filters[index].intensity;
    });
  }

  void _handleFilters(int intensityOfIndex, String filter, int value) {
    //Handle Filter switching
    switch (filter) {
      case "AddictiveRedFilter":
        widget.filters[intensityOfIndex] = new AddictiveRedFilter();
        (widget.filters[intensityOfIndex] as AddictiveRedFilter)
            .setIntensityF(value);
        break;
      case "AddictiveBlueFilter":
        widget.filters[intensityOfIndex] = new AddictiveBlueFilter();
        (widget.filters[intensityOfIndex] as AddictiveBlueFilter)
            .setIntensityF(value);
        break;
      case "ClarendonFilter":
        widget.filters[intensityOfIndex] = new ClarendonFilter();
        (widget.filters[intensityOfIndex] as ClarendonFilter)
            .setIntensityF(value);
        break;
      case "AdenFilter":
        widget.filters[intensityOfIndex] = new AdenFilter();
        (widget.filters[intensityOfIndex] as AdenFilter).setIntensityF(value);
        break;
      case "AmaroFilter":
        widget.filters[intensityOfIndex] = new AmaroFilter();
        (widget.filters[intensityOfIndex] as AmaroFilter).setIntensityF(value);
        break;
      case "AshbyFilter":
        widget.filters[intensityOfIndex] = new AshbyFilter();
        (widget.filters[intensityOfIndex] as AshbyFilter).setIntensityF(value);
        break;
      case "BrannanFilter":
        widget.filters[intensityOfIndex] = new BrannanFilter();
        (widget.filters[intensityOfIndex] as BrannanFilter)
            .setIntensityF(value);
        break;
      case "BrooklynFilter":
        widget.filters[intensityOfIndex] = new BrooklynFilter();
        (widget.filters[intensityOfIndex] as BrooklynFilter)
            .setIntensityF(value);
        break;
      case "CharmesFilter":
        widget.filters[intensityOfIndex] = new CharmesFilter();
        (widget.filters[intensityOfIndex] as CharmesFilter)
            .setIntensityF(value);
        break;
      case "CremaFilter":
        widget.filters[intensityOfIndex] = new CremaFilter();
        (widget.filters[intensityOfIndex] as CremaFilter).setIntensityF(value);
        break;
      case "DogpatchFilter":
        widget.filters[intensityOfIndex] = new DogpatchFilter();
        (widget.filters[intensityOfIndex] as DogpatchFilter)
            .setIntensityF(value);
        break;
      case "EarlybirdFilter":
        widget.filters[intensityOfIndex] = new EarlybirdFilter();
        (widget.filters[intensityOfIndex] as EarlybirdFilter)
            .setIntensityF(value);
        break;
      case "F1977Filter":
        widget.filters[intensityOfIndex] = new F1977Filter();
        (widget.filters[intensityOfIndex] as F1977Filter).setIntensityF(value);
        break;
      case "GinghamFilter":
        widget.filters[intensityOfIndex] = new GinghamFilter();
        (widget.filters[intensityOfIndex] as GinghamFilter)
            .setIntensityF(value);
        break;
      case "GinzaFilter":
        widget.filters[intensityOfIndex] = new GinzaFilter();
        (widget.filters[intensityOfIndex] as GinzaFilter).setIntensityF(value);
        break;
      case "HefeFilter":
        widget.filters[intensityOfIndex] = new HefeFilter();
        (widget.filters[intensityOfIndex] as HefeFilter).setIntensityF(value);
        break;
      case "HelenaFilter":
        widget.filters[intensityOfIndex] = new HelenaFilter();
        (widget.filters[intensityOfIndex] as HelenaFilter).setIntensityF(value);
        break;
      case "HudsonFilter":
        widget.filters[intensityOfIndex] = new HudsonFilter();
        (widget.filters[intensityOfIndex] as HudsonFilter).setIntensityF(value);
        break;
      case "InkwellFilter":
        widget.filters[intensityOfIndex] = new InkwellFilter();
        (widget.filters[intensityOfIndex] as InkwellFilter)
            .setIntensityF(value);
        break;
      case "JunoFilter":
        widget.filters[intensityOfIndex] = new JunoFilter();
        (widget.filters[intensityOfIndex] as JunoFilter).setIntensityF(value);
        break;
      case "KelvinFilter":
        widget.filters[intensityOfIndex] = new KelvinFilter();
        (widget.filters[intensityOfIndex] as KelvinFilter).setIntensityF(value);
        break;
      case "LarkFilter":
        widget.filters[intensityOfIndex] = new LarkFilter();
        (widget.filters[intensityOfIndex] as LarkFilter).setIntensityF(value);
        break;
      case "LoFiFilter":
        widget.filters[intensityOfIndex] = new LoFiFilter();
        (widget.filters[intensityOfIndex] as LoFiFilter).setIntensityF(value);
        break;
      case "LudwigFilter":
        widget.filters[intensityOfIndex] = new LudwigFilter();
        (widget.filters[intensityOfIndex] as LudwigFilter).setIntensityF(value);
        break;
      case "MavenFilter":
        widget.filters[intensityOfIndex] = new MavenFilter();
        (widget.filters[intensityOfIndex] as MavenFilter).setIntensityF(value);
        break;
      case "MayfairFilter":
        widget.filters[intensityOfIndex] = new MayfairFilter();
        (widget.filters[intensityOfIndex] as MayfairFilter)
            .setIntensityF(value);
        break;
      case "NashvilleFilter":
        widget.filters[intensityOfIndex] = new NashvilleFilter();
        (widget.filters[intensityOfIndex] as NashvilleFilter)
            .setIntensityF(value);
        break;
      case "PerpetuaFilter":
        widget.filters[intensityOfIndex] = new PerpetuaFilter();
        (widget.filters[intensityOfIndex] as PerpetuaFilter)
            .setIntensityF(value);
        break;
      case "ReyesFilter":
        widget.filters[intensityOfIndex] = new ReyesFilter();
        (widget.filters[intensityOfIndex] as ReyesFilter).setIntensityF(value);
        break;
      case "RiseFilter":
        widget.filters[intensityOfIndex] = new RiseFilter();
        (widget.filters[intensityOfIndex] as RiseFilter).setIntensityF(value);
        break;
      case "SierraFilter":
        widget.filters[intensityOfIndex] = new SierraFilter();
        (widget.filters[intensityOfIndex] as SierraFilter).setIntensityF(value);
        break;
      case "SkylineFilter":
        widget.filters[intensityOfIndex] = new SkylineFilter();
        (widget.filters[intensityOfIndex] as SkylineFilter)
            .setIntensityF(value);
        break;
      case "SlumberFilter":
        widget.filters[intensityOfIndex] = new SlumberFilter();
        (widget.filters[intensityOfIndex] as SlumberFilter)
            .setIntensityF(value);
        break;
      case "StinsonFilter":
        widget.filters[intensityOfIndex] = new StinsonFilter();
        (widget.filters[intensityOfIndex] as StinsonFilter)
            .setIntensityF(value);
        break;
      case "SutroFilter":
        widget.filters[intensityOfIndex] = new SutroFilter();
        (widget.filters[intensityOfIndex] as SutroFilter).setIntensityF(value);
        break;
      case "ToasterFilter":
        widget.filters[intensityOfIndex] = new ToasterFilter();
        (widget.filters[intensityOfIndex] as ToasterFilter)
            .setIntensityF(value);
        break;
      case "ValenciaFilter":
        widget.filters[intensityOfIndex] = new ValenciaFilter();
        (widget.filters[intensityOfIndex] as ValenciaFilter)
            .setIntensityF(value);
        break;
      case "VesperFilter":
        widget.filters[intensityOfIndex] = new VesperFilter();
        (widget.filters[intensityOfIndex] as VesperFilter).setIntensityF(value);
        break;
      case "WaldenFilter":
        widget.filters[intensityOfIndex] = new WaldenFilter();
        (widget.filters[intensityOfIndex] as WaldenFilter).setIntensityF(value);
        break;
      case "WillowFilter":
        widget.filters[intensityOfIndex] = new WillowFilter();
        (widget.filters[intensityOfIndex] as WillowFilter).setIntensityF(value);
        break;
      case "XProIIFilter":
        widget.filters[intensityOfIndex] = new XProIIFilter();
        (widget.filters[intensityOfIndex] as XProIIFilter).setIntensityF(value);
        break;
    }
  }
}

///The global applyfilter function
List<int> applyFilter(Map<String, dynamic> params) {
  Filter filter = params["filter"];
  imageLib.Image image = params["image"];
  String filename = params["filename"];
  List<int> _bytes = image.getBytes();
  if (filter != null) {
    filter.apply(_bytes, image.width, image.height);
  }
  imageLib.Image _image =
      imageLib.Image.fromBytes(image.width, image.height, _bytes);
  _bytes = imageLib.encodeNamedImage(_image, filename);

  return _bytes;
}

///The global buildThumbnail function
List<int> buildThumbnail(Map<String, dynamic> params) {
  int width = params["width"];
  params["image"] = imageLib.copyResize(params["image"], width: width);
  return applyFilter(params);
}
