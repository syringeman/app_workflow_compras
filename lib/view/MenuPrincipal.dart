import 'package:app_workflow_compras/controller/GlobalConfigurations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'PedidosCompraScreen.dart';
import 'components/CardPedidoCompra.dart';

class MenuPrincipal extends StatelessWidget {
  bool isHome = false;
  List<CardPedidoCompra> listaPedidosCompra      = List();
  List<CardPedidoCompra> listaPedidosHistorico   = List();

  MenuPrincipal({this.isHome});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            child: ListTile(
              leading: Icon(Icons.list),
              title: Text('RTE - Rodonaves', style: TextStyle(fontSize: 25),),
              subtitle: Text(GlobalConfigurations.usuarioProtheus.login),
            ),
            decoration: BoxDecoration(color: Colors.blue[300]),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.home),
              title: Text('Tela Inicial'),
              onTap: () {
                Scaffold.of(context).openEndDrawer();
                this.isHome = this.isHome == null ? false : true;
                if (Navigator.canPop(context) && !this.isHome) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Pedidos de Compra'),
              onTap: () {
                Scaffold.of(context).openEndDrawer();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PedidosCompraScreen(listaPedidosCompra, listaPedidosHistorico),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              onTap: () {
                Scaffold.of(context).openEndDrawer();
                SystemNavigator.pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
