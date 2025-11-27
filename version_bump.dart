import 'dart:io';

void main(List<String> args) {
  final bumpType = args.isNotEmpty ? args[0] : 'patch';

  final versionFile = File('VERSION');
  if (!versionFile.existsSync()) {
    print('VERSION file not found');
    exit(1);
  }

  final currentVersion = versionFile.readAsStringSync().trim();
  final parts = currentVersion.split('.');
  if (parts.length != 3) {
    print('Invalid version format');
    exit(1);
  }

  var major = int.parse(parts[0]);
  var minor = int.parse(parts[1]);
  var patch = int.parse(parts[2]);

  switch (bumpType) {
    case 'major':
      major++;
      minor = 0;
      patch = 0;
      break;
    case 'minor':
      minor++;
      patch = 0;
      break;
    case 'patch':
    default:
      patch++;
      break;
  }

  final newVersion = '$major.$minor.$patch';
  versionFile.writeAsStringSync('$newVersion\n');

  print('Version bumped from $currentVersion to $newVersion ($bumpType)');
}
