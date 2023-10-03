import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class ProductFormState {
  final bool isFormVlidad;
  final String? id;
  final Name name;
  final Ubicacion ubicacion;
  final Longitude longitude;
  final Latitude latitude;
  final Descripcion description;

  ProductFormState({
    this.isFormVlidad = false,
    this.id,
    this.name = const Name.dirty(''),
    this.ubicacion = const Ubicacion.dirty(''),
    this.longitude = const Longitude.dirty(),
    this.latitude = const Latitude.dirty(),
    this.description = const Descripcion.dirty(''),
  });

  ProductFormState copyWith({
    bool? isFormVlidad,
    String? id,
    Name? name,
    Ubicacion? ubicacion,
    Longitude? longitude,
    Latitude? latitude,
    Descripcion? description,
  }) =>
      ProductFormState(
        isFormVlidad: isFormVlidad ?? this.isFormVlidad,
        id: id ?? this.id,
        name: name ?? this.name,
        ubicacion: ubicacion ?? this.ubicacion,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        description: description ?? this.description,
      );
  @override
  String toString() {
    return '''
isFormVlidad:$isFormVlidad,
id:$id,
name:$name,
ubicacion:$ubicacion,
longitude:$longitude,
latitude:$latitude,
description:$description,
''';
  }
}

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final Future<Product> Function(Map<String, dynamic> productLike)?
      onSunbmitCallback;
  ProductFormNotifier({
    this.onSunbmitCallback,
    required Product product,
  }) : super(ProductFormState(
          id: product.id.toString(),
          name: Name.dirty(product.name),
          ubicacion: Ubicacion.dirty(product.location),
          longitude: Longitude.dirty(product.longitude.toString()),
          latitude: Latitude.dirty(product.latitude.toString()),
          description: Descripcion.dirty(product.description),
        ));

  void onNameChange(String value) {
    state = state.copyWith(
        name: Name.dirty(value),
        isFormVlidad: Formz.validate([
          Name.dirty(value),
          Ubicacion.dirty(state.ubicacion.value),
          Longitude.dirty(state.longitude.value),
          Latitude.dirty(state.latitude.value),
          Descripcion.dirty(state.description.value),
        ]));
  }

  void onUbicacionChange(String value) {
    state = state.copyWith(
        ubicacion: Ubicacion.dirty(value),
        isFormVlidad: Formz.validate([
          Ubicacion.dirty(value),
          Name.dirty(state.name.value),
          Longitude.dirty(state.longitude.value),
          Latitude.dirty(state.latitude.value),
          Descripcion.dirty(state.description.value),
        ]));
  }

  void onLongitudeChange(String value) {
    state = state.copyWith(
        longitude: Longitude.dirty(value),
        isFormVlidad: Formz.validate([
          Longitude.dirty(value),
          Name.dirty(state.name.value),
          Longitude.dirty(state.longitude.value),
          Ubicacion.dirty(state.ubicacion.value),
          Latitude.dirty(state.latitude.value),
          Descripcion.dirty(state.description.value),
        ]));
  }

  void onLatitudeChange(String value) {
    state = state.copyWith(
        latitude: Latitude.dirty(value),
        isFormVlidad: Formz.validate([
          Latitude.dirty(value),
          Longitude.dirty(state.longitude.value),
          Name.dirty(state.name.value),
          Longitude.dirty(state.longitude.value),
          Ubicacion.dirty(state.ubicacion.value),
          Latitude.dirty(state.latitude.value),
          Descripcion.dirty(state.description.value),
        ]));
  }

  void onDescriptionChange(String value) {
    state = state.copyWith(
        description: Descripcion.dirty(value),
        isFormVlidad: Formz.validate([
          Descripcion.dirty(value),
          Latitude.dirty(state.latitude.value),
          Longitude.dirty(state.longitude.value),
          Name.dirty(state.name.value),
          Longitude.dirty(state.longitude.value),
          Ubicacion.dirty(state.ubicacion.value),
          Latitude.dirty(state.latitude.value),
          Descripcion.dirty(state.description.value),
        ]));
  }

  //tocar cada uno de los campos // para ver si los campos han sido tocados o manipulados

  void _touchEverything() {
    state = state.copyWith(
      isFormVlidad: Formz.validate([
        Name.dirty(state.name.value),
        Ubicacion.dirty(state.ubicacion.value),
        Longitude.dirty(state.longitude.value),
        Latitude.dirty(state.latitude.value),
        Descripcion.dirty(state.description.value),
      ]),
    );
  }

  Future<bool> onFormSubmit() async {
    _touchEverything();

    if (!state.isFormVlidad) return false;

    if (onSunbmitCallback == null) return false;

    final productLike = {
      'id': (state.id == 'new') ? null : state.id,
      'name': state.name.value,
      'location': state.ubicacion.value,
      'longitude': double.parse(state.longitude.value),
      'latitude': double.parse(state.latitude.value),
      'description': state.description.value,
    };

    //todo: llamar callback
    try {
      await onSunbmitCallback!(productLike);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final productFormProvider = StateNotifierProvider.autoDispose
    .family<ProductFormNotifier, ProductFormState, Product>((ref, product) {
  //create update callback

  final createUpdateCallback =
      ref.watch(productsRepositoryProvider).createUpdateProduct;
  return ProductFormNotifier(
    product: product,
    onSunbmitCallback: createUpdateCallback,
  );
});
