import 'package:app_workflow_compras/model/PedidoCompra.dart';
import 'package:flutter/material.dart';

enum StatusPedido { Aprovado, Reprovado, Pendente }

class CardCompraItem extends StatefulWidget {
  final PedidoCompra pedidoCompra;

  CardCompraItem(this.pedidoCompra);

  @override
  State<StatefulWidget> createState() {
    return CardCompraItemState(pedidoCompra);
  }
}

class CardCompraItemState extends State<CardCompraItem> {
  final PedidoCompra _pedidoCompra;

  CardCompraItemState(this._pedidoCompra);

  @override
  Widget build(BuildContext context) {
    String status = _pedidoCompra.getDados('C7_CONAPRO');

    return Card(
      child: Container(
        child: ListTile(
          title: Text(
            '${_pedidoCompra.getDados('C7_PRODUTO').trim()} - ${_pedidoCompra.getDados('B1_DESC').trim()}',
          ),
          subtitle: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Item: ${_pedidoCompra.getDados("C7_ITEM")}',
                  ),
                  Text('     '),
                  Text(
                    'U.M.: ${_pedidoCompra.getDados("C7_UM")}',
                  ),
                  Text('     '),
                  Text(
                    'Qtde: ${_pedidoCompra.getDados("C7_QUANT")}',
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Preco: R\$ ${_pedidoCompra.getDados("C7_PRECO")}',
                  ),
                ],
              ),
            ],
          ),
          trailing: Text(
            'R\$ ${_pedidoCompra.getDados('C7_TOTAL')}',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          leading: Icon(
            Icons.details,
            color: (status == null || status.trim() == '')
                ? Colors.grey
                : (status.toUpperCase().trim() == 'L'
                    ? Colors.green
                    : Colors.red),
            size: 25,
          ),
          dense: false,
          //leading: Icon(Icons.monetization_on,color: Colors.green,),
          //isThreeLine: true,
          //enabled: false,
        ),
      ),
      elevation: 5.0,
    );
  }
}
