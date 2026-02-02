import 'package:flutter/material.dart';

/// Página con lista de ejemplos de código deprecado
class DeprecatedListExample extends StatelessWidget {
  const DeprecatedListExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista con Código Deprecado'),
        elevation: 4.0,
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  '${index + 1}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              title: Text(
                'Item $index',
                style: Theme.of(context).textTheme.headline6,
              ),
              subtitle: Text(
                'Descripción del item $index con estilo deprecado',
                style: Theme.of(context).textTheme.caption,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                color: Colors.blue, // Forma antigua de color
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => _buildBottomSheet(context, index),
                  );
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(itemIndex: index),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue, // Deprecado
        child: const Icon(Icons.add),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Acción de agregar'),
              action: SnackBarAction(
                label: 'Deshacer',
                textColor: Colors.yellow, // Deprecado
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Opciones para Item $index',
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.blue),
            title: Text(
              'Editar',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text(
              'Eliminar',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.share, color: Colors.green),
            title: Text(
              'Compartir',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

/// Página de detalle con más código deprecado
class DetailPage extends StatelessWidget {
  final int itemIndex;

  const DetailPage({super.key, required this.itemIndex});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detalle Item $itemIndex'),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Agregado a favoritos'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Imagen con Container y BoxDecoration
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade300,
                      Colors.blue.shade700,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 80,
                    color: Colors.white.withOpacity(0.7), // Forma antigua
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item $itemIndex',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Subtítulo del item',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      'Descripción',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Esta es una descripción larga del item $itemIndex. '
                      'Contiene múltiples líneas de texto para demostrar '
                      'el uso de estilos de texto deprecados en Flutter 3.10.6.',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 24),

                    // Usando ButtonBar (deprecado)
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            primary: Colors.blue, // Deprecado
                          ),
                          icon: const Icon(Icons.thumb_up),
                          label: const Text('Me gusta'),
                          onPressed: () {},
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            primary: Colors.orange, // Deprecado
                          ),
                          icon: const Icon(Icons.comment),
                          label: const Text('Comentar'),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Chips con estilo deprecado
                    Wrap(
                      spacing: 8,
                      children: [
                        Chip(
                          label: const Text('Etiqueta 1'),
                          backgroundColor: Colors.blue.shade100,
                          deleteIconColor: Colors.blue, // Forma antigua
                          onDeleted: () {},
                        ),
                        Chip(
                          label: const Text('Etiqueta 2'),
                          backgroundColor: Colors.green.shade100,
                          deleteIconColor: Colors.green,
                          onDeleted: () {},
                        ),
                        Chip(
                          label: const Text('Etiqueta 3'),
                          backgroundColor: Colors.orange.shade100,
                          deleteIconColor: Colors.orange,
                          onDeleted: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Card con información adicional
                    Card(
                      elevation: 4,
                      color: Colors.grey.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Información Adicional',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow('Creado:', '2024-01-01'),
                            _buildInfoRow('Actualizado:', '2024-01-15'),
                            _buildInfoRow('Estado:', 'Activo'),
                            _buildInfoRow('Categoría:', 'Ejemplo'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Botones de acción
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, // Deprecado
                          onPrimary: Colors.white, // Deprecado
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar Item'),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          primary: Colors.red, // Deprecado
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: const Icon(Icons.delete),
                        label: const Text('Eliminar Item'),
                        onPressed: () {
                          _showDeleteDialog(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Estás seguro de que quieres eliminar el Item $itemIndex?',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.grey, // Deprecado
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.red, // Deprecado
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              // Simular eliminación
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

/// Widget con ejemplo de Switch deprecado
class DeprecatedSwitchExample extends StatefulWidget {
  const DeprecatedSwitchExample({super.key});

  @override
  State<DeprecatedSwitchExample> createState() =>
      _DeprecatedSwitchExampleState();
}

class _DeprecatedSwitchExampleState extends State<DeprecatedSwitchExample> {
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        'Activar notificaciones',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      subtitle: Text(
        'Recibe notificaciones de actualizaciones',
        style: Theme.of(context).textTheme.caption,
      ),
      value: _switchValue,
      onChanged: (value) {
        setState(() {
          _switchValue = value;
        });
      },
      // Usando activeColor (deprecado)
      activeColor: Colors.blue,
      activeTrackColor: Colors.blue.shade200,
    );
  }
}
