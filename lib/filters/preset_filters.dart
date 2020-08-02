import 'dart:typed_data';

import 'package:photofilters/filters/color_filters.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:photofilters/filters/subfilters.dart';

// NoFilter: No filter
class NoFilter extends ColorFilter {
  NoFilter() : super(name: "No Filter");

  @override
  void apply(Uint8List pixels, int width, int height) {
    // Do nothing
  }
}

// Clarendon: adds light to lighter areas and dark to darker areas
class ClarendonFilter extends ColorFilter {
  ClarendonFilter() : super(name: "Clarendon", intensity: 35) {
    subFilters.add(new BrightnessSubFilter(0.1));
    subFilters.add(new ContrastSubFilter(.1));
    subFilters.add(new SaturationSubFilter(0.15));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new BrightnessSubFilter(0.1 - 0.035 + (val / 1000)));
    subFilters.add(new ContrastSubFilter(0.1 - 0.035 + (val / 1000)));
    subFilters.add(new SaturationSubFilter(0.15 - 0.035 + (val / 1000)));
  }
}

class AddictiveRedFilter extends ColorFilter {
  AddictiveRedFilter() : super(name: "AddictiveRed", intensity: 35) {
    subFilters.add(new AddictiveColorSubFilter(40, 0, 0));
  }
  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new AddictiveColorSubFilter((5 + val), 0, 0));
  }
}

class AddictiveBlueFilter extends ColorFilter {
  AddictiveBlueFilter() : super(name: "AddictiveBlue", intensity: 35) {
    subFilters.add(new AddictiveColorSubFilter(0, 0, 40));
  }
  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new AddictiveColorSubFilter(0, 0, (5 + val)));
  }
}

// Gingham: Vintage-inspired, taking some color out
class GinghamFilter extends ColorFilter {
  GinghamFilter() : super(name: "Gingham", intensity: 35) {
    subFilters.add(new SepiaSubFilter(.04));
    subFilters.add(new ContrastSubFilter(-.15));
  }
  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new SepiaSubFilter(.04 - 0.035 + (val / 1000)));
    subFilters.add(new ContrastSubFilter(-0.15 - 0.035 + (val / 1000)));
  }
}

// Moon: B/W, increase brightness and decrease contrast
class MoonFilter extends ColorFilter {
  MoonFilter() : super(name: "Moon", intensity: 40) {
    subFilters.add(new GrayScaleSubFilter());
    subFilters.add(new ContrastSubFilter(-.04));
    subFilters.add(new BrightnessSubFilter(0.1));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();

    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new GrayScaleSubFilter());
    subFilters.add(new ContrastSubFilter(-0.04 - 0.0004 + (-val / 10000)));
    subFilters.add(new BrightnessSubFilter(0.1 - 0.0004 + (val / 10000)));
  }
}

// Lark: Brightens and intensifies colours but not red hues
class LarkFilter extends ColorFilter {
  LarkFilter() : super(name: "Lark", intensity: 45.6) {
    subFilters.add(new BrightnessSubFilter(0.08));
    subFilters.add(new GrayScaleSubFilter());
    subFilters.add(new ContrastSubFilter(-.04));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new BrightnessSubFilter(0.08 - 0.0456 + (val / 1000)));
    subFilters.add(new GrayScaleSubFilter());
    subFilters.add(new ContrastSubFilter(-0.04 - 0.0456 + (-val / 1000)));
  }
}

// Reyes: a new vintage filter, gives your photos a “dusty” look
class ReyesFilter extends ColorFilter {
  ReyesFilter() : super(name: "Reyes", intensity: 35) {
    subFilters.add(new SepiaSubFilter(0.4));
    subFilters.add(new BrightnessSubFilter(0.13));
    subFilters.add(new ContrastSubFilter(-.05));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new SepiaSubFilter(0.4 - 0.035 + (val / 1000)));
    subFilters.add(new BrightnessSubFilter(0.13 - 0.035 + (val / 1000)));
    subFilters.add(new ContrastSubFilter(-.05 + 0.035 + (-val / 1000)));
  }
}

