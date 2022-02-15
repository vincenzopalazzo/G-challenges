class CandyDistributor {
  int kidsSize = 0;
  int totCandy = 0;
  List<CandyBag> candyBags = List.empty(growable: true);
}

class CandyBag {
  int candyContained;

  CandyBag(this.candyContained);
}
