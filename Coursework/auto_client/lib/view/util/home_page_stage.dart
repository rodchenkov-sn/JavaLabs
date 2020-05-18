enum HomePageStage {
  JOURNAL,
  ROUTES,
  AUTOMOBILES,
  PERSONNEL,
  NOT_DETERMINED
}

extension PrettyStage on HomePageStage {
  String toPrettyString() {
    switch (this) {
      case HomePageStage.JOURNAL:
        return 'Journal';
      case HomePageStage.ROUTES:
        return 'Routes';
      case HomePageStage.AUTOMOBILES:
        return 'Automobiles';
      case HomePageStage.PERSONNEL:
        return 'Personnel';
      default:
        return 'Unknown';
    }
  }
}
