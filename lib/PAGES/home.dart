import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receitas/features/categorias.dart';
import 'package:receitas/providers/receita_provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: Consumer<ReceitaProvider>(
          builder: (context, provider, child) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  height: 100,
                  color: Colors.green,
                  child: const DrawerHeader(
                    decoration: BoxDecoration(),
                    child: Text(
                      'Categorias',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                _buildCategoryTile(
                  context,
                  provider,
                  Icons.cake,
                  'Bolos e Tortas',
                ),
                _buildCategoryTile(
                  context,
                  provider,
                  Icons.ramen_dining,
                  'Carnes',
                ),
                _buildCategoryTile(context, provider, Icons.egg, 'Aves'),
                _buildCategoryTile(
                  context,
                  provider,
                  Icons.set_meal,
                  'Peixes e Frutos do Mar',
                ),
                _buildCategoryTile(
                  context,
                  provider,
                  Icons.local_florist,
                  'Saladas e Molhos',
                ),
                _buildCategoryTile(
                  context,
                  provider,
                  Icons.soup_kitchen,
                  'Sopas',
                ),
                _buildCategoryTile(
                  context,
                  provider,
                  Icons.local_pizza,
                  'Massas',
                ),
                _buildCategoryTile(
                  context,
                  provider,
                  Icons.local_drink,
                  'Bebidas',
                ),
                _buildCategoryTile(
                  context,
                  provider,
                  Icons.icecream,
                  'Doces e Sobremesas',
                ),
                _buildCategoryTile(
                  context,
                  provider,
                  Icons.fastfood,
                  'Lanches',
                ),
                _buildCategoryTile(
                  context,
                  provider,
                  Icons.grass,
                  'Alimentação saudável',
                ),
              ],
            );
          },
        ),
      ),
      body: Consumer<ReceitaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final totalReceitas = provider.receitas.length;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bem-vindo ao App de Receitas!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Text(
                  'Total de receitas: $totalReceitas',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      _buildCategoryCard(
                        provider,
                        Icons.cake,
                        'Bolos e Tortas',
                      ),
                      _buildCategoryCard(
                        provider,
                        Icons.ramen_dining,
                        'Carnes',
                      ),
                      _buildCategoryCard(provider, Icons.egg, 'Aves'),
                      _buildCategoryCard(
                        provider,
                        Icons.set_meal,
                        'Peixes e Frutos do Mar',
                      ),
                      _buildCategoryCard(
                        provider,
                        Icons.local_florist,
                        'Saladas e Molhos',
                      ),
                      _buildCategoryCard(provider, Icons.soup_kitchen, 'Sopas'),
                      _buildCategoryCard(provider, Icons.local_pizza, 'Massas'),
                      _buildCategoryCard(
                        provider,
                        Icons.local_drink,
                        'Bebidas',
                      ),
                      _buildCategoryCard(
                        provider,
                        Icons.icecream,
                        'Doces e Sobremesas',
                      ),
                      _buildCategoryCard(provider, Icons.fastfood, 'Lanches'),
                      _buildCategoryCard(
                        provider,
                        Icons.grass,
                        'Alimentação saudável',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryTile(
    BuildContext context,
    ReceitaProvider provider,
    IconData icon,
    String titulo,
  ) {
    final count = provider.getReceitasPorCategoria(titulo).length;
    return ListTile(
      leading: Icon(icon),
      title: Text(titulo),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '$count',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Categorias(titulo: titulo)),
        );
      },
    );
  }

  Widget _buildCategoryCard(
    ReceitaProvider provider,
    IconData icon,
    String titulo,
  ) {
    final count = provider.getReceitasPorCategoria(titulo).length;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.green, size: 28),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: count > 0 ? Colors.green : Colors.grey,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
