import 'package:app_workflow_compras/model/PedidoCompra.dart';
import 'package:app_workflow_compras/view/formularios/PedidoCompraForm.dart';
import 'package:flutter/material.dart';

enum StatusPedido { Aprovado, Reprovado, Pendente }

class CardPedidoCompra extends StatefulWidget {
  final PedidoCompra pedidoCompra;
  final bool allowSelection;
  bool isSelected = false;

  CardPedidoCompra(this.pedidoCompra, {this.allowSelection});

  @override
  State<StatefulWidget> createState() {
    return CardPedidoCompraState(pedidoCompra, allowSelection: this.allowSelection);
  }
}

class CardPedidoCompraState extends State<CardPedidoCompra> {
  bool allowSelection;

  final PedidoCompra _pedidoCompra;

  CardPedidoCompraState(this._pedidoCompra, {this.allowSelection});

  @override
  Widget build(BuildContext context) {
    String status = _pedidoCompra.getDados('C7_CONAPRO');

    return Card(
      child: Container(
        child: ListTile(
          title: Text(
            'Filial: ${_pedidoCompra.getDados('C7_FILIAL')}',
          ),
          subtitle: Text(
            'Número: ${_pedidoCompra.getDados('C7_NUM')}',
          ),
          trailing: Text(
            'R\$ ${_pedidoCompra.getDados('C7_TOTAL')}',
            style: TextStyle(fontSize: 12),
          ),
          dense: true,
          leading: Icon(
            Icons.shopping_cart,
            color: (status == null || status.trim() == '')
                ? Colors.grey
                : (status.toUpperCase().trim() == 'L'
                    ? Colors.green
                    : Colors.red),
            size: 25,
          ),
          //leading: Icon(Icons.monetization_on,color: Colors.green,),
          onTap: () {
            String status = _pedidoCompra.getDados('C7_CONAPRO');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PedidoCompraForm(
                  _pedidoCompra,
                  isVisual: status != null && status.trim() != '',
                ),
              ),
            );
          },
          onLongPress: () {
            setState(() {
              if (this.allowSelection) {
                widget.isSelected = !widget.isSelected;
              }
            });
          },
          //isThreeLine: true,
          //enabled: false,
        ),
        decoration: widget.isSelected
            ? new BoxDecoration(
                color: Colors.lightBlueAccent,
                //border: new Border.all(color: Colors.black),
              )
            : new BoxDecoration(),
      ),
      elevation: 5.0,
    );
  }
}
