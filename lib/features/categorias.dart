import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receitas/PAGES/adicionar_receita.dart';
import 'package:receitas/providers/receita_provider.dart';

class Categorias extends StatelessWidget {
  const Categorias({super.key, required this.titulo});
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Consumer<ReceitaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final receitas = provider.getReceitasPorCategoria(titulo);

          if (receitas.isEmpty) {
            return const Center(
              child: Text('Nenhuma receita disponível nesta categoria.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: receitas.length,
            itemBuilder: (context, index) {
              final receita = receitas[index];
              return Card(
                child: ListTile(
                  title: Text(receita.nome),
                  subtitle: Text(
                    receita.tempoPreparo != null 
                        ? 'Tempo: ${receita.tempoPreparo}' 
                        : '',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirmar = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Confirmar exclusão'),
                          content: Text('Deseja excluir a receita "${receita.nome}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Excluir'),
                            ),
                          ],
                        ),
                      );

                      if (confirmar == true && receita.id != null) {
                        await provider.deletarReceita(receita.id!);
                      }
                    },
                  ),
                  onTap: () {
                    // Aqui você pode navegar para uma página de detalhes
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(receita.nome),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (receita.tempoPreparo != null) ...[
                                const Text('Tempo de Preparo:', 
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(receita.tempoPreparo!),
                                const SizedBox(height: 8),
                              ],
                              if (receita.porcoes != null) ...[
                                const Text('Porções:', 
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(receita.porcoes!),
                                const SizedBox(height: 8),
                              ],
                              const Text('Ingredientes:', 
                                style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(receita.ingredientes),
                              const SizedBox(height: 8),
                              const Text('Modo de Preparo:', 
                                style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(receita.modoPreparo),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Fechar'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdicionarReceitaPage(categoria: titulo),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}