// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signInHash() => r'6b669634f48c489d643cd604753443ddb536f4fa';

/// See also [signIn].
@ProviderFor(signIn)
final signInProvider = AutoDisposeProvider<SignInProvider>.internal(
  signIn,
  name: r'signInProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$signInHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SignInRef = AutoDisposeProviderRef<SignInProvider>;
String _$loadingHash() => r'4cc53ce4fd093a1a3da0f64e1dad577fa510fd5f';

/// See also [Loading].
@ProviderFor(Loading)
final loadingProvider = AutoDisposeNotifierProvider<Loading, bool>.internal(
  Loading.new,
  name: r'loadingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$loadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Loading = AutoDisposeNotifier<bool>;
String _$authHash() => r'43160a1ac09f70085dfb1f406c21dd3489c6a0d1';

/// See also [Auth].
@ProviderFor(Auth)
final authProvider = AutoDisposeNotifierProvider<Auth, User?>.internal(
  Auth.new,
  name: r'authProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Auth = AutoDisposeNotifier<User?>;
String _$rememberMeHash() => r'd24e700f1fe0334a17014346159079cc43d8988e';

/// See also [RememberMe].
@ProviderFor(RememberMe)
final rememberMeProvider =
    AutoDisposeNotifierProvider<RememberMe, bool>.internal(
  RememberMe.new,
  name: r'rememberMeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$rememberMeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RememberMe = AutoDisposeNotifier<bool>;
String _$obscureBoolHash() => r'd0f90d8443becbc38b1e1211f47fc1230b648c34';

/// See also [ObscureBool].
@ProviderFor(ObscureBool)
final obscureBoolProvider =
    AutoDisposeNotifierProvider<ObscureBool, bool>.internal(
  ObscureBool.new,
  name: r'obscureBoolProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$obscureBoolHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ObscureBool = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
