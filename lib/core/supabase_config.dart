import 'package:supabase/supabase.dart';

/// Konfigurasi terpusat koneksi Supabase PARVE
/// Menggunakan core `package:supabase/supabase.dart` sehingga bebas error NDK/CMake `:jni:buildCMakeDebug` di Android Emulator
class SupabaseConfig {
  SupabaseConfig._();

  static const String url = 'https://wwjwytezxckcfcooyxlk.supabase.co';

  /// Publishable API Key (digunakan untuk client utama Web & Mobile)
  static const String publishableKey =
      'sb_publishable_-h9HD0lAD-kvUdSAs_NFaA_7ZX82dVu';

  static SupabaseClient? _client;

  /// Inisialisasi client Supabase saat aplikasi dijalankan di main()
  static Future<void> initialize() async {
    _client ??= SupabaseClient(url, publishableKey);
  }

  /// Client utama menggunakan Publishable Key
  static SupabaseClient get client {
    return _client ??= SupabaseClient(url, publishableKey);
  }

  /// Client aktif aplikasi PARVE
  static SupabaseClient get activeClient => client;
}
