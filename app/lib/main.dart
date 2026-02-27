import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deprecated Code Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        // TextTheme with updated property names
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 14),
          bodyMedium: TextStyle(fontSize: 12),
          titleMedium: TextStyle(fontSize: 16),
          titleSmall: TextStyle(fontSize: 14),
          bodySmall: TextStyle(fontSize: 12, color: Colors.grey),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Using PopScope instead of deprecated WillPopScope
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        final shouldPop = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('¿Salir?'),
                content: const Text('¿Estás seguro de que quieres salir?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Sí'),
                  ),
                ],
              ),
            ) ??
            false;
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Deprecated Code Demo'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Using Text with updated Theme styles
                Text(
                  'Ejemplos de Código Deprecado',
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                Text(
                  'Contador: $_counter',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Using ElevatedButton with updated styleFrom
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: _incrementCounter,
                  child: const Text('Incrementar Contador'),
                ),
                const SizedBox(height: 10),

                // More buttons with updated styles
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                  onPressed: () {
                    // Using SnackBar with updated API
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('TextButton presionado'),
                        action: SnackBarAction(
                          label: 'OK',
                          foregroundColor: Colors.yellow,
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  child: const Text('TextButton Deprecado'),
                ),
                const SizedBox(height: 10),

                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SecondPage(),
                      ),
                    );
                  },
                  child: const Text('Ir a Segunda Página'),
                ),
                const SizedBox(height: 20),

                // Using Opacity (less efficient, other widgets are recommended)
                Opacity(
                  opacity: 0.5,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.blue,
                    child: Text(
                      'Widget con Opacity',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Using Color.fromRGBO old style
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(100, 100, 100, 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Container con color antiguo',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Using OverflowBar instead of deprecated ButtonBar
                OverflowBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text('Botón 1'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text('Botón 2'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Using RaisedButton style (although it no longer exists, but the pattern is old)
                const ListTileExample(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          backgroundColor: Colors.blue, // Old style
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class ListTileExample extends StatelessWidget {
  const ListTileExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.album),
        title: Text(
          'ListTile Example',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          'Subtítulo con estilo deprecado',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Using Scaffold.of old style (may cause issues)
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Información'),
              content: const Text('Este es un ListTile con estilos deprecados'),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Removed WillPopScope as it just popped on back press (default behavior)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segunda Página'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Segunda Página',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Esta página también usa código deprecado',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 8, // Elevation used directly
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Volver'),
            ),
            const SizedBox(height: 20),

            // Using FlatButton style (old pattern with TextButton)
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.blue.shade50,
              ),
              onPressed: () {},
              child: const Text('Botón Estilo FlatButton'),
            ),
          ],
        ),
      ),
    );
  }
}
