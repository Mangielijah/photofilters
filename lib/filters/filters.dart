import 'dart:typed_data';

///The [Filter] class to define a Filter consists of multiple [SubFilter]s
abstract class Filter extends Object {
  final String name;
  double intensity;
  Filter({this.name, this.intensity}) : assert(name != null);

  ///Apply the [SubFilter] to an Image.
  void apply(Uint8List pixels);

  ///Set the intensity of the filter
  void setIntensity(double newIntensity){
    this.intensity = newIntensity;
  }
}

///The [SubFilter] class is the abstract class to define any SubFilter.
abstract class SubFilter extends Object {}
