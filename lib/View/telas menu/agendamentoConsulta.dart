import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AgendamentoConsultaPage extends StatefulWidget {
  @override
  _AgendamentoConsultaPageState createState() =>
      _AgendamentoConsultaPageState();
}

class _AgendamentoConsultaPageState extends State<AgendamentoConsultaPage> {
  final TextEditingController _nomePacienteController = TextEditingController();
  final TextEditingController _dataConsultaController = TextEditingController();
  final TextEditingController _observacoesController = TextEditingController();

  String? _selectedMedico; // Médico selecionado no dropdown

  final CollectionReference consultasCollection =
      FirebaseFirestore.instance.collection('consultas');
  final CollectionReference medicosCollection =
      FirebaseFirestore.instance.collection('medicos');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendamento de Consultas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTextFormField('Nome do Paciente', _nomePacienteController),
              _buildTextFormField('Data da Consulta', _dataConsultaController),
              _buildDropdownMedicos(),
              _buildTextFormField('Observações', _observacoesController),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _agendarConsulta();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(150, 50),
                ),
                child: const Text('Agendar Consulta'),
              ),
            ],
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
            color: Colors.blue,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
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

  Widget _buildDropdownMedicos() {
    return FutureBuilder<QuerySnapshot>(
      future: medicosCollection.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erro ao carregar médicos');
        } else {
          var medicos = snapshot.data!.docs;
          var medicoItems = medicos
              .map<DropdownMenuItem<String>>((medico) =>
                  DropdownMenuItem<String>(
                    value: '${medico['Nome']} - ${medico['Especializacao']}',
                    child: Text(
                      '${medico['Nome']} - ${medico['Especializacao']}',
                    ),
                  ))
              .toList();

          return DropdownButtonFormField<String>(
            value: _selectedMedico,
            items: medicoItems,
            onChanged: (value) {
              setState(() {
                _selectedMedico = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Selecione o Médico',
              labelStyle: const TextStyle(
                color: Colors.blue,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          );
        }
      },
    );
  }

  void _agendarConsulta() {
    if (_selectedMedico != null) {
      consultasCollection.add({
        'nomePaciente': _nomePacienteController.text,
        'dataConsulta': _dataConsultaController.text,
        'medico': _selectedMedico,
        'observacoes': _observacoesController.text,
      });

      // Limpar os campos após o agendamento
      _nomePacienteController.clear();
      _dataConsultaController.clear();
      _observacoesController.clear();
      _selectedMedico = null;
    } else {
      // Exibir mensagem de erro se o médico não for selecionado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, selecione um médico.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
