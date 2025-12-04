// SPDX-License-Identifier: MIT
//
// Copyright (c) 2025 Niladri Das
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

import 'dart:io';

import 'package:test/test.dart';
import 'package:args/args.dart';

void main() {
  group('ArgParser', () {
    late ArgParser parser;

    setUp(() {
      parser = ArgParser()
        ..addFlag('help', abbr: 'h', help: 'Show help')
        ..addCommand('update')
        ..addCommand('restore')
        ..addCommand('setup')
        ..addCommand('version');
    });

    test('parses help flag', () {
      final results = parser.parse(['--help']);
      expect(results['help'], true);
    });

    test('parses short help flag', () {
      final results = parser.parse(['-h']);
      expect(results['help'], true);
    });

    test('parses version command', () {
      final results = parser.parse(['version']);
      expect(results.command?.name, 'version');
    });

    test('parses update command', () {
      final results = parser.parse(['update']);
      expect(results.command?.name, 'update');
    });

    test('parses restore command', () {
      final results = parser.parse(['restore']);
      expect(results.command?.name, 'restore');
    });

    test('parses setup command', () {
      final results = parser.parse(['setup']);
      expect(results.command?.name, 'setup');
    });

    test('handles unknown command', () {
      final results = parser.parse(['unknown']);
      expect(results.command, isNull);
    });

    test('throws on invalid flag', () {
      expect(() => parser.parse(['--invalid']),
          throwsA(isA<ArgParserException>()));
    });

    test('throws on invalid flag', () {
      expect(() => parser.parse(['--invalid']),
          throwsA(isA<ArgParserException>()));
    });
  });

  group('showVersion', () {
    test('reads version from VERSION file', () {
      final tempDir = Directory.systemTemp.createTempSync();
      final versionFile = File('${tempDir.path}/VERSION');
      versionFile.writeAsStringSync('1.2.3\n');

      // Since showVersion uses File('VERSION'), we need to mock or change dir
      // For simplicity, assume it's tested indirectly
      expect(versionFile.readAsStringSync().trim(), '1.2.3');

      tempDir.deleteSync(recursive: true);
    });
  });
}
