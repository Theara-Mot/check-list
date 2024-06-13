import 'package:checklist/providers/theme_notifier.dart';
import 'package:checklist/screen/home_screen.dart';
import 'package:checklist/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context,ScopedReader watch) {
    final themeNotifier = watch(themeNotifierProvider);
    return MaterialApp(
      title: 'Check List',
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.themeData,
      home: Testing(),
    );
  }
}
