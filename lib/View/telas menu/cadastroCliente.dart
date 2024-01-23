import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroClientePage extends StatefulWidget {
  const CadastroClientePage({Key? key}) : super(key: key);

  @override
  _CadastroClientePageState createState() => _CadastroClientePageState();
}

class _CadastroClientePageState extends State<CadastroClientePage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _formasPagamentoController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _clienteCadastrado = false;

  // Referência à coleção 'Cadclientes' no Firestore
  final CollectionReference cadClientesCollection =
      FirebaseFirestore.instance.collection('Cadclientes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Clientes'),
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
                  _buildHeader('Informações do Cliente'),
                  _buildRow([
                    _buildTextFormField('Nome', _nomeController),
                    _buildTextFormField('Endereço', _enderecoController),
                    _buildTextFormField('Telefone', _telefoneController),
                    _buildTextFormField('E-mail', _emailController),
                    _buildTextFormField('Formas de Pagamento (opcional)',
                        _formasPagamentoController),
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
                  if (_clienteCadastrado)
                    const Text(
                      'Cliente Cadastrado',
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
        await cadClientesCollection.add({
          'nome': _nomeController.text.trim(),
          'endereco': _enderecoController.text.trim(),
          'telefone': _telefoneController.text.trim(),
          'email': _emailController.text.trim(),
          'formasPagamento': _formasPagamentoController.text.trim(),
        });

        // Limpar os campos após o cadastro
        _nomeController.clear();
        _enderecoController.clear();
        _telefoneController.clear();
        _emailController.clear();
        _formasPagamentoController.clear();

        // Atualizar o estado para exibir a mensagem
        setState(() {
          _clienteCadastrado = true;
        });

        // Ocultar a mensagem após alguns segundos (opcional)
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            _clienteCadastrado = false;
          });
        });
      } catch (e) {
        print('Erro ao salvar no Firestore: $e');
      }
    }
  }
}
