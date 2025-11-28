import 'package:dashed_divider/dashed_divider.dart';
import 'package:flutter/material.dart';

void main() => runApp(const DashedDividerExampleApp());

class DashedDividerExampleApp extends StatelessWidget {
  const DashedDividerExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashed Divider Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashed Divider Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionTitle('Horizontal – default settings'),
          const DashedDivider(),
          const SizedBox(height: 16),
          const _SectionTitle('Custom dash length, gap, and thickness'),
          const DashedDivider(dashLength: 10, dashGap: 6, thickness: 3, color: Colors.indigo),
          const SizedBox(height: 16),
          const _SectionTitle('Rounded caps with margin and fixed length'),
          Align(
            child: DashedDivider(
              length: 200,
              dashLength: 14,
              dashGap: 4,
              thickness: 4,
              color: Colors.orange,
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Dense divider for subtle separation'),
          const DashedDivider(dashLength: 4, dashGap: 2, thickness: 1, color: Color(0xFFBDBDBD)),
          const SizedBox(height: 24),
          const _SectionTitle('Vertical usage inside a row'),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Left content'),
                  ),
                ),
                const SizedBox(width: 16),
                const DashedDivider(
                  axis: Axis.vertical,
                  dashLength: 12,
                  dashGap: 6,
                  thickness: 2,
                  color: Colors.teal,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Right content'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
