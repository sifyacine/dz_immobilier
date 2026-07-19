import 'package:get/get.dart';

import '../../features/auth/bindings/auth_binding.dart';
import '../../features/auth/views/forgot_password_view.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/auth/views/register_view.dart';
import '../../features/components_gallery/views/components_gallery_view.dart';
import '../../features/estimation/bindings/estimation_binding.dart';
import '../../features/estimation/views/estimation_loading_view.dart';
import '../../features/estimation/views/estimation_result_view.dart';
import '../../features/estimation/views/estimation_view.dart';
import '../../features/properties/bindings/properties_binding.dart';
import '../../features/properties/views/properties_view.dart';
import '../../features/property_detail/bindings/property_detail_binding.dart';
import '../../features/property_detail/views/property_detail_view.dart';
import '../../features/shell/bindings/shell_binding.dart';
import '../../features/shell/views/shell_view.dart';
import '../../features/simulation/bindings/simulation_binding.dart';
import '../../features/simulation/views/simulation_result_view.dart';
import '../../features/simulation/views/simulation_view.dart';
import '../../features/speed30/bindings/speed30_binding.dart';
import '../../features/speed30/views/speed30_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.shell;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.shell,
      page: () => const ShellView(),
      binding: ShellBinding(),
    ),
    // Keep for deep-linking / direct navigation if needed.
    GetPage(
      name: Routes.properties,
      page: () => const PropertiesView(),
      binding: PropertiesBinding(),
    ),
    GetPage(
      name: Routes.propertyDetail,
      page: () => const PropertyDetailView(),
      binding: PropertyDetailBinding(),
    ),
    GetPage(
      name: Routes.components,
      page: () => const ComponentsGalleryView(),
    ),
    // ── Auth ─────────────────────────────────────────────────────────────
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.speed30,
      page: () => const Speed30View(),
      binding: Speed30Binding(),
    ),
    GetPage(
      name: Routes.estimation,
      page: () => const EstimationView(),
      binding: EstimationBinding(),
    ),
    GetPage(
      name: Routes.estimationLoading,
      page: () => const EstimationLoadingView(),
      binding: EstimationBinding(),
    ),
    GetPage(
      name: Routes.estimationResult,
      page: () => const EstimationResultView(),
      binding: EstimationBinding(),
    ),
    GetPage(
      name: Routes.simulation,
      page: () => const SimulationView(),
      binding: SimulationBinding(),
    ),
    GetPage(
      name: Routes.simulationResult,
      page: () => const SimulationResultView(),
      binding: SimulationBinding(),
    ),
    // TODO: register agents, chat, bookings pages as each is built.
  ];
}
