import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_path.freezed.dart';

@freezed
class MenuPath with _$MenuPath {
  const factory MenuPath({
    required String uuid,
    required String title,
    required String description,
    required List<MenuPath> children,
  }) = _MenuPath;
}