// Juno: Brightens colors, and intensifies red and yellow hues
class JunoFilter extends ColorFilter {
  JunoFilter() : super(name: "Juno", intensity: 80) {
    subFilters.add(new RGBScaleSubFilter(1.01, 1.04, 1));
    subFilters.add(new SaturationSubFilter(0.3));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new RGBScaleSubFilter(1.01 - 0.08 + (val / 1000),
        1.04 - 0.08 + (val / 1000), 1 - 0.08 + (val / 1000)));
    subFilters.add(new SaturationSubFilter(0.3 - 0.08 + (val / 1000)));
  }
}

// Slumber: Desaturates the image as well as adds haze for a retro, dreamy look – with an emphasis on blacks and blues
class SlumberFilter extends ColorFilter {
  SlumberFilter() : super(name: "Slumber", intensity: 35.6) {
    subFilters.add(new BrightnessSubFilter(.1));
    subFilters.add(new SaturationSubFilter(-0.5));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new BrightnessSubFilter(0.1 - 0.0356 + (val / 1000)));
    subFilters.add(new SaturationSubFilter(-0.5 + 0.0356 + (-val / 1000)));
  }
}

// Crema: Adds a creamy look that both warms and cools the image
class CremaFilter extends ColorFilter {
  CremaFilter() : super(name: "Crema", intensity: 35) {
    subFilters.add(new RGBScaleSubFilter(1.04, 1, 1.02));
    subFilters.add(new SaturationSubFilter(-0.05));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new RGBScaleSubFilter(1.04 + (val / 1000) - 0.035,
        1 + (val / 1000) - 0.035, 1.02 + (val / 1000) - 0.035));
    subFilters.add(new SaturationSubFilter(-0.05 + (-val / 1000) + 0.035));
  }
}

// Ludwig: A slight hint of desaturation that also enhances light
class LudwigFilter extends ColorFilter {
  LudwigFilter() : super(name: "Ludwig", intensity: 0.456) {
    subFilters.add(new BrightnessSubFilter(.05));
    subFilters.add(new SaturationSubFilter(-0.03));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new BrightnessSubFilter(.05 - 0.000456 + (val / 1000)));
    subFilters.add(new SaturationSubFilter(-0.03 - 0.000456 + (val / 1000)));
  }
}

// Aden: This filter gives a blue/pink natural look
class AdenFilter extends ColorFilter {
  AdenFilter() : super(name: "Aden", intensity: 55.6) {
    subFilters.add(new RGBOverlaySubFilter(228, 130, 225, 0.13));
    subFilters.add(new SaturationSubFilter(-0.2));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(
        new RGBOverlaySubFilter(228, 130, 225, 0.13 - 0.0556 + (val / 1000)));
    subFilters.add(new SaturationSubFilter(-0.2 - 0.0556 + (-val / 1000)));
  }
}

// Perpetua: Adding a pastel look, this filter is ideal for portraits
class PerpetuaFilter extends ColorFilter {
  PerpetuaFilter() : super(name: "Perpetua", intensity: 1) {
    subFilters.add(new RGBScaleSubFilter(1.05, 1.1, 1));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new RGBScaleSubFilter(1.05 - 0.001 + (val / 1000),
        1.1 - 0.001 + (val / 1000), 1 - 0.001 + (val / 1000)));
  }
}

// Amaro: Adds light to an image, with the focus on the centre
class AmaroFilter extends ColorFilter {
  AmaroFilter() : super(name: "Amaro", intensity: 25) {
    subFilters.add(new SaturationSubFilter(0.3));
    subFilters.add(new BrightnessSubFilter(0.15));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new SaturationSubFilter(0.3 - 0.025 + (val / 1000)));
    subFilters.add(new BrightnessSubFilter(0.15 - 0.025 + (val / 1000)));
  }
}

// Mayfair: Applies a warm pink tone, subtle vignetting to brighten the photograph center and a thin black border
class MayfairFilter extends ColorFilter {
  MayfairFilter() : super(name: "Mayfair", intensity: 60) {
    subFilters.add(new RGBOverlaySubFilter(230, 115, 108, 0.05));
    subFilters.add(new SaturationSubFilter(0.15));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(
        new RGBOverlaySubFilter(230, 115, 108, 0.05 - 0.05 + (val / 1000)));
    subFilters.add(new SaturationSubFilter(0.15 - 0.06 + (val / 1000)));
  }
}

