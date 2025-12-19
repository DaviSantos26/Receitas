class Receita {
  final int? id;
  final String nome;
  final String categoria;
  final String ingredientes;
  final String modoPreparo;
  final String? tempoPreparo;
  final String? porcoes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Receita({
    this.id,
    required this.nome,
    required this.categoria,
    required this.ingredientes,
    required this.modoPreparo,
    this.tempoPreparo,
    this.porcoes,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'nome': nome,
      'categoria': categoria,
      'ingredientes': ingredientes,
      'modo_preparo': modoPreparo,
    };
    
    if (tempoPreparo != null) map['tempo_preparo'] = tempoPreparo;
    if (porcoes != null) map['porcoes'] = porcoes;
    
    return map;
  }

  factory Receita.fromMap(Map<String, dynamic> map) {
    return Receita(
      id: map['id'],
      nome: map['nome'] ?? '',
      categoria: map['categoria'] ?? '',
      ingredientes: map['ingredientes'] ?? '',
      modoPreparo: map['modo_preparo'] ?? '',
      tempoPreparo: map['tempo_preparo'],
      porcoes: map['porcoes'],
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : null,
      updatedAt: map['updated_at'] != null 
          ? DateTime.parse(map['updated_at']) 
          : null,
    );
  }
}