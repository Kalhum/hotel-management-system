// domain/entitise/extra_bed_type_entitise.dart
//
// map กับตาราง extra_bed_types
// (id, name, description, price, max_child_age, is_active, created_at, updated_at)
class ExtraBedTypeEntitise {
  final int id;
  final String name;
  final String description;
  final double price;
  final int maxChildAge;

  const ExtraBedTypeEntitise({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.maxChildAge,
  });
}