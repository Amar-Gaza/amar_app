import 'dart:io';

final _patterns = <RegExp>[
  RegExp(r'pk_(test|live|preview)_[A-Za-z0-9]+'),
  RegExp(r'Bearer\s+[A-Za-z0-9._-]{20,}'),
  RegExp(r'-----BEGIN [A-Z ]*PRIVATE KEY-----'),
];

Future<void> main() async {
  final tracked = await Process.run('git', ['ls-files']);
  var failed = false;
  for (final path in (tracked.stdout as String).split('\n')) {
    final file = File(path);
    if (path.isEmpty || !file.existsSync() || path.endsWith('.png')) continue;
    final text = file.readAsStringSync();
    for (final p in _patterns) {
      if (p.hasMatch(text)) {
        stderr.writeln('Secret pattern in $path');
        failed = true;
      }
    }
  }
  exit(failed ? 1 : 0);
}
