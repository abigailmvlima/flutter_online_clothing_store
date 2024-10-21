import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_clothing_store/models/cart_model.dart';

class DiscountCard extends StatefulWidget {
  const DiscountCard({super.key});

  @override
  _DiscountCardState createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Cupom de Desconto",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        leading: const Icon(Icons.card_giftcard),
        trailing: const Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu cupom",
              ),
              initialValue: CartModel.of(context).couponCode ?? "",
              onFieldSubmitted: (text) async {
                // Executa a operação assíncrona para buscar o documento do cupom
                DocumentSnapshot docSnap = await FirebaseFirestore.instance
                    .collection("coupons")
                    .doc(text)
                    .get();

                // Verifica se o widget ainda está montado após a operação assíncrona
                if (!mounted) return;

                // Verifica se os dados do cupom são válidos e são do tipo Map
                final data = docSnap.data() as Map<String, dynamic>?;

                if (docSnap.exists && data != null) {
                  // Documento do cupom existe e dados são válidos
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Desconto de ${data["percent"]}% aplicado!",
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                  // Aplica o cupom de desconto
                  CartModel.of(context).setCoupon(text, data["percent"]);
                } else {
                  // Documento não encontrado ou inválido
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Cupom não existe"),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
