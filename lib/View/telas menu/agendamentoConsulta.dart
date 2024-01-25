import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AgendamentoConsultaPage extends StatefulWidget {
  const AgendamentoConsultaPage({Key? key});

  @override
  _AgendamentoConsultaPageState createState() =>
      _AgendamentoConsultaPageState();
}

class _AgendamentoConsultaPageState extends State<AgendamentoConsultaPage> {
  final TextEditingController _nomePacienteController = TextEditingController();
  final TextEditingController _dataConsultaController = TextEditingController();
  final TextEditingController _observacoesController = TextEditingController();

  String? _selectedMedico;

  final CollectionReference consultasCollection =
      FirebaseFirestore.instance.collection('consultas');
  final CollectionReference medicosCollection =
      FirebaseFirestore.instance.collection('medicos');

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamento de Consultas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTextFormField('Nome do Paciente', _nomePacienteController),
              _buildDateTextFormField(
                  'Data da Consulta', _dataConsultaController, context),
              _buildDropdownMedicos(),
              _buildTextFormField('Observações', _observacoesController),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _agendarConsulta();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
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
          labelStyle: TextStyle(
            color: Colors.green,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
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

  Widget _buildDateTextFormField(
      String label, TextEditingController controller, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.green,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, preencha este campo';
          }
          return null;
        },
        keyboardType: TextInputType.datetime,
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2101),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  primaryColor: Colors.green,
                  buttonTheme:
                      ButtonThemeData(textTheme: ButtonTextTheme.primary),
                  colorScheme: ColorScheme.light(primary: Colors.green)
                      .copyWith(secondary: Colors.green),
                ),
                child: child!,
              );
            },
          ).then((pickedDate) {
            if (pickedDate == null) return;
            showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    primaryColor: Colors.green,
                    buttonTheme:
                        ButtonThemeData(textTheme: ButtonTextTheme.primary),
                    colorScheme: ColorScheme.light(primary: Colors.green)
                        .copyWith(secondary: Colors.green),
                  ),
                  child: child!,
                );
              },
            ).then((pickedTime) {
              if (pickedTime == null) return;
              final pickedDateTime = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
              final formattedDate = _dateFormat.format(pickedDateTime);
              controller.text = formattedDate;
            });
          });
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
              labelStyle: TextStyle(
                color: Colors.green,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  void _agendarConsulta() {
    if (_selectedMedico != null) {
      try {
        var timestampConsulta = _dateFormat
            .parse(_dataConsultaController.text)
            .millisecondsSinceEpoch;

        consultasCollection.add({
          'nomePaciente': _nomePacienteController.text,
          'dataConsulta':
              Timestamp.fromMillisecondsSinceEpoch(timestampConsulta),
          'medico': _selectedMedico,
          'observacoes': _observacoesController.text,
        });

        _nomePacienteController.clear();
        _dataConsultaController.clear();
        _observacoesController.clear();
        _selectedMedico = null;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, insira a data no formato correto.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione um médico.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