// Rise: Adds a "glow" to the image, with softer lighting of the subject
class RiseFilter extends ColorFilter {
  RiseFilter() : super(name: "Rise", intensity: 50) {
    subFilters.add(new RGBOverlaySubFilter(255, 170, 0, 0.1));
    subFilters.add(new BrightnessSubFilter(0.09));
    subFilters.add(new SaturationSubFilter(0.1));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters
        .add(new RGBOverlaySubFilter(255, 170, 0, 0.1 - 0.05 + (val / 1000)));
    subFilters.add(new BrightnessSubFilter(0.09 - 0.05 + (val / 1000)));
    subFilters.add(new SaturationSubFilter(0.1 - 0.05 + (val / 1000)));
  }
}

// Hudson: Creates an "icy" illusion with heightened shadows, cool tint and dodged center
class HudsonFilter extends ColorFilter {
  HudsonFilter() : super(name: "Hudson", intensity: 25) {
    subFilters.add(new RGBScaleSubFilter(1, 1, 1.25));
    subFilters.add(new ContrastSubFilter(0.1));
    subFilters.add(new BrightnessSubFilter(0.15));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new RGBScaleSubFilter(1 - 0.025 + (val / 1000),
        1 - 0.025 + (val / 1000), 1.25 - 0.025 + (val / 1000)));
    subFilters.add(new ContrastSubFilter(0.1 - 0.025 + (val / 1000)));
    subFilters.add(new BrightnessSubFilter(0.15 - 0.025 + (val / 1000)));
  }
}

// Valencia: Fades the image by increasing exposure and warming the colors, to give it an antique feel
class ValenciaFilter extends ColorFilter {
  ValenciaFilter() : super(name: "Valencia", intensity: 35) {
    subFilters.add(new RGBOverlaySubFilter(255, 225, 80, 0.08));
    subFilters.add(new SaturationSubFilter(0.1));
    subFilters.add(new ContrastSubFilter(0.05));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(
        new RGBOverlaySubFilter(255, 225, 80, 0.08 - 0.035 + (val / 1000)));
    subFilters.add(new SaturationSubFilter(0.1 - 0.035 + (val / 1000)));
    subFilters.add(new ContrastSubFilter(0.05 - 0.035 + (val / 1000)));
  }
}

// X-Pro II: Increases color vibrance with a golden tint, high contrast and slight vignette added to the edges
class XProIIFilter extends ColorFilter {
  XProIIFilter() : super(name: "X-Pro II", intensity: 35) {
    subFilters.add(new RGBOverlaySubFilter(255, 255, 0, 0.07));
    subFilters.add(new SaturationSubFilter(0.2));
    subFilters.add(new ContrastSubFilter(0.15));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters
        .add(new RGBOverlaySubFilter(255, 255, 0, 0.07 - 0.035 + (val / 1000)));
    subFilters.add(new SaturationSubFilter(0.2 - 0.035 + (val / 1000)));
    subFilters.add(new ContrastSubFilter(0.15 - 0.035 + (val / 1000)));
  }
}

// Sierra: Gives a faded, softer look
class SierraFilter extends ColorFilter {
  SierraFilter() : super(name: "Sierra", intensity: 3) {
    subFilters.add(new ContrastSubFilter(-0.15));
    subFilters.add(new SaturationSubFilter(0.1));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new ContrastSubFilter(-0.15 + 0.003 + (-val / 1000)));
    subFilters.add(new SaturationSubFilter(0.1 - 0.003 + (val / 1000)));
  }
}

// Willow: A monochromatic filter with subtle purple tones and a translucent white border
class WillowFilter extends ColorFilter {
  WillowFilter() : super(name: "Willow", intensity: 30) {
    subFilters.add(new GrayScaleSubFilter());
    subFilters.add(new RGBOverlaySubFilter(100, 28, 210, 0.03));
    subFilters.add(new BrightnessSubFilter(0.1));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new GrayScaleSubFilter());
    subFilters.add(new RGBOverlaySubFilter(100, 28, 210, 0.03 + (val / 1000)));
    subFilters.add(new BrightnessSubFilter(0.1 + (val / 1000)));
  }
}

// Lo-Fi: Enriches color and adds strong shadows through the use of saturation and "warming" the temperature
class LoFiFilter extends ColorFilter {
  LoFiFilter() : super(name: "Lo-Fi", intensity: 35.6) {
    subFilters.add(new ContrastSubFilter(0.15));
    subFilters.add(new SaturationSubFilter(0.2));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new ContrastSubFilter(0.15 - 0.0356 + (val / 1000)));
    subFilters.add(new SaturationSubFilter(0.2 - 0.0356 + (val / 1000)));
  }
}

