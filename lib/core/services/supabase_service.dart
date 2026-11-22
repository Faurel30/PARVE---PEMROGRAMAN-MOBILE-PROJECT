import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/ticket_data.dart';

class SupabaseService {
  SupabaseService._internal();
  static final SupabaseService instance = SupabaseService._internal();

  SupabaseClient? _client;
  bool _isConfigured = false;

  // Supabase Configuration properties (default from SupabaseConfig)
  String _url = SupabaseConfig.url;
  String _anonKey = SupabaseConfig.anonKey;

  String get url => _url;
  String get anonKey => _anonKey;
  bool get isConfigured => _isConfigured && _client != null;

  // Stream controller for real-time notifications
  final StreamController<List<OfficerNotification>> _notificationController =
      StreamController<List<OfficerNotification>>.broadcast();

  // In-memory notifications list (acts as local cache and demo fallback)
  final List<OfficerNotification> _currentNotifications =
      OfficerNotification.generateInitialNotifications(
        ValetVehicle.generateSampleVehicles(),
      );

  StreamSubscription? _supabaseRealtimeSub;

  /// Inisialisasi Supabase dengan URL & Anon Key (opsional jika sudah ada)
  Future<bool> initialize({String? url, String? anonKey}) async {
    final targetUrl = url?.trim() ?? _url.trim();
    final targetKey = anonKey?.trim() ?? _anonKey.trim();

    if (targetUrl.isEmpty || targetKey.isEmpty || targetUrl.contains('YOUR_PROJECT_REF')) {
      debugPrint('[SupabaseService] Belum ada Project URL valid. Berjalan dalam Mode Demo Realtime.');
      _isConfigured = false;
      _emitCurrent();
      return false;
    }

    try {
      _url = targetUrl;
      _anonKey = targetKey;

      await Supabase.initialize(
        url: _url,
        // ignore: deprecated_member_use
        anonKey: _anonKey,
        debug: kDebugMode,
      );

      _client = Supabase.instance.client;
      _isConfigured = true;

      debugPrint('[SupabaseService] Terkoneksi ke Supabase: $_url');
      _subscribeToRealtimeNotifications();
      return true;
    } catch (e) {
      debugPrint('[SupabaseService] Gagal konek Supabase: $e');
      _isConfigured = false;
      _emitCurrent();
      return false;
    }
  }

  /// Langganan (Subscribe) ke stream Realtime notifikasi Supabase
  Stream<List<OfficerNotification>> streamNotifications() {
    // Segera pancarkan cache saat ini
    _emitCurrent();
    return _notificationController.stream;
  }

  void _emitCurrent() {
    if (!_notificationController.isClosed) {
      _notificationController.add(List.unmodifiable(_currentNotifications));
    }
  }

  /// Berlangganan table 'officer_notifications' di Supabase
  void _subscribeToRealtimeNotifications() {
    if (!isConfigured || _client == null) return;

    _supabaseRealtimeSub?.cancel();

    try {
      _supabaseRealtimeSub = _client!
          .from('officer_notifications')
          .stream(primaryKey: ['id'])
          .order('created_at', ascending: false)
          .listen(
        (data) {
          debugPrint('[SupabaseService] Data realtime diterima: ${data.length} baris');
          final remoteList = data.map((row) => _mapRowToNotification(row)).toList();

          if (remoteList.isNotEmpty) {
            _currentNotifications.clear();
            _currentNotifications.addAll(remoteList);
            _emitCurrent();
          }
        },
        onError: (err) {
          debugPrint('[SupabaseService] Error realtime stream: $err');
        },
      );
    } catch (e) {
      debugPrint('[SupabaseService] Gagal pasang listener stream: $e');
    }
  }

  /// Helper untuk mapping data baris Supabase ke model OfficerNotification
  OfficerNotification _mapRowToNotification(Map<String, dynamic> row) {
    return OfficerNotification(
      id: row['id']?.toString() ?? 'notif-${DateTime.now().millisecondsSinceEpoch}',
      title: row['title']?.toString() ?? 'Persetujuan Keluar',
      subtitle: row['subtitle']?.toString() ?? 'Admin menyetujui keluar.',
      time: row['time']?.toString() ?? 'Baru saja',
      authorInfo: row['author_info']?.toString() ?? 'Admin Operasional',
      ticket: VehicleTicket(
        plateNumber: row['plate_number']?.toString() ?? 'B 2024 FAK',
        driverName: row['driver_name']?.toString() ?? 'Pengemudi',
        ticketNumber: row['ticket_number']?.toString() ?? 'PV-081026-0246',
        approvedBy: row['approved_by']?.toString() ?? 'Admin Dimas Pratama',
        approvalTime: row['approval_time']?.toString() ?? '14.30 WIB',
        isApproved: row['is_approved'] == true,
      ),
    );
  }

  /// Mengirim notifikasi baru (disimpan ke Supabase jika terhubung & dipancarkan realtime)
  Future<void> sendNotification(OfficerNotification notification) async {
    // 1. Simpan di cache lokal dan update stream langsung
    _currentNotifications.insert(0, notification);
    _emitCurrent();

    // 2. Simpan ke Supabase jika terhubung
    if (isConfigured && _client != null) {
      try {
        await _client!.from('officer_notifications').insert({
          'id': notification.id,
          'title': notification.title,
          'subtitle': notification.subtitle,
          'time': notification.time,
          'author_info': notification.authorInfo,
          'ticket_number': notification.ticket.ticketNumber,
          'plate_number': notification.ticket.plateNumber,
          'driver_name': notification.ticket.driverName,
          'approved_by': notification.ticket.approvedBy,
          'approval_time': notification.ticket.approvalTime,
          'is_approved': notification.ticket.isApproved,
          'created_at': DateTime.now().toIso8601String(),
        });
        debugPrint('[SupabaseService] Notifikasi berhasil disimpan ke Supabase.');
      } catch (e) {
        debugPrint('[SupabaseService] Gagal insert ke Supabase: $e');
      }
    }
  }

  /// Skrip SQL DDL untuk membuat tabel Supabase
  static const String sqlSchema = '''
-- ============================================================
-- SQL Schema untuk Supabase Realtime PARVE (Jalankan di Supabase SQL Editor)
-- ============================================================

CREATE TABLE IF NOT EXISTS public.officer_notifications (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  subtitle TEXT NOT NULL,
  time TEXT NOT NULL,
  author_info TEXT,
  ticket_number TEXT,
  plate_number TEXT,
  driver_name TEXT,
  approved_by TEXT,
  approval_time TEXT,
  is_approved BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Aktifkan Realtime Replication untuk tabel
ALTER PUBLICATION supabase_realtime ADD TABLE public.officer_notifications;

-- Aktifkan Row Level Security (RLS) & Policy akses publik/petugas
ALTER TABLE public.officer_notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Akses baca notifikasi petugas" 
ON public.officer_notifications FOR SELECT 
USING (true);

CREATE POLICY "Akses tulis notifikasi petugas" 
ON public.officer_notifications FOR INSERT 
WITH CHECK (true);
''';

  void dispose() {
    _supabaseRealtimeSub?.cancel();
    _notificationController.close();
  }
}
