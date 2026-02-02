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
        // Usando propiedades deprecadas de ThemeData
        primarySwatch: Colors.blue,
        // TextTheme con propiedades deprecadas
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          headline2: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          headline3: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          headline4: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          headline5: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          bodyText1: TextStyle(fontSize: 14),
          bodyText2: TextStyle(fontSize: 12),
          subtitle1: TextStyle(fontSize: 16),
          subtitle2: TextStyle(fontSize: 14),
          caption: TextStyle(fontSize: 12, color: Colors.grey),
          button: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
    // Usando WillPopScope (deprecado en favor de PopScope)
    return WillPopScope(
      onWillPop: () async {
        // Mostrar diálogo de confirmación
        return await showDialog(
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
                // Usando Text con style de Theme deprecado
                Text(
                  'Ejemplos de Código Deprecado',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                Text(
                  'Contador: $_counter',
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Usando ElevatedButton con styleFrom deprecado
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Deprecado: usar backgroundColor
                    onPrimary: Colors.white, // Deprecado: usar foregroundColor
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: _incrementCounter,
                  child: const Text('Incrementar Contador'),
                ),
                const SizedBox(height: 10),

                // Más botones con estilos deprecados
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.green, // Deprecado
                  ),
                  onPressed: () {
                    // Usando SnackBar de forma antigua
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('TextButton presionado'),
                        action: SnackBarAction(
                          label: 'OK',
                          textColor: Colors.yellow, // Deprecado
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
                    primary: Colors.red, // Deprecado
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

                // Usando Opacity (menos eficiente, se recomienda usar otros widgets)
                Opacity(
                  opacity: 0.5,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.blue,
                    child: Text(
                      'Widget con Opacity',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Usando Color.fromRGBO de forma antigua
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(100, 100, 100, 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Container con color antiguo',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Usando ButtonBar (deprecado)
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple,
                        onPrimary: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text('Botón 1'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        onPrimary: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text('Botón 2'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Usando RaisedButton style (aunque ya no existe, pero el patrón es viejo)
                const ListTileExample(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          backgroundColor: Colors.blue, // Forma antigua
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
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          'Subtítulo con estilo deprecado',
          style: Theme.of(context).textTheme.caption,
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Usando Scaffold.of de forma antigua (puede causar problemas)
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Información'),
              content: const Text('Este es un ListTile con estilos deprecados'),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.blue,
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
    // Otra página con WillPopScope
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Segunda Página'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Segunda Página',
                style: Theme.of(context).textTheme.headline2,
              ),
              const SizedBox(height: 20),
              Text(
                'Esta página también usa código deprecado',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                  elevation: 8, // Elevation usado directamente
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver'),
              ),
              const SizedBox(height: 20),

              // Usando FlatButton style (patrón antiguo con TextButton)
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.blue,
                  backgroundColor: Colors.blue.shade50,
                ),
                onPressed: () {},
                child: const Text('Botón Estilo FlatButton'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
