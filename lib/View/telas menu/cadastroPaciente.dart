import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroPacientesPage extends StatefulWidget {
  const CadastroPacientesPage({Key? key}) : super(key: key);

  @override
  _CadastroPacientesPageState createState() => _CadastroPacientesPageState();
}

class _CadastroPacientesPageState extends State<CadastroPacientesPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _racaController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _responsavelController = TextEditingController();
  final TextEditingController _especieController = TextEditingController();
  final TextEditingController _corController = TextEditingController();
  final TextEditingController _nascimentoController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  final TextEditingController _identificacaoController =
      TextEditingController();
  final TextEditingController _medicamentosController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _pacienteCadastrado = false;

  // Referência à coleção 'Cadpacientes' no Firestore
  final CollectionReference cadPacientesCollection =
      FirebaseFirestore.instance.collection('Cadpacientes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Pacientes'),
        backgroundColor: const Color.fromARGB(255, 37, 160, 88),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildHeader('Informações do Paciente'),
                  _buildRow([
                    _buildTextFormField('Nome', _nomeController),
                    _buildTextFormField('Raça', _racaController),
                    _buildTextFormField('Idade', _idadeController),
                    _buildTextFormField('Peso', _pesoController),
                    _buildTextFormField('Espécie', _especieController),
                  ]),
                  _buildRow([
                    _buildTextFormField('Cor', _corController),
                    _buildTextFormField(
                        'Nascimento (opcional)', _nascimentoController),
                    _buildTextFormField('Gênero', _generoController),
                  ]),
                  _buildRow([
                    _buildTextFormField('Número de Identificação (microchip)',
                        _identificacaoController),
                    _buildTextFormField(
                        'Faz uso de Medicamentos?', _medicamentosController),
                  ]),
                  _buildHeader('Informações do Responsável'),
                  _buildRow([
                    _buildTextFormField('Responsável', _responsavelController),
                  ]),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _salvarCadastro();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 37, 160, 88),
                      minimumSize: const Size(150, 50), // Tamanho proporcional
                    ),
                    child: const Text('Salvar'),
                  ),
                  const SizedBox(height: 16),
                  if (_pacienteCadastrado)
                    const Text(
                      'Paciente Cadastrado',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String labelText) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
      child: Text(
        labelText,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 37, 160, 88),
        ),
      ),
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: children,
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              color: Color.fromARGB(255, 37, 160, 88),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 37, 160, 88)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, preencha este campo';
            }
            return null;
          },
        ),
      ),
    );
  }

  void _salvarCadastro() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Salvar os dados no Firestore
        await cadPacientesCollection.add({
          'nome': _nomeController.text.trim(),
          'raca': _racaController.text.trim(),
          'idade': _idadeController.text.trim(),
          'peso': _pesoController.text.trim(),
          'responsavel': _responsavelController.text.trim(),
          'especie': _especieController.text.trim(),
          'cor': _corController.text.trim(),
          'nascimento': _nascimentoController.text.trim(),
          'genero': _generoController.text.trim(),
          'identificacao': _identificacaoController.text.trim(),
          'medicamentos': _medicamentosController.text.trim(),
        });

        // Limpar os campos após o cadastro
        _nomeController.clear();
        _racaController.clear();
        _idadeController.clear();
        _pesoController.clear();
        _responsavelController.clear();
        _especieController.clear();
        _corController.clear();
        _nascimentoController.clear();
        _generoController.clear();
        _identificacaoController.clear();
        _medicamentosController.clear();

        // Atualizar o estado para exibir a mensagem
        setState(() {
          _pacienteCadastrado = true;
        });

        // Ocultar a mensagem após alguns segundos (opcional)
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            _pacienteCadastrado = false;
          });
        });
      } catch (e) {
        print('Erro ao salvar no Firestore: $e');
      }
    }
  }
}
