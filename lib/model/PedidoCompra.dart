class PedidoCompra {
  Map<String, dynamic> dados;

  PedidoCompra(this.dados);

  String getDados(String nomeCampo){
    return dados[nomeCampo] != null ? dados[nomeCampo] : ' ';
  }
}