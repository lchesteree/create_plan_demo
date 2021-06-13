class Plan {
  String name;
  double? price;
  List<String> funList = [];

  Plan(this.name);

  void setPrice(double price) {
    this.price = price;
  }

  void addFunction(String fun) {
    this.funList.add(fun);
  }

  @override
  String toString() {
    return 'Name: $name \nPrice: $price \nFunction: $funList';
  }
}
