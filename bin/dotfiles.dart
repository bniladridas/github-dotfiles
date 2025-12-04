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
import 'package:args/args.dart';

void _printUsageAndExit(ArgParser parser, {int? exitCode}) {
  print('Usage: dotfiles <command>');
  print('');
  print('Commands:');
  print('  update   - Update repository');
  print('  restore  - Restore dotfiles');
  print('  setup    - Run setup script (Mac only)');
  print('  version  - Show version');
  print('');
  print(parser.usage);
  if (exitCode != null) {
    exit(exitCode);
  }
}

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', help: 'Show help')
    ..addCommand('update')
    ..addCommand('restore')
    ..addCommand('setup')
    ..addCommand('version');

  final results = parser.parse(arguments);

  if (results['help'] as bool) {
    _printUsageAndExit(parser);
  }

  if (results.command == null) {
    _printUsageAndExit(parser, exitCode: 1);
  }

  switch (results.command!.name) {
    case 'update':
      updateRepo();
      break;
    case 'restore':
      restoreDotfiles();
      break;
    case 'setup':
      runSetup();
      break;
    case 'version':
      showVersion();
      break;
    default:
      print('Unknown command: ${results.command!.name}');
      exit(1);
  }
}

void updateRepo() {
  print('Updating repository...');
  final result = Process.runSync('git', ['pull']);
  if (result.exitCode != 0) {
    print('Failed to update: ${result.stderr}');
    exit(1);
  }
  print('Repository updated.');
}

void restoreDotfiles() {
  print('Restoring dotfiles...');
  final dotfiles = ['.gitconfig', '.pre-commit-config.yaml', '.yamllint'];

  for (final file in dotfiles) {
    final source = File(file);
    if (source.existsSync()) {
      source.copySync('${Platform.environment['HOME']}/$file');
      print('Restored $file');
    }
  }

  // Setup Git hooks
  print('Setting up Git hooks...');
  final hooksResult = Process.runSync('git', [
    'config',
    '--global',
    'core.hooksPath',
    '${Directory.current.path}/git-hooks'
  ]);
  if (hooksResult.exitCode != 0) {
    print('Failed to setup hooks: ${hooksResult.stderr}');
  }

  Process.runSync('chmod', ['+x', '${Directory.current.path}/git-hooks/*']);

  print('Restore complete.');
}

void runSetup() {
  print('Running setup script...');
  if (!Platform.isMacOS) {
    print('Setup script is for macOS only.');
    exit(1);
  }

  // Check for sudo access
  final sudoCheck = Process.runSync('sudo', ['-n', 'true']);
  if (sudoCheck.exitCode != 0) {
    print(
        'Setup requires administrator privileges. Please run as admin or ensure sudo access.');
    exit(1);
  }

  final result = Process.runSync('/bin/bash', ['setup-mac.sh']);
  if (result.exitCode != 0) {
    print('Setup failed: ${result.stderr}');
    exit(1);
  }
  print('Setup complete.');
}

void showVersion() {
  final versionFile = File('VERSION');
  if (versionFile.existsSync()) {
    print(versionFile.readAsStringSync().trim());
  } else {
    print('Version file not found.');
  }
}
