import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicosPage extends StatefulWidget {
  @override
  _MedicosPageState createState() => _MedicosPageState();
}

class _MedicosPageState extends State<MedicosPage> {
  final TextEditingController _cpfRgController = TextEditingController();
  final TextEditingController _crmvController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _especializacaoController =
      TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  final CollectionReference medicosCollection =
      FirebaseFirestore.instance.collection('medicos');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Médicos'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildTextFormField('Nome', _nomeController),
                  _buildTextFormField('CPF/RG', _cpfRgController),
                  _buildTextFormField('CRMV', _crmvController),
                  _buildTextFormField(
                      'Data de Nascimento', _dataNascimentoController),
                  _buildTextFormField('Email', _emailController),
                  _buildTextFormField(
                      'Especialização', _especializacaoController),
                  _buildTextFormField('Gênero', _generoController),
                  _buildTextFormField('Telefone', _telefoneController),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _salvarCadastro();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 37, 160, 88),
                      minimumSize: const Size(150, 50),
                    ),
                    child: const Text('Salvar'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _mostrarDialogMedicos();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(150, 50),
                    ),
                    child: const Text('Mostrar Médicos Cadastrados'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
    );
  }

  void _salvarCadastro() {
    medicosCollection.add({
      'Nome': _nomeController.text,
      'CPF/RG': _cpfRgController.text,
      'CRMV': _crmvController.text,
      'DataNascimento': _dataNascimentoController.text,
      'Email': _emailController.text,
      'Especializacao': _especializacaoController.text,
      'Genero': _generoController.text,
      'Telefone': _telefoneController.text,
    });

    _nomeController.clear();
    _cpfRgController.clear();
    _crmvController.clear();
    _dataNascimentoController.clear();
    _emailController.clear();
    _especializacaoController.clear();
    _generoController.clear();
    _telefoneController.clear();
  }

  void _mostrarDialogMedicos() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Médicos Cadastrados'),
          content: SizedBox(
            width: double.maxFinite,
            child: FutureBuilder<QuerySnapshot>(
              future: medicosCollection.get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Erro ao carregar médicos');
                } else {
                  var medicos = snapshot.data!.docs;

                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: medicos.length,
                      itemBuilder: (context, index) {
                        var medico =
                            medicos[index].data() as Map<String, dynamic>;

                        return ListTile(
                          title: Text(medico['Nome']),
                          subtitle: Text(medico['Especializacao']),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MedicosPage(),
  ));
}
