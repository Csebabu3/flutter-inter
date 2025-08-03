// lib/web_view_registry_web.dart

// ignore: undefined_prefixed_name
import 'dart:ui_web' as ui;

void registerViewFactory(String viewType, dynamic Function(int) cb) {
  ui.platformViewRegistry.registerViewFactory(viewType, cb);
}