// Inkwell: Direct shift to black and white
class InkwellFilter extends ColorFilter {
  InkwellFilter() : super(name: "Inkwell", intensity: 0) {
    subFilters.add(new GrayScaleSubFilter());
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new GrayScaleSubFilter());
    subFilters.add(new BrightnessSubFilter(0.0 + (val / 1000)));
    subFilters.add(new ContrastSubFilter((val / 1000)));
  }
}

// Hefe: Hight contrast and saturation, with a similar effect to Lo-Fi but not quite as dramatic
class HefeFilter extends ColorFilter {
  HefeFilter() : super(name: "Hefe", intensity: 38) {
    subFilters.add(new ContrastSubFilter(0.1));
    subFilters.add(new SaturationSubFilter(0.15));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new ContrastSubFilter(0.1 - 0.038 + (val / 1000)));
    subFilters.add(new SaturationSubFilter(0.15 - 0.038 + (val / 1000)));
  }
}

// Nashville: Warms the temperature, lowers contrast and increases exposure to give a light "pink" tint – making it feel "nostalgic"
class NashvilleFilter extends ColorFilter {
  NashvilleFilter() : super(name: "Nashville", intensity: 25) {
    subFilters.add(new RGBOverlaySubFilter(220, 115, 188, 0.12));
    subFilters.add(new ContrastSubFilter(-0.05));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(
        new RGBOverlaySubFilter(220, 115, 188, 0.12 - 0.025 + (val / 1000)));
    subFilters.add(new ContrastSubFilter(-0.05 - 0.025 + (-val / 1000)));
  }
}

// Stinson: washing out the colors ever so slightly
class StinsonFilter extends ColorFilter {
  StinsonFilter() : super(name: "Stinson", intensity: 35) {
    subFilters.add(new BrightnessSubFilter(0.1));
    subFilters.add(new SepiaSubFilter(0.3));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new BrightnessSubFilter(0.1 - 0.035 + (val / 1000)));
    subFilters.add(new SepiaSubFilter(0.3 - 0.035 + (val / 1000)));
  }
}

// Vesper: adds a yellow tint that
class VesperFilter extends ColorFilter {
  VesperFilter() : super(name: "Vesper", intensity: 25) {
    subFilters.add(new RGBOverlaySubFilter(255, 225, 0, 0.05));
    subFilters.add(new BrightnessSubFilter(0.06));
    subFilters.add(new ContrastSubFilter(0.06));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters
        .add(new RGBOverlaySubFilter(255, 225, 0, 0.05 - 0.025 + (val / 1000)));
    subFilters.add(new BrightnessSubFilter(0.06 - 0.025 + (val / 1000)));
    subFilters.add(new ContrastSubFilter(0.06 - 0.025 + (val / 1000)));
  }
}

// Earlybird: Gives an older look with a sepia tint and warm temperature
class EarlybirdFilter extends ColorFilter {
  EarlybirdFilter() : super(name: "Earlybird", intensity: 35) {
    subFilters.add(new RGBOverlaySubFilter(255, 165, 40, 0.2));
    subFilters.add(new SaturationSubFilter(0.15));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters
        .add(new RGBOverlaySubFilter(255, 165, 40, 0.2 - 0.035 + (val / 1000)));
    subFilters.add(new SaturationSubFilter(0.15 - 0.035 + (val / 1000)));
  }
}

// Brannan: Increases contrast and exposure and adds a metallic tint
class BrannanFilter extends ColorFilter {
  BrannanFilter() : super(name: "Brannan", intensity: 45) {
    subFilters.add(new ContrastSubFilter(0.2));
    subFilters.add(new RGBOverlaySubFilter(140, 10, 185, 0.1));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new ContrastSubFilter(0.2 - 0.045 + (val / 1000)));
    subFilters
        .add(new RGBOverlaySubFilter(140, 10, 185, 0.1 - 0.045 + (val / 1000)));
  }
}

// Sutro: Burns photo edges, increases highlights and shadows dramatically with a focus on purple and brown colors
class SutroFilter extends ColorFilter {
  SutroFilter() : super(name: "Sutro", intensity: 45) {
    subFilters.add(new BrightnessSubFilter(-0.1));
    subFilters.add(new SaturationSubFilter(-0.1));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new BrightnessSubFilter(-0.1 + 0.045 - (val / 1000)));
    subFilters.add(new SaturationSubFilter(-0.1 + 0.045 - (val / 1000)));
  }
}

