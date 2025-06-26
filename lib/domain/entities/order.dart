class Order {
  final String id;
  final String description;
  final bool? finished;
  final DateTime createdAt;
  final String? customerName;

  Order({
    required this.id,
    required this.description,
    required this.finished,
    required this.createdAt,
    this.customerName
  });
}