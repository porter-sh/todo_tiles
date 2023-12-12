/// This file defines the [BackendTranslator] interface, so that types on the
/// frontend can be uniformly converted to what will be sent to the backend over
/// http.

/// Public class [BackendTranslator] is an interface for translating types to be
/// sent to the backend.
abstract class BackendTranslator<T> {
  /// The value of the item.
  dynamic get backendRepresentation;
}