// Toaster: Ages the image by "burning" the centre and adds a dramatic vignette
class ToasterFilter extends ColorFilter {
  ToasterFilter() : super(name: "Toaster", intensity: 45) {
    subFilters.add(new SepiaSubFilter(0.1));
    subFilters.add(new RGBOverlaySubFilter(255, 145, 0, 0.2));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new SepiaSubFilter(0.1 - 0.045 + (val / 1000)));
    subFilters
        .add(new RGBOverlaySubFilter(255, 145, 0, 0.2 - 0.045 + (val / 1000)));
  }
}

// Walden: Increases exposure and adds a yellow tint
class WaldenFilter extends ColorFilter {
  WaldenFilter() : super(name: "Walden", intensity: 50) {
    subFilters.add(new BrightnessSubFilter(0.1));
    subFilters.add(new RGBOverlaySubFilter(255, 255, 0, 0.2));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new BrightnessSubFilter(0.1 - 0.05 + (val / 1000)));
    subFilters
        .add(new RGBOverlaySubFilter(255, 255, 0, 0.2 - 0.05 + (val / 1000)));
  }
}

// 1977: The increased exposure with a red tint gives the photograph a rosy, brighter, faded look.
class F1977Filter extends ColorFilter {
  F1977Filter() : super(name: "1977", intensity: 20) {
    subFilters.add(new RGBOverlaySubFilter(255, 25, 0, 0.15));
    subFilters.add(new BrightnessSubFilter(0.1));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters
        .add(new RGBOverlaySubFilter(255, 25, 0, 0.15 - 0.02 + (val / 1000)));
    subFilters.add(new BrightnessSubFilter(0.1 - 0.02 + (val / 1000)));
  }
}

// Kelvin: Increases saturation and temperature to give it a radiant "glow"
class KelvinFilter extends ColorFilter {
  KelvinFilter() : super(name: "Kelvin", intensity: 25) {
    subFilters.add(new RGBOverlaySubFilter(255, 140, 0, 0.1));
    subFilters.add(new RGBScaleSubFilter(1.15, 1.05, 1));
    subFilters.add(new SaturationSubFilter(0.35));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters
        .add(new RGBOverlaySubFilter(255, 140, 0, 0.1 - 0.025 + (val / 1000)));
    subFilters.add(new RGBScaleSubFilter(1.15 - 0.025 + (val / 1000),
        1.05 - 0.025 + (val / 1000), 1 - 0.025 + (val / 1000)));
    subFilters.add(new SaturationSubFilter(0.35 - 0.025 + (val / 1000)));
  }
}

// Maven: darkens images, increases shadows, and adds a slightly yellow tint overal
class MavenFilter extends ColorFilter {
  MavenFilter() : super(name: "Maven", intensity: 56) {
    subFilters.add(new RGBOverlaySubFilter(225, 240, 0, 0.1));
    subFilters.add(new SaturationSubFilter(0.25));
    subFilters.add(new ContrastSubFilter(0.05));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters
        .add(new RGBOverlaySubFilter(225, 240, 0, 0.1 - 0.056 + (val / 1000)));
    subFilters.add(new SaturationSubFilter(0.25 - 0.056 + (val / 1000)));
    subFilters.add(new ContrastSubFilter(0.05 - 0.056 + (val / 1000)));
  }
}

// Ginza: brightens and adds a warm glow
class GinzaFilter extends ColorFilter {
  GinzaFilter() : super(name: "Ginza", intensity: 35) {
    subFilters.add(new SepiaSubFilter(0.06));
    subFilters.add(new BrightnessSubFilter(0.1));
  }
  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new SepiaSubFilter(0.06 - 0.035 + (val / 1000)));
    subFilters.add(new BrightnessSubFilter(0.1 - 0.035 + (val / 1000)));
  }
}

// Skyline: brightens to the image pop
class SkylineFilter extends ColorFilter {
  SkylineFilter() : super(name: "Skyline", intensity: 65) {
    subFilters.add(new SaturationSubFilter(0.35));
    subFilters.add(new BrightnessSubFilter(0.1));
  }
  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new SaturationSubFilter(0.35 - 0.065 + (val / 1000)));
    subFilters.add(new BrightnessSubFilter(0.1 - 0.065 + (val / 1000)));
  }
}

