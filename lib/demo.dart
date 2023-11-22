import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void createZip() {
    final logDir = '${Directory.current.path}/log';
    final zipLocation = '${Directory.current.path}/log.zip';

    var encoder = ZipFileEncoder();
    encoder.zipDirectory(Directory(logDir), filename: zipLocation);

    // Manually create a zip of a directory and individual files.
    encoder.create('${Directory.current.path}/log2.zip');
    encoder.addFile(File('another_file.txt'));

    encoder.close();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
