class Transacao {
  final String id;
  final String descricao;
  final double valor;
  final String tipo; // 'receita' ou 'despesa'
  final DateTime data;

  Transacao({
    required this.id,
    required this.descricao,
    required this.valor,
    required this.tipo,
    required this.data,
  });
}
