import 'package:app_workflow_compras/controller/Post.dart';
import 'package:app_workflow_compras/controller/WSAprovaPedidosCompra.dart';
import 'package:app_workflow_compras/controller/WSItensPedidosCompra.dart';
import 'package:app_workflow_compras/model/PedidoCompra.dart';
import 'package:app_workflow_compras/view/components/CardCompraItem.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class PedidoCompraForm extends StatelessWidget {
  final PedidoCompra _pedidoCompra;
  final bool isVisual;
  Future<Post> postItens;
  List<CardCompraItem> _listaPedidoItens = new List();
  BuildContext _context;

  PedidoCompraForm(this._pedidoCompra, {this.isVisual});

  @override
  Widget build(BuildContext context) {
    this.postItens = WSItensPedidosCompra(
        _pedidoCompra.getDados('C7_FILIAL'), _pedidoCompra.getDados('C7_NUM'));
    _context = context;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _pedidoCompra.getDados('C7_CONAPRO') == 'B'
              ? Colors.red
              : _pedidoCompra.getDados('C7_CONAPRO') == 'L'
                  ? Colors.green
                  : null,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.library_books)),
              Tab(icon: Icon(Icons.list)),
            ],
          ),
          title: Text(
            'Pedido ${_pedidoCompra.getDados('C7_NUM')}',
          ),
        ),
        body: TabBarView(
          children: [
            Scaffold(
              body: Column(
                children: <Widget>[
                  fieldPedido('C7_FILIAL', 'Filial'),
                  fieldPedido('C7_NUM', 'Numero'),
                  fieldPedido('A2_COD', 'Cód. Fornecedor'),
                  fieldPedido('A2_LOJA', 'Loja'),
                  fieldPedido('A2_CGC', 'CNPJ'),
                  fieldPedido('A2_NOME', 'Nome'),
                  fieldPedido('C7_EMISSAO', 'Emissao',
                      myIsDate: true, icone: Icons.date_range),
                  fieldPedido('C7_TOTAL', 'Valor',
                      myIsMoney: true, icone: Icons.attach_money),
                  fieldPedido('C7_CONAPRO', 'Situacao'),
                ],
              ),
              bottomNavigationBar:
                  !isVisual ? buildNavigationBar(context) : SizedBox(),
            ),
            Scaffold(body: fetchPedidosItens()),
          ],
        ),
      ),
    );
  }

  Widget _onItemTapped(int index) {
    String status = '';
    if (index == 0) {
      status = 'B';
    } else if (index == 1) {
      status = 'L';
    }

    aprovar(status);
  }

  Future<Post> aprovar(String status) async {
    Post post = await WSAprovaPedidosCompra(_pedidoCompra.getDados('C7_FILIAL'),
        _pedidoCompra.getDados('C7_NUM'), status);

    if (post != null) {
      String retorno = post.body['RETORNO'];
      String sucesso = status == 'L' ? 'Aprovado' : 'Reprovado';

      if (retorno.toUpperCase().trim() == 'OK') {
        Toast.show("Pedido $sucesso", _context,
            duration: 5, gravity: Toast.BOTTOM);
        Navigator.pop(_context);
      } else {
        Toast.show(retorno, _context,
            duration: 5, gravity: Toast.BOTTOM);
      }
    }

    return post;
  }

  BottomNavigationBar buildNavigationBar(BuildContext context) {
    return BottomNavigationBar(
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
    );
  }

  Widget fieldPedido(String campo, String titulo,
      {IconData icone, bool myIsDate, bool myIsMoney}) {
    String valor = this._pedidoCompra.getDados(campo).trim();

    if (campo == 'C7_CONAPRO') {
      switch (valor) {
        case 'L':
          valor = 'Liberado';
          break;
        case 'B':
          valor = 'Bloqueado';
          break;
        default:
          valor = 'Pendente';
          break;
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: TextField(
        maxLines: null,
        decoration: InputDecoration(
          isDense: true,
          icon: icone != null ? Icon(icone) : null,
          labelText: titulo != null ? titulo : '',
          suffix: Text(
            campo,
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ),
        enabled: false,
        controller: new TextEditingController(
          text: convertValueFromString(valor,
              isDate: myIsDate, isMoney: myIsMoney),
        ),
      ),
    );
  }

  String convertValueFromString(String str, {bool isDate, bool isMoney}) {
    if (str == null) {
      return '';
    } else if (str.trim().isEmpty) {
      return str;
    } else if (isDate != null && isDate) {
      DateTime todayDate = DateTime.parse(str);
      return formatDate(todayDate, [dd, '/', mm, '/', yyyy]);
    } else if (isMoney != null && isMoney) {
      return 'R\$ $str';
    } else {
      return str;
    }
  }

  FutureBuilder<Post> fetchPedidosItens() {
    PedidoCompra pedidoCompra;

    return FutureBuilder<Post>(
      future: postItens,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _listaPedidoItens.clear();
          for (int i = 0; i < snapshot.data.body['PEDIDOS'].length; i++) {
            pedidoCompra = PedidoCompra(snapshot.data.body['PEDIDOS'][i]);
            _listaPedidoItens.add(CardCompraItem(pedidoCompra));
          }
          return montarLisViewItens();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  ListView montarLisViewItens() {
    ListView listView = ListView.builder(
      itemCount: _listaPedidoItens.length,
      itemBuilder: (context, indice) {
        return _listaPedidoItens[indice];
      },
    );
    return listView;
  }
}
