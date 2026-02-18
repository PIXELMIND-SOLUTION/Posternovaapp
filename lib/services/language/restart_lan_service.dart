// // lib/services/app_restart_service.dart
// import 'package:flutter/material.dart';

// class AppRestartService {
//   static final GlobalKey<_AppRestartWrapperState> _key =
//       GlobalKey<_AppRestartWrapperState>();

//   static GlobalKey<_AppRestartWrapperState> get key => _key;

//   static void restartApp(BuildContext context) {
//     _key.currentState?.restartApp();
//   }
// }

// class AppRestartWrapper extends StatefulWidget {
//   final Widget child;

//   const AppRestartWrapper({Key? key, required this.child}) : super(key: key);

//   @override
//   State<AppRestartWrapper> createState() => _AppRestartWrapperState();
// }

// class _AppRestartWrapperState extends State<AppRestartWrapper> {
//   Key _appKey = UniqueKey();

//   void restartApp() {
//     setState(() {
//       _appKey = UniqueKey();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return KeyedSubtree(
//       key: _appKey,
//       child: widget.child,
//     );
//   }
// }




// lib/services/app_restart_service.dart
import 'package:flutter/material.dart';

class AppRestartService {
  static final GlobalKey<_AppRestartWrapperState> _key =
      GlobalKey<_AppRestartWrapperState>();

  static GlobalKey<_AppRestartWrapperState> get key => _key;

  // Flag to skip splash on language restart
  static bool skipSplash = false;

  static void restartApp(BuildContext context) {
    skipSplash = true;
    _key.currentState?.restartApp();
  }
}

class AppRestartWrapper extends StatefulWidget {
  final Widget child;

  const AppRestartWrapper({Key? key, required this.child}) : super(key: key);

  @override
  State<AppRestartWrapper> createState() => _AppRestartWrapperState();
}

class _AppRestartWrapperState extends State<AppRestartWrapper> {
  Key _appKey = UniqueKey();

  void restartApp() {
    setState(() {
      _appKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _appKey,
      child: widget.child,
    );
  }
}