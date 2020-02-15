library flutter_feature_flags;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ToggleFactory {
  static ToggleFactory toggles = new ToggleFactory._internal();

  factory ToggleFactory() {
    return toggles;
  }

  ToggleFactory._internal();
  Map<String, dynamic> toggleMap = Map<String, dynamic>();

  bool toggleEnabled() {
    if (this._getConfig("Toggle:Enabled") == null) {
      return false;
    } else {
      return this._getConfig("Toggle:Enabled");
    }
  }

  bool defaultValue() {
    if (this._getConfig("Toggle:DefaultValue") == null) {
      return false;
    } else {
      return this._getConfig("Toggle:DefaultValue");
    }
  }

  Future<ToggleFactory> setupToggleConfig(configName) async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      var url = Uri.parse(configName);
      var result = await http.get(url);
      Map<String, dynamic> decodedConfig = json.decode(result.body);
      toggleMap.addAll(decodedConfig);
      return toggles;
    } catch (ArgumentError) {
      String content = await rootBundle.loadString('$configName');
      Map<String, dynamic> decodedConfig = json.decode(content);
      toggleMap.addAll(decodedConfig);
      return toggles;
    }
  }

  bool _getConfig(String name) {
    return toggleMap[name];
  }

  bool getToggle(String name) {
    if (!toggleEnabled()) {
      return defaultValue();
    } else {
      return toggleMap[name];
    }
  }
}
