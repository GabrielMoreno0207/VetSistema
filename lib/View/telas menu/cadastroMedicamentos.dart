import 'package:flutter/material.dart';

class CadastroMedicamentoPage extends StatefulWidget {
  const CadastroMedicamentoPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CadastroMedicamentoPageState createState() =>
      _CadastroMedicamentoPageState();
}

class _CadastroMedicamentoPageState extends State<CadastroMedicamentoPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _indicacoesController = TextEditingController();
  final TextEditingController _contraindicacoesController =
      TextEditingController();
  final TextEditingController _posologiaController = TextEditingController();
  final TextEditingController _formaAdministracaoController =
      TextEditingController();
  final TextEditingController _efeitosColateraisController =
      TextEditingController();
  final TextEditingController _interacoesMedicamentosasController =
      TextEditingController();
  final TextEditingController _tempoAcaoController = TextEditingController();
  final TextEditingController _armazenamentoController =
      TextEditingController();
  final TextEditingController _dataValidadeController = TextEditingController();
  final TextEditingController _fabricanteController = TextEditingController();
  final TextEditingController _numeroLoteRegistroController =
      TextEditingController();
  final TextEditingController _precaucoesController = TextEditingController();
  final TextEditingController _infoClientesController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _medicamentoCadastrado = false;
  String? _selectedTipoMedicamento;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Medicamento'),
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
                  _buildRow([
                    _buildTextFormField('Nome', _nomeController),
                    _buildDropdown(
                        'Tipo de Medicamento',
                        _selectedTipoMedicamento,
                        _tipoMedicamentoList,
                        _onTipoMedicamentoChanged),
                  ]),
                  _buildRow([
                    _buildTextFormField('Indicações', _indicacoesController),
                    _buildTextFormField(
                        'Contraindicações', _contraindicacoesController),
                  ]),
                  _buildRow([
                    _buildTextFormField('Posologia', _posologiaController),
                    _buildTextFormField('Forma de Administração',
                        _formaAdministracaoController),
                  ]),
                  _buildRow([
                    _buildTextFormField(
                        'Efeitos Colaterais', _efeitosColateraisController),
                    _buildTextFormField('Interações Medicamentosas',
                        _interacoesMedicamentosasController),
                  ]),
                  _buildRow([
                    _buildTextFormField('Tempo de Ação', _tempoAcaoController),
                    _buildTextFormField(
                        'Armazenamento', _armazenamentoController),
                  ]),
                  _buildRow([
                    _buildTextFormField(
                        'Data de Validade', _dataValidadeController),
                    _buildTextFormField('Fabricante', _fabricanteController),
                  ]),
                  _buildRow([
                    _buildTextFormField('Número de Lote e Registro',
                        _numeroLoteRegistroController),
                    _buildTextFormField('Precauções', _precaucoesController),
                  ]),
                  _buildTextFormField(
                      'Informações para Clientes', _infoClientesController),
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
                  if (_medicamentoCadastrado)
                    const Text(
                      'Medicamento Cadastrado',
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget _buildDropdown(String label, String? value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              color: Color.fromARGB(255, 37, 160, 88),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 37, 160, 88)),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, selecione uma opção';
            }
            return null;
          },
        ),
      ),
    );
  }

  void _onTipoMedicamentoChanged(String? value) {
    setState(() {
      _selectedTipoMedicamento = value;
    });
  }

  void _salvarCadastro() {
    if (_formKey.currentState?.validate() ?? false) {
      // Realize a lógica de salvar o cadastro aqui

      // Limpar os campos após o cadastro
      _nomeController.clear();
      _indicacoesController.clear();
      _contraindicacoesController.clear();
      _posologiaController.clear();
      _formaAdministracaoController.clear();
      _efeitosColateraisController.clear();
      _interacoesMedicamentosasController.clear();
      _tempoAcaoController.clear();
      _armazenamentoController.clear();
      _dataValidadeController.clear();
      _fabricanteController.clear();
      _numeroLoteRegistroController.clear();
      _precaucoesController.clear();
      _infoClientesController.clear();

      // Atualizar o estado para exibir a mensagem
      setState(() {
        _medicamentoCadastrado = true;
      });

      // Ocultar a mensagem após alguns segundos (opcional)
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _medicamentoCadastrado = false;
        });
      });
    }
  }

  // Lista de tipos de medicamentos
  final List<String> _tipoMedicamentoList = [
    'Antibióticos',
    'Anti-inflamatórios',
    'Analgésicos',
    'Antiparasitários',
    'Anti-helmínticos',
    'Medicamentos cardíacos',
    'Medicamentos dermatológicos',
    'Medicamentos oftálmicos',
    'Medicamentos endócrinos',
    'Vacinas',
    'Suplementos nutricionais',
    'Sedativos e anestésicos',
  ];
}
