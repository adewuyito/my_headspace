enum LottieAnimation {
  dataNotFound(name: 'data_not_found'),
  loading(name: 'loading'),
  empty(name: 'empty'),
  smallError(name: 'small_error'),
  error(name: 'error');

  final String name;
  const LottieAnimation({required this.name});
}
