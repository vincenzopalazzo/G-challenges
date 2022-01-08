class Restaurant {
  List<Client> clients;

  Restaurant({required this.clients});
}

class Client {
  Client({required this.preference, required this.dislike});

  Set<String> preference;
  Set<String> dislike;
}

class Statistic {
  final String ingridiend;
  int counter;

  Statistic({required this.ingridiend, this.counter = 1});

  void increase() {
    counter++;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Statistic &&
          runtimeType == other.runtimeType &&
          ingridiend == other.ingridiend;

  @override
  int get hashCode => ingridiend.hashCode;
}
