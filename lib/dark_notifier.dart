import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class DarkNotifier with ChangeNotifier {
  PrefsState _currentPrefs = PrefsState(darkMode: false);

  DarkNotifier() {
    _loadDarkPref();
  }

  Future<void> _loadDarkPref() async {
    final response = await http.Client().get(backendHost + '/prefs');
    final parsed = jsonDecode(response.body);
    _currentPrefs = PrefsState(darkMode: parsed["dark"]);

    notifyListeners();
  }

  Future<void> _saveDarkPref() async {
    http.Client()
        .get(backendHost + '/prefs?set=' + _currentPrefs.darkMode.toString());
  }

  bool get isDark => _currentPrefs.darkMode;

  set darkMode(bool newValue) {
    if (newValue == _currentPrefs.darkMode) return;
    _currentPrefs = PrefsState(darkMode: newValue);
    notifyListeners();
    _saveDarkPref();
  }
}

class PrefsState {
  final bool darkMode;

  const PrefsState({this.darkMode = false});
}