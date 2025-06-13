import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoPizza extends StatelessWidget {
  final double totalReceitas;
  final double totalDespesas;

  const GraficoPizza({
    super.key,
    required this.totalReceitas,
    required this.totalDespesas,
  });

  @override
  Widget build(BuildContext context) {
    final total = totalReceitas + totalDespesas;
    if (total == 0) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Nenhum dado para mostrar no gráfico.'),
      );
    }

    return Card(
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          const SizedBox(height: 12),
          const Text(
            'Distribuição de Gastos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.green,
                    value: totalReceitas,
                    title:
                        'Receitas\n${(totalReceitas / total * 100).toStringAsFixed(1)}%',
                    radius: 60,
                    titleStyle:
                        const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: totalDespesas,
                    title:
                        'Despesas\n${(totalDespesas / total * 100).toStringAsFixed(1)}%',
                    radius: 60,
                    titleStyle:
                        const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
                centerSpaceRadius: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
