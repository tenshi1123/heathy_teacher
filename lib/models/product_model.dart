class Item {
  String headerText;
  List<String> bodyText;
  bool isExpanded;

  Item({
    required this.headerText,
    required this.bodyText,
    this.isExpanded = false,
  });
}
