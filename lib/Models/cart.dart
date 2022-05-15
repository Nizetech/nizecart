class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({this.id, this.price, this.quantity, this.title});
}

class Carting {
  Map<String, CartItem> items;

  Map<String, CartItem> get item {
    return {...items};
    // we are returning this as a copy from "items"
  }

  int get itemCount {
    return items == null ? 0 : items.length;
  }

  double get totalAmount {
    double total = 0.0;
    items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  Carting() {
    items = {};
  }

  void addItem(String productId, double price, String title) {
    if (item.containsKey(productId)) {
      // change the quantity
      items.update(
        productId,
        (existingClassItem) => CartItem(
          id: existingClassItem.id,
          title: existingClassItem.title,
          price: existingClassItem.price,
          quantity: existingClassItem.quantity + 1,
        ),
      );
    } else {
      items.putIfAbsent(
        // we use productId to access  specific object
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
    }
  }

  void removeItem(String productId) {
    items.remove(productId);
  }

  void removeSingleItem(String productId) {
    if (!items.containsKey(productId)) {
      return;
    }
    if (items[productId].quantity > 1) {
      items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      items.remove(productId);
    }
  }
}
