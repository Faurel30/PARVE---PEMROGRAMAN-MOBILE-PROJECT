/// Konfigurasi Supabase untuk Aplikasi PARVE Petugas
class SupabaseConfig {
  // ─────────────────────────────────────────────────────────────────────────
  // LANGKAH SETUP:
  // 1. Buka https://supabase.com/dashboard → pilih project kamu
  // 2. Klik 'Project Settings' (ikon gerigi) → 'Data API'
  // 3. Salin 'Project URL' → tempel di bawah (ganti PLACEHOLDER_URL)
  //    Contoh: https://abcdefghijklm.supabase.co
  // 4. Salin 'anon public' key → tempel di anonKey (ganti PLACEHOLDER_ANON_KEY)
  // ─────────────────────────────────────────────────────────────────────────

  /// URL Project Supabase (format: https://xxxx.supabase.co)
  static const String url = 'https://dugkslqswkdxqunfytgi.supabase.co';

  /// Anon/Public Key (aman untuk client Flutter)
  static const String anonKey = 'sb_publishable_T-D7AmpUmC5RykPHnTe6dA_onso8PO6';

  /// Catatan Keamanan:
  /// Secret Key adalah kunci admin penuh. JANGAN ditaruh di aplikasi Flutter.
  /// Simpan Secret Key hanya di backend server atau Supabase Edge Functions.
}
