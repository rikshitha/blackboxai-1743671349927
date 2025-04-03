class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String healthMonitor = '/health-monitor';
  static const String medication = '/medication';
  static const String appointments = '/appointments';
  static const String videoCall = '/video-call';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
      dashboard: (context) => const DashboardScreen(),
    };
  }
}