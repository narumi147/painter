import 'platform_interface.dart';

class PlatformMethods implements PlatformMethodsInterface {
  @override
  String? getLocalStorage(String key) => throw UnimplementedError();

  @override
  void setLocalStorage(String key, String value) => throw UnimplementedError();

  @override
  bool get rendererCanvasKit => throw UnimplementedError();
}
