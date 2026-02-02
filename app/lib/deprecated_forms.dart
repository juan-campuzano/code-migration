import 'package:flutter/material.dart';

/// Ejemplo de formulario con validación usando código deprecado
class DeprecatedFormExample extends StatefulWidget {
  const DeprecatedFormExample({super.key});

  @override
  State<DeprecatedFormExample> createState() => _DeprecatedFormExampleState();
}

class _DeprecatedFormExampleState extends State<DeprecatedFormExample> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Usando Scaffold.of de forma que puede causar problemas
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Formulario enviado correctamente'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white, // Deprecado
            onPressed: () {},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario Deprecado'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Registro de Usuario',
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Campo de nombre con decoración deprecada
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre completo',
                hintText: 'Ingresa tu nombre',
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade50,
                // Usando errorStyle de forma antigua
                errorStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Campo de email
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'ejemplo@correo.com',
                prefixIcon: const Icon(Icons.email),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu email';
                }
                if (!value.contains('@')) {
                  return 'Por favor ingresa un email válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Campo de teléfono
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                hintText: '+1234567890',
                prefixIcon: const Icon(Icons.phone),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu teléfono';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Campo de contraseña
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                hintText: '********',
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu contraseña';
                }
                if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Checkbox con estilo deprecado
            CheckboxListTile(
              title: Text(
                'Acepto los términos y condiciones',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              value: _acceptTerms,
              onChanged: (value) {
                setState(() {
                  _acceptTerms = value ?? false;
                });
              },
              // Usando checkColor y activeColor (deprecado)
              checkColor: Colors.white,
              activeColor: Colors.blue,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 24),

            // Botón con estilo deprecado
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Deprecado
                onPrimary: Colors.white, // Deprecado
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _acceptTerms ? _submitForm : null,
              child: const Text(
                'ENVIAR FORMULARIO',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // Botón secundario
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.grey, // Deprecado
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                _formKey.currentState?.reset();
                _nameController.clear();
                _emailController.clear();
                _phoneController.clear();
                setState(() {
                  _acceptTerms = false;
                });
              },
              child: const Text(
                'LIMPIAR FORMULARIO',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),

            // Card con información adicional
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información adicional',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Este formulario utiliza código deprecado de Flutter 3.10.6 para pruebas de migración automática.',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    const SizedBox(height: 8),
                    // Usando RichText con TextSpan de forma antigua
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.caption,
                        children: const [
                          TextSpan(
                            text: 'Nota: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                'Todos los datos son ficticios y no se almacenan.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget de selección con Radio buttons deprecado
class DeprecatedRadioExample extends StatefulWidget {
  const DeprecatedRadioExample({super.key});

  @override
  State<DeprecatedRadioExample> createState() => _DeprecatedRadioExampleState();
}

class _DeprecatedRadioExampleState extends State<DeprecatedRadioExample> {
  String _selectedOption = 'option1';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<String>(
          title: Text(
            'Opción 1',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          value: 'option1',
          groupValue: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value!;
            });
          },
          // Usando activeColor (deprecado)
          activeColor: Colors.blue,
        ),
        RadioListTile<String>(
          title: Text(
            'Opción 2',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          value: 'option2',
          groupValue: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value!;
            });
          },
          activeColor: Colors.blue,
        ),
        RadioListTile<String>(
          title: Text(
            'Opción 3',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          value: 'option3',
          groupValue: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value!;
            });
          },
          activeColor: Colors.blue,
        ),
      ],
    );
  }
}
