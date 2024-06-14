import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductosVendidosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Productos Vendidos',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xffffd700),
          bottom: const TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Tabla', icon: Icon(Icons.list, color: Colors.white)),
              Tab(
                  text: 'Datos',
                  icon: Icon(Icons.list_alt, color: Colors.white)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProductosVendidosDatos(),
            ProductosVendidosFormulario(),
          ],
        ),
      ),
    );
  }
}

class ProductosVendidosFormulario extends StatefulWidget {
  const ProductosVendidosFormulario({Key? key}) : super(key: key);

  @override
  _ProductosVendidosFormularioState createState() =>
      _ProductosVendidosFormularioState();
}

class _ProductosVendidosFormularioState
    extends State<ProductosVendidosFormulario> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idProductoController = TextEditingController();
  final TextEditingController _numeroProductosController =
      TextEditingController();
  final TextEditingController _idVentaController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _clienteController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      await FirebaseFirestore.instance.collection('productos_vendidos').add({
        'id_producto_vendido': _idProductoController.text,
        'id_producto': _numeroProductosController.text,
        'numero_productos': _numeroProductosController.text,
        'id_venta': _idVentaController.text,
        'precio': double.tryParse(_precioController.text) ?? 0.0,
        'cantidad': int.tryParse(_cantidadController.text) ?? 0,
        'fecha': _fechaController.text,
        'cliente': _clienteController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto vendido añadido exitosamente')),
      );

      _formKey.currentState?.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _idProductoController,
              decoration: InputDecoration(
                labelText: 'ID Producto Vendido',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el ID del producto vendido';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _numeroProductosController,
              decoration: InputDecoration(
                labelText: 'Número de Productos',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el número de productos';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _idVentaController,
              decoration: InputDecoration(
                labelText: 'ID Venta',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _precioController,
              decoration: InputDecoration(
                labelText: 'Precio',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el precio';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _cantidadController,
              decoration: InputDecoration(
                labelText: 'Cantidad',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese la cantidad';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _fechaController,
              decoration: InputDecoration(
                labelText: 'Fecha',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese la fecha';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _clienteController,
              decoration: InputDecoration(
                labelText: 'Cliente',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el cliente';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Añadir Producto Vendido'),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xffffd700),
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductosVendidosDatos extends StatelessWidget {
  const ProductosVendidosDatos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('productos_vendidos')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final data = snapshot.requireData;

        return ListView.builder(
          itemCount: data.size,
          itemBuilder: (context, index) {
            final doc = data.docs[index];
            return ListTile(
              title: Text(
                'Producto: ${doc['id_producto']} - Cliente: ${doc['cliente']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  'ID: ${doc['id_producto_vendido']} - Precio: \$${doc['precio']}'),
              trailing: Text('Cantidad: ${doc['cantidad']}'),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            );
          },
        );
      },
    );
  }
}
