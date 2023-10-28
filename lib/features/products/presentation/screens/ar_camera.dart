import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class Modele {
  final String name;
  final String url;
  final double scale;

  Modele({required this.name, required this.url, required this.scale});
}

final List<Modele> modele3d = [
  Modele(
      name: 'Estatua Inca',
      url: 'models.scnassets/estatua.usdz',
      scale: 0.0050),
  Modele(
      name: 'Asiento Inca',
      url: 'models.scnassets/Asiento_del_Inca.usdz',
      scale: 0.0015),
  Modele(
      name: 'Iglesia Polloc',
      url: 'models.scnassets/iglesia.usdz',
      scale: 0.0060),
];

class ArCamera extends StatefulWidget {
  @override
  _PersonARPageState createState() => _PersonARPageState();
}

class _PersonARPageState extends State<ArCamera> {
  late ARKitController arkitController;
  ARKitReferenceNode? node;
  List<ARKitNode> nodes = []; // Lista de nodos 3D

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  int value = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            ARKitSceneView(
              showFeaturePoints: true,
              planeDetection: ARPlaneDetection.horizontal,
              onARKitViewCreated: (ARKitController arkitController) {
                this.arkitController = arkitController;
                arkitController
                    .addCoachingOverlay(CoachingOverlayGoal.horizontalPlane);

                // Agregar el nodo 3D según el valor de 'value'
                if (value >= 0 && value < modele3d.length) {
                  _addNode(modele3d[value].url, modele3d[value].scale);
                }
              },
            ),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (int i = 0; i < modele3d.length; i++)
                      InkWell(
                        onTap: () {
                          setState(() {
                            value = i;
                            _reloadScene();
                          });
                        },
                        splashColor: Colors.white30,
                        child: Container(
                          alignment: Alignment.center,
                          height: 20,
                          width: size / 3,
                          child: Text(
                            modele3d[i].name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
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

  void _addNode(String modelUrl, double scale) {
    if (node != null) {
      arkitController.remove(node!.name);
    }

    node = ARKitReferenceNode(
      url: modelUrl,
      scale: vector.Vector3.all(scale),
    );
    arkitController.add(node!);

    // Agregar el nodo a la lista
    nodes.add(node!);
  }

  void _reloadScene() {
    // Eliminar todos los nodos de la lista
    for (var node in nodes) {
      arkitController.remove(node.name);
    }

    // Limpiar la lista de nodos
    nodes.clear();

    // Agregar el nuevo nodo según el valor de 'value'
    if (value >= 0 && value < modele3d.length) {
      _addNode(modele3d[value].url, modele3d[value].scale);
    }
  }
}
