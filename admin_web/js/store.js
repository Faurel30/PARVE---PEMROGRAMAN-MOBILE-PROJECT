const ParveStore = (() => {
  const STORAGE_KEY = "parve_admin_state_v1";
  const THEME_KEY = "parve_admin_theme";

  const createDefaultState = () => {
    const now = Date.now();
    return {
      settings: {
        valetFee: 35000,
        hourlyRate: 5000,
      },
      // 5 Lokasi Mall Resmi PARVE (Sinkron dengan lib/models/booking_models.dart)
      malls: [
        {
          id: "loc-smb",
          name: "Summarecon Mall Bekasi",
          lobbySubtitle: "The Downtown Walk • Lobi Utama",
          parkingArea: "B1 • Zona Valet A-01",
          shortSlot: "B1 A-01",
          address: "Jl. Boulevard Ahmad Yani Blok M, Marga Mulya, Bekasi Utara",
          openHour: 10,
          closeHour: 22,
          totalSlots: 15,
          manualExtraSlots: 2,
          facilities: [
            "Drop-off The Downtown Walk",
            "CCTV 24 Jam",
            "Petugas Terverifikasi",
          ],
        },
        {
          id: "loc-gi",
          name: "Grand Indonesia",
          lobbySubtitle: "East Mall • Pintu Arjuna",
          parkingArea: "P2 • Valet Zone B-04",
          shortSlot: "P2 B-04",
          address: "Jl. M.H. Thamrin No. 1, Menteng, Jakarta Pusat",
          openHour: 10,
          closeHour: 22,
          totalSlots: 15,
          manualExtraSlots: 4,
          facilities: [
            "Drop-off East & West Mall",
            "CCTV 24 Jam",
            "Ruang Tunggu Lounge",
          ],
        },
        {
          id: "loc-pim2",
          name: "PIM 2",
          lobbySubtitle: "North Skywalk • Lobi Utama PIM 2",
          parkingArea: "P1 • Valet Premier V-11",
          shortSlot: "P1 V-11",
          address: "Jl. Metro Pondok Indah Kav. IV, Kebayoran Lama, Jakarta Selatan",
          openHour: 10,
          closeHour: 22,
          totalSlots: 15,
          manualExtraSlots: 1,
          facilities: [
            "Akses Langsung Skywalk",
            "CCTV 24 Jam",
            "Petugas Terverifikasi",
          ],
        },
        {
          id: "loc-sency",
          name: "Senayan City",
          lobbySubtitle: "Lobi utama • Pintu selatan",
          parkingArea: "B1 • Blok A-12",
          shortSlot: "B1 A-12",
          address: "Jl. Asia Afrika No. 19, Gelora, Tanah Abang, Jakarta Pusat",
          openHour: 10,
          closeHour: 22,
          totalSlots: 15,
          manualExtraSlots: 3,
          facilities: [
            "Lobi VIP Berkanopi",
            "CCTV 24 Jam",
            "EV Charging Ready",
          ],
        },
        {
          id: "loc-pp",
          name: "Pacific Place Jakarta",
          lobbySubtitle: "Lobi Selatan • SCBD Lot 3–5",
          parkingArea: "B1 • VIP Zone C-08",
          shortSlot: "B1 C-08",
          address: "Jl. Jend. Sudirman Kav. 52–53, SCBD, Jakarta Selatan",
          openHour: 10,
          closeHour: 22,
          totalSlots: 15,
          manualExtraSlots: 2,
          facilities: [
            "Lobi Eksklusif SCBD",
            "EV Supercharger",
            "Asuransi Valet Penuh",
          ],
        },
      ],
      officers: [
        { id: "off-1", name: "Andi Saputra", mallName: "Senayan City" },
        { id: "off-2", name: "Budi Santoso", mallName: "Grand Indonesia" },
        { id: "off-3", name: "Rizky Pratama", mallName: "PIM 2" },
        { id: "off-4", name: "Fajar Nugroho", mallName: "Summarecon Mall Bekasi" },
        { id: "off-5", name: "Hendra Wijaya", mallName: "Pacific Place Jakarta" },
      ],
      tickets: [
        {
          id: "tkt-1",
          ticketCode: "PV-231126-0248",
          userName: "Dimas Pratama",
          locationName: "Senayan City",
          pickupLobby: "Lobi utama • Pintu selatan",
          parkingArea: "B1 • Blok A-12",
          shortSlot: "B1 A-12",
          vehicleName: "Toyota Veloz",
          plateNumber: "B 2148 SJD",
          vehicleSpecs: "Putih • 2024",
          valetOfficerName: "Andi Saputra",
          valetPaymentMethod: "QRIS",
          valetFeeAmount: 35000,
          hourlyRate: 5000,
          statusText: "Terparkir aman",
          isActive: true,
          parkingStartedAt: now - 5412 * 1000, // 1 jam 30 mnt 12 dtk lalu
          frozenElapsedSeconds: null,
          journeySteps: [
            { title: "Diserahkan ke petugas", subtitle: "Lobi utama • Pintu selatan", time: "09.10" },
            { title: "Terparkir aman", subtitle: "B1 • Blok A-12", time: "09.16" },
          ],
        },
        {
          id: "tkt-2",
          ticketCode: "PV-231126-0251",
          userName: "Nadia Kusuma",
          locationName: "Grand Indonesia",
          pickupLobby: "East Mall • Pintu Arjuna",
          parkingArea: "P2 • Valet Zone B-04",
          shortSlot: "P2 B-04",
          vehicleName: "Honda HR-V",
          plateNumber: "B 1829 KLP",
          vehicleSpecs: "Hitam • 2024",
          valetOfficerName: "Budi Santoso",
          valetPaymentMethod: "Dompet PARVE",
          valetFeeAmount: 35000,
          hourlyRate: 5000,
          statusText: "Menuju lobi penjemputan",
          isActive: true,
          parkingStartedAt: now - 7900 * 1000, // 2 jam 11 mnt lalu
          frozenElapsedSeconds: null,
          journeySteps: [
            { title: "Diserahkan ke petugas", subtitle: "East Mall • Pintu Arjuna", time: "08.28" },
            { title: "Terparkir aman", subtitle: "P2 • Valet Zone B-04", time: "08.35" },
            { title: "Menuju lobi penjemputan", subtitle: "Permintaan ambil dari pelanggan", time: "10.38" },
          ],
        },
        {
          id: "tkt-3",
          ticketCode: "PV-231126-0254",
          userName: "Raka Mahendra",
          locationName: "Pacific Place Jakarta",
          pickupLobby: "Lobi Selatan • SCBD Lot 3–5",
          parkingArea: "B1 • VIP Zone C-08",
          shortSlot: "B1 C-08",
          vehicleName: "Honda Civic RS",
          plateNumber: "B 1042 TZX",
          vehicleSpecs: "Silver • 2023",
          valetOfficerName: "Hendra Wijaya",
          valetPaymentMethod: "GoPay",
          valetFeeAmount: 35000,
          hourlyRate: 5000,
          statusText: "Diserahkan ke petugas",
          isActive: true,
          parkingStartedAt: now - 420 * 1000, // 7 mnt lalu
          frozenElapsedSeconds: null,
          journeySteps: [
            { title: "Diserahkan ke petugas", subtitle: "Lobi Selatan • SCBD Lot 3–5", time: "10.33" },
          ],
        },
        {
          id: "tkt-4",
          ticketCode: "PV-221126-0119",
          userName: "Siti Rahmawati",
          locationName: "PIM 2",
          pickupLobby: "North Skywalk • Lobi Utama PIM 2",
          parkingArea: "P1 • Valet Premier V-11",
          shortSlot: "P1 V-11",
          vehicleName: "Hyundai Ioniq 5",
          plateNumber: "B 8821 EVR",
          vehicleSpecs: "Matte Grey • 2025",
          valetOfficerName: "Rizky Pratama",
          valetPaymentMethod: "BCA",
          valetFeeAmount: 35000,
          hourlyRate: 5000,
          statusText: "Selesai",
          isActive: false,
          parkingStartedAt: now - 86400 * 1000,
          frozenElapsedSeconds: 8100, // 2 jam 15 menit (3 jam parkir)
          journeySteps: [
            { title: "Diserahkan ke petugas", subtitle: "North Skywalk • Lobi Utama PIM 2", time: "13.00" },
            { title: "Terparkir aman", subtitle: "P1 • Valet Premier V-11", time: "13.06" },
            { title: "Selesai", subtitle: "Kendaraan diserahkan & lunas", time: "15.15" },
          ],
        },
      ],
      transactions: [
        {
          id: "TRX-261123-004",
          date: "Hari ini • 10.33",
          type: "Layanan valet",
          subtitle: "Pacific Place Jakarta • B 1042 TZX",
          method: "GoPay",
          amount: 35000,
        },
        {
          id: "TRX-261123-003",
          date: "Hari ini • 09.10",
          type: "Layanan valet",
          subtitle: "Senayan City • B 2148 SJD",
          method: "QRIS",
          amount: 35000,
        },
        {
          id: "TRX-261123-002",
          date: "Hari ini • 08.28",
          type: "Layanan valet",
          subtitle: "Grand Indonesia • B 1829 KLP",
          method: "Dompet PARVE",
          amount: 35000,
        },
        {
          id: "TRX-261122-091",
          date: "Kemarin • 15.15",
          type: "Parkir gedung",
          subtitle: "PIM 2 • B 8821 EVR (3 jam)",
          method: "BCA",
          amount: 15000,
        },
        {
          id: "TRX-261122-080",
          date: "Kemarin • 19.20",
          type: "Isi saldo",
          subtitle: "Top-Up Dompet PARVE • Dimas Pratama",
          method: "BCA",
          amount: 250000,
        },
      ],
      users: [
        {
          id: "usr-1",
          fullName: "Dimas Pratama",
          phone: "0812-8890-2211",
          email: "dimas@parve.id",
          walletBalance: 205000,
          vehicle: { name: "Toyota Veloz", plateNumber: "B 2148 SJD", specs: "Putih • 2024" },
        },
        {
          id: "usr-2",
          fullName: "Nadia Kusuma",
          phone: "0813-7741-9902",
          email: "nadia.k@gmail.com",
          walletBalance: 140000,
          vehicle: { name: "Honda HR-V", plateNumber: "B 1829 KLP", specs: "Hitam • 2024" },
        },
        {
          id: "usr-3",
          fullName: "Raka Mahendra",
          phone: "0857-1120-4488",
          email: "raka.m@outlook.com",
          walletBalance: 75000,
          vehicle: { name: "Honda Civic RS", plateNumber: "B 1042 TZX", specs: "Silver • 2023" },
        },
        {
          id: "usr-4",
          fullName: "Siti Rahmawati",
          phone: "0811-9023-6541",
          email: "siti.rahma@gmail.com",
          walletBalance: 320000,
          vehicle: { name: "Hyundai Ioniq 5", plateNumber: "B 8821 EVR", specs: "Matte Grey • 2025" },
        },
      ],
    };
  };

  let state = loadState();

  function loadState() {
    try {
      const raw = localStorage.getItem(STORAGE_KEY);
      if (raw) return JSON.parse(raw);
    } catch (_) {
      // Fallback ke data default jika storage rusak
    }
    const fresh = createDefaultState();
    saveState(fresh);
    return fresh;
  }

  function saveState(nextState = state) {
    state = nextState;
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
    } catch (_) {
      // Abaikan jika browser membatasi localStorage (misal mode file:// ketat)
    }
  }

  function resetState() {
    const fresh = createDefaultState();
    saveState(fresh);
    return fresh;
  }

  function formatRupiah(amount) {
    return "Rp" + Number(amount || 0).toLocaleString("id-ID");
  }

  function formatTimeDot(date = new Date()) {
    const hh = String(date.getHours()).padStart(2, "0");
    const mm = String(date.getMinutes()).padStart(2, "0");
    return `${hh}.${mm}`;
  }

  function formatIndonesianDateTime(date = new Date()) {
    const days = ["Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"];
    const months = [
      "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember",
    ];
    const hh = String(date.getHours()).padStart(2, "0");
    const mm = String(date.getMinutes()).padStart(2, "0");
    const ss = String(date.getSeconds()).padStart(2, "0");
    return `${days[date.getDay()]}, ${date.getDate()} ${months[date.getMonth()]} ${date.getFullYear()} • ${hh}:${mm}:${ss} WIB`;
  }

  function getElapsedSeconds(ticket) {
    if (ticket.frozenElapsedSeconds !== null && ticket.frozenElapsedSeconds !== undefined) {
      return ticket.frozenElapsedSeconds;
    }
    const diff = Math.floor((Date.now() - ticket.parkingStartedAt) / 1000);
    return Math.max(0, diff);
  }

  function formatStopwatch(totalSeconds) {
    const h = String(Math.floor(totalSeconds / 3600)).padStart(2, "0");
    const m = String(Math.floor((totalSeconds % 3600) / 60)).padStart(2, "0");
    const s = String(totalSeconds % 60).padStart(2, "0");
    return `${h}:${m}:${s}`;
  }

  function getAccumulatedHours(ticket) {
    const secs = getElapsedSeconds(ticket);
    if (secs <= 0) return 1;
    return Math.max(1, Math.ceil(secs / 3600));
  }

  function getParkingFee(ticket) {
    return getAccumulatedHours(ticket) * (ticket.hourlyRate || state.settings.hourlyRate);
  }

  function isMallOpen(mall, now = new Date()) {
    const mins = now.getHours() * 60 + now.getMinutes();
    return mins >= mall.openHour * 60 && mins < mall.closeHour * 60;
  }

  function getOccupiedSlots(mall) {
    const activeTicketCount = state.tickets.filter(
      (t) => t.isActive && t.locationName.toLowerCase() === mall.name.toLowerCase()
    ).length;
    const total = activeTicketCount + (mall.manualExtraSlots || 0);
    return Math.max(0, Math.min(mall.totalSlots, total));
  }

  function getAvailableSlots(mall) {
    return Math.max(0, mall.totalSlots - getOccupiedSlots(mall));
  }

  function generateTicketCode() {
    const now = new Date();
    const dd = String(now.getDate()).padStart(2, "0");
    const mm = String(now.getMonth() + 1).padStart(2, "0");
    const yy = String(now.getFullYear()).slice(-2);
    const rand = String(Math.floor(1000 + Math.random() * 9000));
    return `PV-${dd}${mm}${yy}-${rand}`;
  }

  function applySavedTheme() {
    let saved = "light";
    try {
      saved = localStorage.getItem(THEME_KEY) || "light";
    } catch (_) {
      saved = "light";
    }
    document.documentElement.setAttribute("data-theme", saved);
    return saved;
  }

  function toggleTheme() {
    const current = document.documentElement.getAttribute("data-theme") || "light";
    const next = current === "dark" ? "light" : "dark";
    document.documentElement.setAttribute("data-theme", next);
    try {
      localStorage.setItem(THEME_KEY, next);
    } catch (_) {}
    return next;
  }

  function escapeHtml(str) {
    return String(str ?? "")
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;");
  }

  return {
    getState: () => state,
    saveState,
    resetState,
    formatRupiah,
    formatTimeDot,
    formatIndonesianDateTime,
    getElapsedSeconds,
    formatStopwatch,
    getAccumulatedHours,
    getParkingFee,
    isMallOpen,
    getOccupiedSlots,
    getAvailableSlots,
    generateTicketCode,
    applySavedTheme,
    toggleTheme,
    escapeHtml,
  };
})();