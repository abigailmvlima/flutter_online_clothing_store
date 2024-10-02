import 'package:flutter/material.dart';
import 'package:online_clothing_store/datas/product_data.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String? size;
  late ProductData product;
  int _currentIndex = 0; // Controla o índice atual do PageView
  final PageController _pageController =
      PageController(); // Controlador do PageView

  @override
  void initState() {
    super.initState();
    product =
        widget.product; // Inicializa o product com widget.product no initState
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    // Verifica se product.images não é nulo e tem valores
    if (product.images == null || product.images!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Produto sem imagens'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Este produto não possui imagens.'),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(product.title ?? 'Produto sem título'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            AspectRatio(
              aspectRatio: 0.9,
              child: Column(
                children: [
                  // PageView substitui o CarouselSlider
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController, // Controla a navegação
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex =
                              index; // Atualiza o índice da página atual
                        });
                      },
                      itemCount: product.images?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Image.network(
                          product.images![index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // Indicador de bolinhas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: product.images!.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () {
                          _pageController.jumpToPage(
                              entry.key); // Muda para a página clicada
                          setState(() {
                            _currentIndex =
                                entry.key; // Atualiza o índice atual
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _currentIndex == entry.key
                              ? 12.0
                              : 8.0, // Tamanho da bolinha quando selecionada
                          height: _currentIndex == entry.key ? 16.0 : 12.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (_currentIndex == entry.key
                                    ? primaryColor
                                    : Colors.transparent)
                                .withOpacity(_currentIndex == entry.key
                                    ? 1.0
                                    : 0.2), // Cor da bolinha
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    product.title ?? 'Produto sem título',
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.w500),
                    maxLines: 3,
                  ),
                  Text("R\$ ${(product.price ?? 0.0).toStringAsFixed(2)}",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 16.0),
                  const Text("Tamanho",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 34.0,
                    child: GridView(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 0.5),
                      // Usando product.sizes ?? [] para garantir que seja uma lista não nula
                      children: (product.size ?? []).map((s) {
                        // Corrigido para 'sizes'
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              size = s;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(
                                color: s == size
                                    ? primaryColor
                                    : (Colors.grey[300] ?? Colors.grey),
                                width: 2.0,
                              ),
                            ),
                            width: 50.0,
                            alignment: Alignment.center,
                            child: Text(s),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
