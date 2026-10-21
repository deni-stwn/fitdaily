// Exports Figma nodes to figma-code/<slug>/ via the Figma REST API (no MCP).
//
// Usage:
//   export FIGMA_TOKEN=<personal access token>   # Figma → Settings → Security
//   dart run tool/figma_export.dart 683:53091 84:348
//   dart run tool/figma_export.dart "https://www.figma.com/design/<key>/x?node-id=683-53091"
//
// Output per node:
//   spec.txt        compact, human/AI-readable tree (sizes, auto-layout, colors, text styles, component instances)
//   node.json       raw REST response for the node
//   screenshot.png  PNG @2x
//   assets/         SVG for icon instances (`Variant=…` components), PNG @2x for image fills
import 'dart:convert';
import 'dart:io';

const _defaultFileKey = '0JJ9zgqULqqfGnLLwZx8kA';
const _api = 'https://api.figma.com/v1';

late final String _token;
final _client = HttpClient();

Future<void> main(List<String> args) async {
  // Offline: regenerate spec from a saved node.json (prints to stdout).
  if (args.length == 2 && args.first == '--from-json') {
    final entry =
        jsonDecode(await File(args[1]).readAsString()) as Map<String, dynamic>;
    final buffer = StringBuffer();
    _writeNode(
      buffer,
      entry['document'] as Map<String, dynamic>,
      null,
      0,
      (entry['components'] as Map<String, dynamic>?) ?? {},
      (entry['componentSets'] as Map<String, dynamic>?) ?? {},
      {},
      {},
    );
    stdout.write(buffer);
    return;
  }

  final token = Platform.environment['FIGMA_TOKEN'];
  if (token == null || token.isEmpty) {
    stderr.writeln('FIGMA_TOKEN is not set.');
    exit(64);
  }
  _token = token;
  if (args.isEmpty) {
    stderr.writeln(
      'Usage: dart run tool/figma_export.dart <node-id|figma-url>...',
    );
    exit(64);
  }

  var fileKey = _defaultFileKey;
  final ids = <String>[];
  for (final arg in args) {
    final uri = Uri.tryParse(arg);
    if (uri != null && uri.host.contains('figma.com')) {
      final segments = uri.pathSegments;
      final designIndex = segments.indexOf('design');
      if (designIndex >= 0 && designIndex + 1 < segments.length) {
        fileKey = segments[designIndex + 1];
      }
      final nodeId = uri.queryParameters['node-id'];
      if (nodeId != null) ids.add(nodeId.replaceAll('-', ':'));
    } else {
      ids.add(arg.replaceAll('-', ':'));
    }
  }

  try {
    final nodesJson = await _getJson(
      '$_api/files/$fileKey/nodes?ids=${Uri.encodeComponent(ids.join(','))}',
    );
    final nodes = nodesJson['nodes'] as Map<String, dynamic>;
    // One images call for all screenshots to save API quota.
    final screenshots = await _imageUrls(fileKey, ids, 'png', 2);

    for (final id in ids) {
      final entry = nodes[id] as Map<String, dynamic>?;
      if (entry == null) {
        stderr.writeln('Node $id not found.');
        continue;
      }
      await _exportNode(fileKey, id, entry, screenshots[id]);
    }
  } finally {
    _client.close();
  }
}

Future<void> _exportNode(
  String fileKey,
  String id,
  Map<String, dynamic> entry,
  String? screenshotUrl,
) async {
  final document = entry['document'] as Map<String, dynamic>;
  final components = (entry['components'] as Map<String, dynamic>?) ?? {};
  final componentSets = (entry['componentSets'] as Map<String, dynamic>?) ?? {};

  final slug = _slug(document['name'] as String);
  final dir = Directory('figma-code/$slug');
  final assetsDir = Directory('${dir.path}/assets');
  await assetsDir.create(recursive: true);

  await File(
    '${dir.path}/node.json',
  ).writeAsString(const JsonEncoder.withIndent('  ').convert(entry));

  final buffer = StringBuffer()
    ..writeln('# ${document['name']}  (node $id, file $fileKey)')
    ..writeln('# Sizes in px (Figma frame units). Colors #RRGGBBAA.')
    ..writeln();
  final icons = <String, String>{}; // nodeId -> file name
  final images = <String, String>{};
  _writeNode(
    buffer,
    document,
    null,
    0,
    components,
    componentSets,
    icons,
    images,
  );
  await File('${dir.path}/spec.txt').writeAsString(buffer.toString());

  // Screenshot @2x.
  if (screenshotUrl != null) {
    await _download(screenshotUrl, '${dir.path}/screenshot.png');
  }

  // Assets.
  if (icons.isNotEmpty) {
    final urls = await _imageUrls(fileKey, icons.keys.toList(), 'svg', 1);
    for (final e in icons.entries) {
      final url = urls[e.key];
      if (url != null) await _download(url, '${assetsDir.path}/${e.value}');
    }
  }
  if (images.isNotEmpty) {
    final urls = await _imageUrls(fileKey, images.keys.toList(), 'png', 2);
    for (final e in images.entries) {
      final url = urls[e.key];
      if (url != null) await _download(url, '${assetsDir.path}/${e.value}');
    }
  }

  final notes = File('${dir.path}/notes.md');
  if (!await notes.exists()) {
    await notes.writeAsString(
      '# ${document['name']}\n\n- Node: `$id`\n- Interaksi / state: _(isi manual)_\n',
    );
  }

  stdout.writeln(
    '✓ ${dir.path}  (${icons.length} svg, ${images.length} image assets)',
  );
}

