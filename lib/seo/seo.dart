export 'text_renderer.dart'
    if (dart.library.io) 'text_renderer_vm.dart'
    if (dart.library.js) 'text_renderer_web.dart';
export 'text_type.dart';
