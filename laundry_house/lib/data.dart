enum SingingCharacter {
  Regular, Express
}

class Data {
  int numberOfOrder;

  String selectedItem = 'Clothes';
  String weightItem;
  String countItem;
  String selectedService;
  String address;
  String status = 'Waiting Response';
  String userName;
  String userPhone;
  String userEmail;
  String price;

  static String databaseName = 'user.db';
  static String tableName = 'user';
}

class Order {
  String item;
  String service;
  String address;
  String status;
  String display;
  String name;
  String phone;
  String email;
  String price;

  Order({this.item, this.service, this.address, this.status, this.display, this.name, this.phone, this.email, this.price});
}

Price price = new Price();

class Price {
  Map regularPrice = Map<String, int>();
  Map expressPrice = Map<String, int>();

  Price() {
    regularPrice['Clothes'] = 8000;
    regularPrice['Bed Sheet'] = 25000;
    regularPrice['Shoes'] = 50000;
    regularPrice['Bag'] = 15000;
    regularPrice['Pick up fee'] = 15000;

    expressPrice['Clothes'] = 10000;
    expressPrice['Bed Sheet'] = 35000;
    expressPrice['Shoes'] = 70000;
    expressPrice['Bag'] = 25000;
    expressPrice['Pick up fee'] = 20000;
  }
}