void _writeNode(
  StringBuffer out,
  Map<String, dynamic> node,
  Map<String, dynamic>? parent,
  int depth,
  Map<String, dynamic> components,
  Map<String, dynamic> componentSets,
  Map<String, String> icons,
  Map<String, String> images,
) {
  if (node['visible'] == false) return;

  final indent = '  ' * depth;
  final type = node['type'] as String;
  final name = node['name'] as String;
  final box = node['absoluteBoundingBox'] as Map<String, dynamic>?;
  final parentBox = parent?['absoluteBoundingBox'] as Map<String, dynamic>?;

  final parts = <String>['$type "$name"'];
  if (box != null) {
    parts.add('${_n(box['width'])}x${_n(box['height'])}');
    if (parentBox != null) {
      parts.add(
        '@(${_n((box['x'] as num) - (parentBox['x'] as num))},'
        '${_n((box['y'] as num) - (parentBox['y'] as num))})',
      );
    }
  }

  // Component instance → which component (key for reusing widgets).
  String? componentName;
  if (type == 'INSTANCE') {
    final component = components[node['componentId']] as Map<String, dynamic>?;
    if (component != null) {
      final setId = component['componentSetId'] as String?;
      final setName =
          (componentSets[setId] as Map<String, dynamic>?)?['name'] as String?;
      componentName = component['name'] as String;
      parts.add(
        'component=${setName != null ? '"$setName" ' : ''}[$componentName]',
      );
    }
  }

  // Auto-layout.
  final layout = node['layoutMode'] as String?;
  if (layout != null && layout != 'NONE') {
    parts.add(
      'layout=$layout gap=${_n(node['itemSpacing'] ?? 0)} '
      'pad=${_n(node['paddingTop'] ?? 0)},${_n(node['paddingRight'] ?? 0)},'
      '${_n(node['paddingBottom'] ?? 0)},${_n(node['paddingLeft'] ?? 0)} '
      'main=${node['primaryAxisAlignItems'] ?? 'MIN'} '
      'cross=${node['counterAxisAlignItems'] ?? 'MIN'}',
    );
  }
  if (node['layoutSizingHorizontal'] != null) {
    parts.add(
      'sizing=${node['layoutSizingHorizontal']}/${node['layoutSizingVertical']}',
    );
  }

  final fills = _paints(node['fills']);
  if (fills.isNotEmpty) parts.add('fill=$fills');
  final strokes = _paints(node['strokes']);
  if (strokes.isNotEmpty) {
    parts.add(
      'stroke=$strokes w=${_n(node['strokeWeight'] ?? 1)} '
      '${node['strokeAlign'] ?? ''}',
    );
  }
  final radii = node['rectangleCornerRadii'] as List?;
  if (radii != null) {
    parts.add('radius=${radii.map(_n).join(',')}');
  } else if (node['cornerRadius'] != null) {
    parts.add('radius=${_n(node['cornerRadius'])}');
  }
  if ((node['opacity'] as num?) != null && node['opacity'] != 1) {
    parts.add('opacity=${_n(node['opacity'])}');
  }
  final effects = _effects(node['effects']);
  if (effects.isNotEmpty) parts.add('effects=$effects');
  if (node['blendMode'] != null &&
      node['blendMode'] != 'PASS_THROUGH' &&
      node['blendMode'] != 'NORMAL') {
    parts.add('blend=${node['blendMode']}');
  }

  if (type == 'TEXT') {
    final style = node['style'] as Map<String, dynamic>? ?? {};
    parts.add(
      'text=${jsonEncode(node['characters'])} '
      'font="${style['fontFamily']}" ${_n(style['fontSize'])}/'
      '${_n(style['lineHeightPx'])} w${_n(style['fontWeight'])} '
      'ls=${_n(style['letterSpacing'] ?? 0)} '
      'align=${style['textAlignHorizontal'] ?? 'LEFT'}',
    );
  }

  // Asset collection.
  // Icon components are named `Variant=<icon>, Type=<style>` and are small;
  // UI components (e.g. Button `Variant=Default, State=…`) must not match.
  final isIcon =
      componentName != null &&
      componentName.startsWith('Variant=') &&
      componentName.contains('Type=') &&
      box != null &&
      (box['width'] as num) <= 64 &&
      (box['height'] as num) <= 64;
  if (isIcon) {
    icons[node['id'] as String] = '${_slug(componentName)}.svg';
    parts.add('→ asset ${icons[node['id']]}');
  }
  final hasImageFill = (node['fills'] as List? ?? const []).any(
    (f) => (f as Map)['type'] == 'IMAGE' && f['visible'] != false,
  );
  if (hasImageFill) {
    images[node['id'] as String] = '${_slug(name)}_${_slug(node['id'])}.png';
    parts.add('→ asset ${images[node['id']]}');
  }

  out.writeln('$indent${parts.join('  ')}');

  // Icons are exported as a whole — no need to describe their vectors.
  if (isIcon) return;
  for (final child in (node['children'] as List? ?? const [])) {
    _writeNode(
      out,
      child as Map<String, dynamic>,
      node,
      depth + 1,
      components,
      componentSets,
      icons,
      images,
    );
  }
}

