/// Route name constants. Always navigate with these (`Get.toNamed(Routes.x)`)
/// rather than raw strings.
abstract class Routes {
  Routes._();

  static const shell = '/';
  static const properties = '/properties';
  static const propertyDetail = '/property-detail';
  static const components = '/components'; // dev: component gallery
  static const auth = '/auth';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const agents = '/agents';
  static const favorites = '/favorites';
  static const chat = '/chat';
  static const bookings = '/bookings';
  static const profile = '/profile';
  static const speed30 = '/speed30';
  static const estimation = '/estimation';
  static const estimationLoading = '/estimation/loading';
  static const estimationResult = '/estimation/result';
  static const simulation = '/simulation';
  static const simulationResult = '/simulation/result';
}
