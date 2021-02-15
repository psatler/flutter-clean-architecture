// it is the composition root: this will know all the other layers and will
// control which page are called, etc

// so the main layer will be coupled to all other layers, so that the others ones
// can stay decouples from one another

import 'package:flutter/material.dart';

import '../ui/components/app.dart';

void main() {
  runApp(App());
}