String _paints(dynamic paints) {
  final list = (paints as List? ?? const [])
      .cast<Map<String, dynamic>>()
      .where((p) => p['visible'] != false)
      .map((p) {
        final type = p['type'] as String;
        final opacity = (p['opacity'] as num?) ?? 1;
        if (type == 'SOLID') {
          return _hex(p['color'] as Map<String, dynamic>, opacity);
        }
        if (type.startsWith('GRADIENT')) {
          final stops = (p['gradientStops'] as List)
              .cast<Map<String, dynamic>>()
              .map(
                (s) =>
                    '${_hex(s['color'] as Map<String, dynamic>, opacity)}@${_n(s['position'])}',
              )
              .join(' ');
          return '$type($stops)';
        }
        return type;
      });
  return list.join(' + ');
}

String _effects(dynamic effects) {
  return (effects as List? ?? const [])
      .cast<Map<String, dynamic>>()
      .where((e) => e['visible'] != false)
      .map((e) {
        final type = e['type'] as String;
        if (type.endsWith('BLUR')) return '$type(${_n(e['radius'])})';
        final offset = e['offset'] as Map<String, dynamic>? ?? {};
        return '$type(${_hex(e['color'] as Map<String, dynamic>, 1)} '
            '${_n(offset['x'] ?? 0)},${_n(offset['y'] ?? 0)} '
            'r${_n(e['radius'])} s${_n(e['spread'] ?? 0)})';
      })
      .join(' + ');
}

String _hex(Map<String, dynamic> c, num opacity) {
  String ch(num v) => (v * 255).round().toRadixString(16).padLeft(2, '0');
  final a = ((c['a'] as num?) ?? 1) * opacity;
  return '#${ch(c['r'] as num)}${ch(c['g'] as num)}${ch(c['b'] as num)}${ch(a)}'
      .toUpperCase();
}

String _n(dynamic v) {
  if (v is! num) return '$v';
  final rounded = (v * 100).round() / 100;
  return rounded == rounded.roundToDouble()
      ? rounded.toInt().toString()
      : rounded.toString();
}

String _slug(String s) => s
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
    .replaceAll(RegExp(r'^_+|_+$'), '');

Future<Map<String, String?>> _imageUrls(
  String fileKey,
  List<String> ids,
  String format,
  num scale,
) async {
  final result = <String, String?>{};
  // REST API accepts many ids per call; chunk to keep URLs short.
  for (var i = 0; i < ids.length; i += 50) {
    final chunk = ids.sublist(i, i + 50 > ids.length ? ids.length : i + 50);
    final json = await _getJson(
      '$_api/images/$fileKey?ids=${Uri.encodeComponent(chunk.join(','))}'
      '&format=$format&scale=$scale',
    );
    (json['images'] as Map<String, dynamic>).forEach(
      (k, v) => result[k] = v as String?,
    );
  }
  return result;
}

Future<Map<String, dynamic>> _getJson(String url) async {
  final request = await _client.getUrl(Uri.parse(url));
  request.headers.set('X-Figma-Token', _token);
  final response = await request.close();
  final body = await response.transform(utf8.decoder).join();
  if (response.statusCode != 200) {
    throw HttpException('Figma API ${response.statusCode}: $body');
  }
  return jsonDecode(body) as Map<String, dynamic>;
}

Future<void> _download(String url, String path) async {
  final request = await _client.getUrl(Uri.parse(url));
  final response = await request.close();
  await response.pipe(File(path).openWrite());
}
