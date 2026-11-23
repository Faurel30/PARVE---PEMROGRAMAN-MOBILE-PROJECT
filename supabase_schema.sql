-- ==========================================================
-- PARVE SUPABASE DATABASE SCHEMA
-- Digunakan untuk sinkronisasi User App, Petugas App, dan Web Admin
-- ==========================================================

-- 1. TABEL MALLS (Ketersediaan Slot Parkir Valet per Lokasi)
CREATE TABLE IF NOT EXISTS malls (
    id BIGSERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    occupied_slots INTEGER DEFAULT 0,
    total_slots INTEGER DEFAULT 15,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Seed data 5 Mall Utama PARVE
INSERT INTO malls (name, occupied_slots, total_slots)
VALUES 
    ('Grand Metropolitan Mall', 0, 15),
    ('Summarecon Mall Bekasi', 0, 15),
    ('Mega Bekasi Hypermall', 0, 15),
    ('Mall Metropolitan', 0, 15),
    ('Grand Galaxy Park', 0, 15)
ON CONFLICT (name) DO NOTHING;

-- 2. TABEL PROFILES (Data Pengguna & Saldo Dompet PARVE)
CREATE TABLE IF NOT EXISTS profiles (
    email TEXT PRIMARY KEY,
    name TEXT,
    phone TEXT,
    wallet_balance BIGINT DEFAULT 0,
    has_booked_once BOOLEAN DEFAULT FALSE,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. TABEL TICKETS (Tiket Valet Digital & Pelacakan Serah Terima Kendaraan)
CREATE TABLE IF NOT EXISTS tickets (
    ticket_code TEXT PRIMARY KEY,
    user_email TEXT,
    location_name TEXT NOT NULL,
    pickup_lobby TEXT NOT NULL,
    vehicle_name TEXT NOT NULL,
    plate_number TEXT NOT NULL,
    vehicle_specs TEXT,
    vehicle_size TEXT,
    entry_time TEXT,
    parking_area TEXT,
    valet_fee BIGINT DEFAULT 35000,
    hourly_rate BIGINT DEFAULT 5000,
    status_text TEXT DEFAULT 'Terparkir aman',
    is_active BOOLEAN DEFAULT TRUE,
    is_pickup_requested BOOLEAN DEFAULT FALSE,
    valet_officer_name TEXT DEFAULT 'Andi Saputra',
    payment_status TEXT DEFAULT 'Lunas',
    parking_started_at TIMESTAMPTZ DEFAULT NOW(),
    frozen_elapsed_seconds INTEGER,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. TABEL VEHICLES (Kendaraan Tersimpan Milik Pengguna)
CREATE TABLE IF NOT EXISTS vehicles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_email TEXT NOT NULL,
    name TEXT NOT NULL,
    plate_number TEXT NOT NULL,
    color TEXT,
    year TEXT,
    is_selected BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. TABEL WALLET_TRANSACTIONS (Riwayat Mutasi Saldo Dompet PARVE)
CREATE TABLE IF NOT EXISTS wallet_transactions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_email TEXT NOT NULL,
    title TEXT NOT NULL,
    subtitle TEXT,
    amount BIGINT NOT NULL,
    is_income BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
