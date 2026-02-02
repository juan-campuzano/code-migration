import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

/// Clase con ejemplos de widgets y patrones deprecados
class DeprecatedWidgetsExample extends StatefulWidget {
  const DeprecatedWidgetsExample({super.key});

  @override
  State<DeprecatedWidgetsExample> createState() =>
      _DeprecatedWidgetsExampleState();
}

class _DeprecatedWidgetsExampleState extends State<DeprecatedWidgetsExample> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deprecated Widgets'),
      ),
      body: ListView(
        controller: _scrollController,
        children: [
          // Usando MediaQuery directamente sin MediaQuery.of
          _buildMediaQueryExample(),

          // Usando TextStyle con propiedades deprecadas
          _buildTextStyleExample(),

          // Usando InputDecoration con propiedades deprecadas
          _buildInputDecorationExample(),

          // Usando TabBar con indicatorColor deprecado
          _buildTabBarExample(),

          // Usando Slider con propiedades deprecadas
          _buildSliderExample(),
        ],
      ),
    );
  }

  Widget _buildMediaQueryExample() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MediaQuery Example',
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 8),
          // Acceso directo sin nullable safety completo
          Builder(
            builder: (context) {
              final size = MediaQuery.of(context).size;
              return Text(
                'Screen width: ${size.width}',
                style: Theme.of(context).textTheme.bodyText2,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextStyleExample() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TextStyle con decorationColor deprecado',
            style: const TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: Colors.red, // Forma antigua
              decorationStyle: TextDecorationStyle.solid,
            ),
          ),
          const SizedBox(height: 8),
          // Usando debugLabel (deprecado en algunos contextos)
          const Text(
            'Texto con estilo antiguo',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputDecorationExample() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Input Decoration Example',
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              labelText: 'Label',
              hintText: 'Hint',
              // Usando border de forma antigua
              border: const OutlineInputBorder(),
              // filled y fillColor de forma antigua
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarExample() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            // Usando labelColor y unselectedLabelColor (deprecados)
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: const [
              Tab(text: 'Tab 1'),
              Tab(text: 'Tab 2'),
              Tab(text: 'Tab 3'),
            ],
          ),
          SizedBox(
            height: 200,
            child: TabBarView(
              children: [
                Center(
                  child: Text(
                    'Content 1',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Center(
                  child: Text(
                    'Content 2',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Center(
                  child: Text(
                    'Content 3',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderExample() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Slider Example',
            style: Theme.of(context).textTheme.headline5,
          ),
          Slider(
            value: 0.5,
            onChanged: (value) {},
            // Usando activeColor y inactiveColor (deprecados)
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}

/// Clase con ejemplos de navegación deprecada
class DeprecatedNavigationExample {
  // Usando Navigator de forma antigua sin named routes modernos
  static void navigateToPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  // Usando pushReplacement de forma antigua
  static void replaceWithPage(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  // Usando pushAndRemoveUntil de forma antigua
  static void navigateAndClearStack(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => page,
      ),
      (route) => false,
    );
  }
}

/// Widget con Gestures deprecados
class DeprecatedGesturesWidget extends StatelessWidget {
  const DeprecatedGesturesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Usando onTap simple sin feedback visual
      onTap: () {
        // Mostrar SnackBar de forma antigua
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tap detected'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Tap me',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }
}

/// Clase con ejemplos de AnimationController deprecado
class DeprecatedAnimationExample extends StatefulWidget {
  const DeprecatedAnimationExample({super.key});

  @override
  State<DeprecatedAnimationExample> createState() =>
      _DeprecatedAnimationExampleState();
}

class _DeprecatedAnimationExampleState extends State<DeprecatedAnimationExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Usando Tween de forma antigua
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
            child: Center(
              child: Text(
                'Animated',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        );
      },
    );
  }
}
