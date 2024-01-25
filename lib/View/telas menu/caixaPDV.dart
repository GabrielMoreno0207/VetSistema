import 'package:flutter/material.dart';

class CaixaPDVPage extends StatefulWidget {
  @override
  _CaixaPDVPageState createState() => _CaixaPDVPageState();
}

class _CaixaPDVPageState extends State<CaixaPDVPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CAIXA PDV'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Produto'),
            Tab(text: 'Cliente'),
            Tab(text: 'Pagamento'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProdutoTab(),
          _buildClienteTab(),
          _buildPagamentoTab(),
        ],
      ),
    );
  }

  Widget _buildProdutoTab() {
    // Coloque aqui a sua implementação da aba Produto
    return Center(child: Text('Aba de Produtos'));
  }

  Widget _buildClienteTab() {
    // Coloque aqui a sua implementação da aba Cliente
    return Center(child: Text('Aba de Clientes'));
  }

  Widget _buildPagamentoTab() {
    // Coloque aqui a sua implementação da aba Pagamento
    return Center(child: Text('Aba de Pagamentos'));
  }
}
