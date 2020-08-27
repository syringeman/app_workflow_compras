import 'package:app_workflow_compras/controller/Post.dart';
import 'package:app_workflow_compras/controller/WSAprovaPedidosCompra.dart';
import 'package:app_workflow_compras/controller/WSPedidosCompra.dart';
import 'package:app_workflow_compras/model/PedidoCompra.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'components/CardPedidoCompra.dart';

enum OpcoesMenuItem { atualizar, markAll, unmarkAll, invertSelection}

class PedidosCompraScreen extends StatefulWidget {
  final List<CardPedidoCompra> _listaPedidosCompra;
  final List<CardPedidoCompra> _listaPedidosHistorico;

  PedidosCompraScreen(this._listaPedidosCompra, this._listaPedidosHistorico);

  @override
  PedidosCompraScreenState createState() => PedidosCompraScreenState(
      this._listaPedidosCompra, this._listaPedidosHistorico);
}

class PedidosCompraScreenState extends State<PedidosCompraScreen> {
  final List<CardPedidoCompra> _listaPedidosCompra;
  final List<CardPedidoCompra> _listaPedidosHistorico;

  Future<Post> postPendentes;
  Future<Post> postHistorico;

  PedidosCompraScreenState(
      this._listaPedidosCompra, this._listaPedidosHistorico);

  @override
  void initState() {
    super.initState();
    this.postPendentes = WSPedidosCompra('PENDENTES');
    this.postHistorico = WSPedidosCompra('HISTORICO');
  }

  @override
  Widget build(BuildContext context) {
    OpcoesMenuItem _selection;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            PopupMenuButton<OpcoesMenuItem>(
              onSelected: (OpcoesMenuItem result) {
                setState(() {
                  _selection = result;
                  switch (_selection){

                    case OpcoesMenuItem.atualizar:

                      break;
                    case OpcoesMenuItem.markAll:
                      for (final card in _listaPedidosCompra) {
                        card.isSelected = true;
                      }
                      break;
                    case OpcoesMenuItem.unmarkAll:
                      for (final card in _listaPedidosCompra) {
                        card.isSelected = true;
                      }
                      break;
                    case OpcoesMenuItem.invertSelection:
                      for (final card in _listaPedidosCompra) {
                        card.isSelected = !card.isSelected;
                      }
                      break;
                  }
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<OpcoesMenuItem>>[
                const PopupMenuItem<OpcoesMenuItem>(
                  value: OpcoesMenuItem.atualizar,
                  child: Text('Atualizar'),
                ),
                const PopupMenuItem<OpcoesMenuItem>(
                  value: OpcoesMenuItem.markAll,
                  child: Text('Marcar Todos'),
                ),
                const PopupMenuItem<OpcoesMenuItem>(
                  value: OpcoesMenuItem.unmarkAll,
                  child: Text('Desmarcar Todos'),
                ),
                const PopupMenuItem<OpcoesMenuItem>(
                  value: OpcoesMenuItem.invertSelection,
                  child: Text('Inverter Seleção'),
                ),
              ],
            )
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.data_usage)),
              Tab(icon: Icon(Icons.check)),
            ],
          ),
          title: Text('Pedidos de Compra'),
        ),
        body: TabBarView(
          children: [
            Scaffold(
              body: fetchPedidosPendentes(),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.block,
                      color: Colors.red,
                    ),
                    title: Text(
                      'Reprovar',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                    backgroundColor: Colors.green,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.check, color: Colors.green),
                    title: Text(
                      'Aprovar',
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                  ),
                ],
                //currentIndex: _selectedIndex,
                //selectedItemColor: Colors.amber[800],
                onTap: _onItemTapped,
              ),
            ),
            Scaffold(
              body: fetchPedidosHistorico(),
            ),
          ],
        ),
      ),
    );
  }

  Future<Post> aprovar(String status, List<PedidoCompra> pedidoCompras) async {
    Post post;

    for (final pedidoCompra in pedidoCompras) {
          post = await WSAprovaPedidosCompra(
            pedidoCompra.getDados('C7_FILIAL'),
            pedidoCompra.getDados('C7_NUM'), status);

        if (post != null) {
          String retorno = post.body['RETORNO'];
          String sucesso = status == 'L' ? 'Aprovado' : 'Reprovado';

          if (retorno.toUpperCase().trim() == 'OK') {
            Toast.show("Pedido $sucesso", context,
                duration: 5, gravity: Toast.BOTTOM);
            Navigator.pop(context);
          } else {
            Toast.show(retorno, context,
                duration: 5, gravity: Toast.BOTTOM);
          }
        }
    }

    if (status == 'B') {
      Toast.show("Pedidos Reprovados", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else if (status == 'L') {
      Toast.show("Pedidos Aprovados", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }

    return post;
  }

  void _onItemTapped(int index) {
    setState(() {
      List<PedidoCompra> pedidos = new List();
      for (final card in _listaPedidosCompra) {
        if (card.isSelected) {
          pedidos.add(card.pedidoCompra);
        }
      }

      String status = '';
      if (index == 0) {
        status = 'B';
      } else if (index == 1) {
        status = 'L';
      }

      Toast.show("Processando pedidos...", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      aprovar(status,pedidos);
    });
  }

  FutureBuilder<Post> fetchPedidosPendentes() {
    PedidoCompra pedidoCompra;
    String status;

    return FutureBuilder<Post>(
      future: postPendentes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _listaPedidosCompra.clear();
          for (int i = 0; i < snapshot.data.body['PEDIDOS'].length; i++) {
            pedidoCompra = PedidoCompra(snapshot.data.body['PEDIDOS'][i]);
            if(pedidoCompra != null) {
              status = pedidoCompra.getDados('C7_CONAPRO');
              if (status == null || status.trim() != 'L') {
                _listaPedidosCompra.add(CardPedidoCompra(
                  pedidoCompra,
                  allowSelection: true,
                ));
              }
            }
          }
          return montarListViewPendentes();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  FutureBuilder<Post> fetchPedidosHistorico() {
    PedidoCompra pedidoCompra;

    return FutureBuilder<Post>(
      future: postHistorico,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _listaPedidosHistorico.clear();
          for (int i = 0; i < snapshot.data.body['PEDIDOS'].length; i++) {
            pedidoCompra = PedidoCompra(snapshot.data.body['PEDIDOS'][i]);
            if(pedidoCompra != null) {
              _listaPedidosHistorico.add(CardPedidoCompra(pedidoCompra));
            }
          }
          return montarListViewHistorico();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  ListView montarListViewPendentes() {
    ListView listView = ListView.builder(
      itemCount: _listaPedidosCompra.length,
      itemBuilder: (context, indice) {
        return _listaPedidosCompra[indice];
      },
    );
    return listView;
  }

  ListView montarListViewHistorico() {
    ListView listView = ListView.builder(
      itemCount: _listaPedidosHistorico.length,
      itemBuilder: (context, indice) {
        return _listaPedidosHistorico[indice];
      },
    );
    return listView;
  }
}
