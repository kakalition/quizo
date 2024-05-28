// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menu_path.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MenuPath {
  String get uuid => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<MenuPath> get children => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MenuPathCopyWith<MenuPath> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenuPathCopyWith<$Res> {
  factory $MenuPathCopyWith(MenuPath value, $Res Function(MenuPath) then) =
      _$MenuPathCopyWithImpl<$Res, MenuPath>;
  @useResult
  $Res call(
      {String uuid, String title, String description, List<MenuPath> children});
}

/// @nodoc
class _$MenuPathCopyWithImpl<$Res, $Val extends MenuPath>
    implements $MenuPathCopyWith<$Res> {
  _$MenuPathCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? title = null,
    Object? description = null,
    Object? children = null,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<MenuPath>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MenuPathImplCopyWith<$Res>
    implements $MenuPathCopyWith<$Res> {
  factory _$$MenuPathImplCopyWith(
          _$MenuPathImpl value, $Res Function(_$MenuPathImpl) then) =
      __$$MenuPathImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid, String title, String description, List<MenuPath> children});
}

/// @nodoc
class __$$MenuPathImplCopyWithImpl<$Res>
    extends _$MenuPathCopyWithImpl<$Res, _$MenuPathImpl>
    implements _$$MenuPathImplCopyWith<$Res> {
  __$$MenuPathImplCopyWithImpl(
      _$MenuPathImpl _value, $Res Function(_$MenuPathImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? title = null,
    Object? description = null,
    Object? children = null,
  }) {
    return _then(_$MenuPathImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      children: null == children
          ? _value._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<MenuPath>,
    ));
  }
}

/// @nodoc

class _$MenuPathImpl implements _MenuPath {
  const _$MenuPathImpl(
      {required this.uuid,
      required this.title,
      required this.description,
      required final List<MenuPath> children})
      : _children = children;

  @override
  final String uuid;
  @override
  final String title;
  @override
  final String description;
  final List<MenuPath> _children;
  @override
  List<MenuPath> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  @override
  String toString() {
    return 'MenuPath(uuid: $uuid, title: $title, description: $description, children: $children)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MenuPathImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._children, _children));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uuid, title, description,
      const DeepCollectionEquality().hash(_children));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MenuPathImplCopyWith<_$MenuPathImpl> get copyWith =>
      __$$MenuPathImplCopyWithImpl<_$MenuPathImpl>(this, _$identity);
}

abstract class _MenuPath implements MenuPath {
  const factory _MenuPath(
      {required final String uuid,
      required final String title,
      required final String description,
      required final List<MenuPath> children}) = _$MenuPathImpl;

  @override
  String get uuid;
  @override
  String get title;
  @override
  String get description;
  @override
  List<MenuPath> get children;
  @override
  @JsonKey(ignore: true)
  _$$MenuPathImplCopyWith<_$MenuPathImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
