import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PottyHistogram extends StatelessWidget {
  final List<int> peeCountByHour;
  final List<int> poopCountByHour;

  const PottyHistogram({
    super.key,
    required this.peeCountByHour,
    required this.poopCountByHour,
  });

  @override
  Widget build(BuildContext context) {
    // Filter nur Stunden, in denen es mindestens einen Event gibt
    final filteredIndices = List<int>.generate(
      24,
      (i) => i,
    ).where((i) => peeCountByHour[i] > 0 || poopCountByHour[i] > 0).toList();

    final barGroups = filteredIndices.map((i) {
      return BarChartGroupData(
        x: i,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: peeCountByHour[i].toDouble(),
            color: Colors.blue,
            width: 6,
          ),
          BarChartRodData(
            toY: poopCountByHour[i].toDouble(),
            color: Colors.brown,
            width: 6,
          ),
        ],
      );
    }).toList();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    interval: 3,
                    getTitlesWidget: (value, meta) {
                      int hour = value.toInt();
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('$hour'),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, interval: 1),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(color: Colors.blue, label: 'Pee'),
            const SizedBox(width: 24),
            _buildLegendItem(color: Colors.brown, label: 'Poop'),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