// Dogpatch: increases the contrast, while washing out the lighter colors
class DogpatchFilter extends ColorFilter {
  DogpatchFilter() : super(name: "Dogpatch", intensity: 41) {
    subFilters.add(new ContrastSubFilter(0.15));
    subFilters.add(new BrightnessSubFilter(0.1));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(new ContrastSubFilter(0.15 - 0.041 + (val / 1000)));
    subFilters.add(new BrightnessSubFilter(0.1 - 0.041 + (val / 1000)));
  }
}

// Brooklyn
class BrooklynFilter extends ColorFilter {
  BrooklynFilter() : super(name: "Brooklyn", intensity: 35) {
    subFilters.add(new RGBOverlaySubFilter(25, 240, 252, 0.05));
    subFilters.add(new SepiaSubFilter(0.3));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters.add(
        new RGBOverlaySubFilter(25, 240, 252, 0.05 - 0.035 + (val / 1000)));
    subFilters.add(new SepiaSubFilter(0.3 - 0.035 + (val / 1000)));
  }
}

// Helena: adds an orange and teal vibe
class HelenaFilter extends ColorFilter {
  HelenaFilter() : super(name: "Helena", intensity: 25) {
    subFilters.add(new RGBOverlaySubFilter(208, 208, 86, 0.2));
    subFilters.add(new ContrastSubFilter(0.15));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters
        .add(new RGBOverlaySubFilter(208, 208, 86, 0.2 - 0.025 + (val / 1000)));
    subFilters.add(new ContrastSubFilter(0.15 - 0.025 + (val / 1000)));
  }
}

// Ashby: gives images a great golden glow and a subtle vintage feel
class AshbyFilter extends ColorFilter {
  AshbyFilter() : super(name: "Ashby", intensity: 65) {
    subFilters.add(new RGBOverlaySubFilter(255, 160, 25, 0.1));
    subFilters.add(new BrightnessSubFilter(0.1));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters
        .add(new RGBOverlaySubFilter(255, 160, 25, 0.1 - 0.065 + (val / 1000)));
    subFilters.add(new BrightnessSubFilter(0.1 - 0.065 + (val / 1000)));
  }
}

// Charmes: a high contrast filter, warming up colors in your image with a red tint
class CharmesFilter extends ColorFilter {
  CharmesFilter() : super(name: "Charmes", intensity: 45) {
    subFilters.add(new RGBOverlaySubFilter(255, 50, 80, 0.12));
    subFilters.add(new ContrastSubFilter(0.05));
  }

  void setIntensityF(int val) {
    intensity = val.toDouble();
    subFilters.clear();
    print("ThisVal $val");
    subFilters
        .add(new RGBOverlaySubFilter(255, 50, 80, 0.12 - 0.045 + (val / 1000)));
    subFilters.add(new ContrastSubFilter(0.05 - 0.045 + (val / 1000)));
  }
}

List<Filter> presetFiltersList = [
  NoFilter(),
  AddictiveBlueFilter(),
  AddictiveRedFilter(),
  AdenFilter(),
  AmaroFilter(),
  AshbyFilter(),
  BrannanFilter(),
  BrooklynFilter(),
  CharmesFilter(),
  ClarendonFilter(),
  CremaFilter(),
  DogpatchFilter(),
  EarlybirdFilter(),
  F1977Filter(),
  GinghamFilter(),
  GinzaFilter(),
  HefeFilter(),
  HelenaFilter(),
  HudsonFilter(),
  InkwellFilter(),
  JunoFilter(),
  KelvinFilter(),
  LarkFilter(),
  LoFiFilter(),
  LudwigFilter(),
  MavenFilter(),
  MayfairFilter(),
  MoonFilter(),
  NashvilleFilter(),
  PerpetuaFilter(),
  ReyesFilter(),
  RiseFilter(),
  SierraFilter(),
  SkylineFilter(),
  SlumberFilter(),
  StinsonFilter(),
  SutroFilter(),
  ToasterFilter(),
  ValenciaFilter(),
  VesperFilter(),
  WaldenFilter(),
  WillowFilter(),
  XProIIFilter(),
];
