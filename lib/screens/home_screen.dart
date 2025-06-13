import 'package:flutter/material.dart';
import '../models/transacao.dart';
import 'add_transacao_screen.dart';
import '../widgets/grafico_pizza.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Transacao> _transacoes = [];

  void _addTransacao(String descricao, double valor, String tipo) {
    final nova = Transacao(
      id: Random().nextDouble().toString(),
      descricao: descricao,
      valor: valor,
      tipo: tipo,
      data: DateTime.now(),
    );

    setState(() {
      _transacoes.add(nova);
    });
  }

  double get _saldo {
    return _transacoes.fold(0.0, (soma, t) {
      return t.tipo == 'receita' ? soma + t.valor : soma - t.valor;
    });
  }

  double get _totalReceitas => _transacoes
      .where((t) => t.tipo == 'receita')
      .fold(0.0, (soma, t) => soma + t.valor);

  double get _totalDespesas => _transacoes
      .where((t) => t.tipo == 'despesa')
      .fold(0.0, (soma, t) => soma + t.valor);

  void _abrirNovaTransacao(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddTransacaoScreen(onAdd: _addTransacao),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gastos Mensais'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Saldo Atual',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'R\$ ${_saldo.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 26,
                      color: _saldo >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GraficoPizza(
            totalReceitas: _totalReceitas,
            totalDespesas: _totalDespesas,
          ),
          Expanded(
            child: _transacoes.isEmpty
                ? const Center(child: Text('Nenhuma transação ainda.'))
                : ListView.builder(
                    itemCount: _transacoes.length,
                    itemBuilder: (ctx, i) {
                      final t = _transacoes[i];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              t.tipo == 'receita' ? Colors.green : Colors.red,
                          child: Icon(
                            t.tipo == 'receita'
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(t.descricao),
                        subtitle: Text(
                            '${t.data.day}/${t.data.month}/${t.data.year}'),
                        trailing: Text(
                          'R\$ ${t.valor.toStringAsFixed(2)}',
                          style: TextStyle(
                            color:
                                t.tipo == 'receita' ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirNovaTransacao(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
