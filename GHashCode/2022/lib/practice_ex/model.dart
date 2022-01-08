class Restaurant {
  List<Client> clients;

  Restaurant({required this.clients});
}

class Client {
  Client({required this.preference, required this.dislike});

  List<String> preference;
  List<String> dislike;
}
