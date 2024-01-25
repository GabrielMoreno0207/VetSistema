import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:vetsistema/View/telas%20menu/agendamentoConsulta.dart';
import 'package:vetsistema/View/telas%20menu/cadastroCliente.dart';
import 'package:vetsistema/View/telas%20menu/cadastroMedicamentos.dart';
import 'package:vetsistema/View/telas%20menu/cadastroPaciente.dart';
import 'package:vetsistema/View/telas%20menu/controleFinanceiro.dart';
import 'package:vetsistema/View/telas%20menu/estatisticas.dart';
import 'package:vetsistema/View/telas%20menu/medicos.dart';
import 'package:vetsistema/View/telas%20menu/caixaPDV.dart';

void main() {
  runApp(const MaterialApp(
    home: PaginaPrincipal(),
  ));
}

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({Key? key});

  @override
  // ignore: library_private_types_in_public_api
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  final Widget _modalContent = Container(); // Conteúdo do modal
  Widget _selectedPageContent = Container(); // Conteúdo da página selecionada
  bool _showConsultationList = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sistema Veterinário',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 37, 160, 88),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              setState(() {
                _showConsultationList = true;
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/img1.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            _buildDrawerItem(
              context,
              'Cadastro de Pacientes',
              const CadastroPacientesPage(),
              Icons.pets,
            ),
            _buildDrawerItem(
              context,
              'Cadastro de Clientes',
              const CadastroClientePage(),
              Icons.people,
            ),
            _buildDrawerItem(
              context,
              'Cadastro de Medicamentos',
              const CadastroMedicamentoPage(),
              Icons.local_hospital,
            ),
            _buildDrawerItem(
              context,
              'Agendamento de Consultas',
              const AgendamentoConsultaPage(),
              Icons.event,
            ),
            _buildDrawerItem(
              context,
              'Controle Financeiro',
              ControleFinanceiroPage(),
              Icons.healing,
            ),
            _buildDrawerItem(
              context,
              'Procedimentos Realizados',
              CaixaPDVPage(),
              Icons.attach_money,
            ),
            _buildDrawerItem(
              context,
              'Médicos',
              MedicosPage(),
              Icons.health_and_safety_outlined,
            ),
            _buildDrawerItem(context, 'Estatisticas', EstatisticasPage(),
                Icons.auto_graph_sharp),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color.fromARGB(255, 37, 160, 88),
            child: _buildQuickAccessPanel(context),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Histórico de Consultas',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 37, 160, 88),
            ),
          ),
          Expanded(
            child: _showConsultationList
                ? _buildConsultationList() // Conteúdo da lista de consulta
                : _selectedPageContent, // Conteúdo da página selecionada
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessPanel(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickAccessCard(
          context,
          'CLIENTES',
          'Gerencie seus clientes',
          () {
            _showPageContent(const CadastroClientePage());
          },
          Icons.people,
        ),
        _buildQuickAccessCard(
          context,
          'PACIENTES',
          'Registre e visualize pacientes',
          () {
            _showPageContent(const CadastroPacientesPage());
          },
          Icons.pets,
        ),
        _buildQuickAccessCard(
          context,
          'MEDICAMENTOS',
          'Controle de medicamentos',
          () {
            _showPageContent(const CadastroMedicamentoPage());
          },
          Icons.local_hospital,
        ),
        _buildQuickAccessCard(
          context,
          'EQUIPAMENTOS',
          'Gestão de equipamentos',
          () {
            // Implemente a lógica para a Ação 4
          },
          Icons.settings,
        ),
        _buildQuickAccessCard(
          context,
          'AGENDAMENTO',
          'Agende consultas e serviços',
          () {
            _showPageContent(const AgendamentoConsultaPage());
          },
          Icons.event,
        ),
        _buildQuickAccessCard(
          context,
          'CAIXA',
          'Efetue vendas',
          () {
            _showPageContent(CaixaPDVPage());
          },
          Icons.monetization_on_rounded,
        ),
      ],
    );
  }

  Widget _buildQuickAccessCard(
    BuildContext context,
    String title,
    String description,
    VoidCallback onTap,
    IconData icon,
  ) {
    return Card(
      elevation: 5.0,
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 40,
                color: const Color.fromARGB(255, 37, 160, 88),
              ),
              const SizedBox(height: 8.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 37, 160, 88),
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                description,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, String title, Widget page, IconData icon) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Icon(icon),
      onTap: () {
        _showPageContent(page);
        Navigator.pop(context); // Fecha o drawer ao selecionar uma opção
      },
    );
  }

  Widget _buildConsultationList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('consultas').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final consultaDocs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: consultaDocs.length,
          itemBuilder: (BuildContext context, int index) {
            final consulta = consultaDocs[index].data() as Map<String, dynamic>;

            return _buildConsultationItem(context, consulta);
          },
        );
      },
    );
  }

  Widget _buildConsultationItem(
      BuildContext context, Map<String, dynamic> consulta) {
    final Timestamp dataConsulta = consulta['dataConsulta'] as Timestamp;
    final medico = consulta['medico'] as String;
    final nomePaciente = consulta['nomePaciente'] as String;

    // Use o método toDate() para converter o Timestamp em um objeto DateTime
    final dataConsultaFormatada =
        DateFormat('dd/MM/yyyy HH:mm').format(dataConsulta.toDate());

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 3.0,
        child: ListTile(
          title: Text(
            'Paciente: $nomePaciente',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle:
              Text('Data da Consulta: $dataConsultaFormatada\nMédico: $medico'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            color: const Color.fromARGB(255, 221, 12, 12),
            onPressed: () {
              // Implemente a lógica para excluir a consulta
            },
          ),
        ),
      ),
    );
  }

  // Função para atualizar o conteúdo da página selecionada
  void _showPageContent(Widget pageContent) {
    setState(() {
      _showConsultationList = false;
      _selectedPageContent = pageContent;
    });
  }
}
