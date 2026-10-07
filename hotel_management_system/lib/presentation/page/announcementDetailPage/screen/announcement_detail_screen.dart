import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../domain/entitise/announcement_entitise.dart';
import '../../../../util/widget/core/constants.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  const AnnouncementDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! AnnouncementEntitise) {
      return const Scaffold(
        body: Center(child: Text('ไม่พบข้อมูลข่าวสาร')),
      );
    }

    final announcement = args;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('ข่าวสารและประชาสัมพันธ์'),
        backgroundColor: Constants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (announcement.imageUrl.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Constants.borderRadius),
                      child: Image.network(
                        announcement.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(
                          height: 180,
                          child: Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 48,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Constants.primaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Text(
                        announcement.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1.45,
                        ),
                      ),
                      if (announcement.content.trim().isNotEmpty) ...[
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F8),
                            borderRadius:
                                BorderRadius.circular(Constants.borderRadius),
                          ),
                          child: _AnnouncementContent(announcement.content),
                        ),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final _urlPattern =
    RegExp(r'(https?://[^\s]+|www\.[^\s]+)', caseSensitive: false);

Future<void> _openLink(String url) async {
  final fixed = url.startsWith('http') ? url : 'https://$url';
  final uri = Uri.tryParse(fixed);
  if (uri == null) return;
  await launchUrl(uri, mode: LaunchMode.inAppWebView);
}

class _LinkText extends StatefulWidget {
  final String text;

  const _LinkText(this.text);

  @override
  State<_LinkText> createState() => _LinkTextState();
}

class _LinkTextState extends State<_LinkText> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();

    const baseStyle =
        TextStyle(fontSize: 16, height: 1.6, color: Colors.black87);
    final spans = <InlineSpan>[];
    var last = 0;
    for (final m in _urlPattern.allMatches(widget.text)) {
      if (m.start > last) {
        spans.add(TextSpan(text: widget.text.substring(last, m.start)));
      }
      final url = m.group(0)!;
      final recognizer = TapGestureRecognizer()..onTap = () => _openLink(url);
      _recognizers.add(recognizer);
      spans.add(TextSpan(
        text: url,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
        recognizer: recognizer,
      ));
      last = m.end;
    }
    if (last < widget.text.length) {
      spans.add(TextSpan(text: widget.text.substring(last)));
    }
    return Text.rich(TextSpan(style: baseStyle, children: spans));
  }
}

class _LinkCard extends StatelessWidget {
  final String url;

  const _LinkCard(this.url);

  @override
  Widget build(BuildContext context) {
    final fixed = url.startsWith('http') ? url : 'https://$url';
    final host = Uri.tryParse(fixed)?.host.replaceFirst('www.', '') ?? url;
    return InkWell(
      onTap: () => _openLink(url),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.link, color: Constants.primaryColor),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    host.toUpperCase(),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    url,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.open_in_new, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _AnnouncementContent extends StatelessWidget {
  final String content;

  const _AnnouncementContent(this.content);

  @override
  Widget build(BuildContext context) {
    final lines = content
        .replaceAll('\r\n', '\n')
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: lines.map((line) {
        final isBullet = line.startsWith('- ') ||
            line.startsWith('• ') ||
            line.startsWith('* ');
        final text = isBullet ? line.substring(2).trim() : line;
        final onlyUrl = _urlPattern.firstMatch(text)?.group(0) == text;
        final textWidget =
            onlyUrl && !isBullet ? _LinkCard(text) : _LinkText(text);

        if (!isBullet) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: textWidget,
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 10, top: 1),
                child: Text(
                  '•',
                  style: TextStyle(
                    color: Constants.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(child: textWidget),
            ],
          ),
        );
      }).toList(),
    );
  }
}
