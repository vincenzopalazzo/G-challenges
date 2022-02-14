class CandyDistributor {
  int kidsSize = 0;
  List<CandyBag> candyBags = List.empty(growable: true);
}

class CandyBag {
  int candyContained;

  CandyBag({required this.candyContained});
}
