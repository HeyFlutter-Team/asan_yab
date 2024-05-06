import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsDisposed extends ChangeNotifier {
  Timer? _periodicTimer;

  Timer? get periodicTimer => _periodicTimer;

  set periodicTimer(Timer? value) {
    _periodicTimer = value;
    notifyListeners();
  }

  StreamController<int>? _streamController;

  StreamController<int>? get streamController => _streamController;

  set streamController(StreamController<int>? value) {
    _streamController = value;
    notifyListeners();
  }

  StreamSubscription<int>? _streamSubscription;

  StreamSubscription<int>? get streamSubscription => _streamSubscription;

  set streamSubscription(StreamSubscription<int>? value) {
    _streamSubscription = value;
    notifyListeners();
  }
  Future<void> disposeStream() async{
   periodicTimer?.cancel();
    await  streamController?.close();
    await streamSubscription?.cancel();
    notifyListeners();
  }
}

final isDisposedProvider = ChangeNotifierProvider<IsDisposed>((ref) => IsDisposed());
