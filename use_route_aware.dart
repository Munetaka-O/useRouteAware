
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useRouteAware(
  RouteObserver<ModalRoute<dynamic>> routeObserver, {
  Future<void> Function()? didPushNext,
  Future<void> Function()? didPush,
  Future<void> Function()? didPopNext,
  Future<void> Function()? didPop,
  List<Object?> keys = const [],
}) {
  final context = useContext();
  final route = ModalRoute.of(context);

  useEffect(
    () {
      if (route == null) {
        return () {};
      }

      final callbacks = RouteAwareCallbacks(
        handleDidPush: didPush,
        handleDidPushNext: didPushNext,
        handleDidPopNext: didPopNext,
        handleDidPop: didPop,
      );
      routeObserver.subscribe(callbacks, route as PageRoute<dynamic>);
      return () => routeObserver.unsubscribe(callbacks);
    },
    [route, routeObserver, ...keys],
  );
}

class RouteAwareCallbacks with RouteAware {
  const RouteAwareCallbacks({
    this.handleDidPush,
    this.handleDidPushNext,
    this.handleDidPopNext,
    this.handleDidPop,
  });

  final Future<void> Function()? handleDidPush;
  final Future<void> Function()? handleDidPushNext;
  final Future<void> Function()? handleDidPopNext;
  final Future<void> Function()? handleDidPop;

  @override
  Future<void> didPush() async => await handleDidPush?.call();

  @override
  Future<void> didPushNext() async => await handleDidPushNext?.call();

  @override
  Future<void> didPopNext() async => await handleDidPopNext?.call();

  @override
  Future<void> didPop() async => await handleDidPop?.call();
}
