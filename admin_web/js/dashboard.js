function initParveDashboard() {
  const session = Auth.requireAuth();
  if (!session) return;

  const {
    getState,
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
  } = ParveStore;

  const SECTION_TITLES = {
    overview: "Ringkasan Operasional",
    tickets: "Tiket & Valet Aktif",
    malls: "Lokasi & Slot Mall",
    transactions: "Transaksi & Pembayaran",
    users: "Pengguna & Kendaraan",
    settings: "Tarif & Petugas Valet",
  };

  let currentSection = "overview";
  let globalSearchQuery = "";

  // Inisialisasi header & tema
  document.getElementById("adminNameDisplay").textContent = session.name;
  const themeBtn = document.getElementById("themeToggleBtn");
  const updateThemeBtn = (theme) => {
    themeBtn.textContent = theme === "dark" ? "☀️ Terang" : "🌙 Gelap";
  };
  updateThemeBtn(applySavedTheme());

  themeBtn.addEventListener("click", () => {
    updateThemeBtn(toggleTheme());
  });

  document.getElementById("logoutBtn").addEventListener("click", () => {
    Auth.logout();
  });

  // Sidebar mobile toggle
  const sidebar = document.getElementById("sidebar");
  document.getElementById("sidebarToggle").addEventListener("click", () => {
    sidebar.classList.add("open");
  });
  document.getElementById("closeSidebarBtn").addEventListener("click", () => {
    sidebar.classList.remove("open");
  });

  // Navigasi antar menu
  function switchSection(sectionKey) {
    currentSection = sectionKey;
    document.querySelectorAll(".nav-item").forEach((btn) => {
      btn.classList.toggle("active", btn.dataset.section === sectionKey);
    });
    document.querySelectorAll(".page-section").forEach((sec) => {
      sec.classList.toggle("active", sec.id === `section-${sectionKey}`);
    });
    document.getElementById("pageTitle").textContent =
      SECTION_TITLES[sectionKey] || "Dashboard PARVE";
    sidebar.classList.remove("open");
    renderAll();
  }

  document.querySelectorAll(".nav-item").forEach((btn) => {
    btn.addEventListener("click", () => switchSection(btn.dataset.section));
  });

  document.querySelectorAll("[data-goto]").forEach((btn) => {
    btn.addEventListener("click", () => switchSection(btn.dataset.goto));
  });

  // Pencarian Global
  document.getElementById("globalSearch").addEventListener("input", (e) => {
    globalSearchQuery = e.target.value.trim().toLowerCase();
    renderAll();
  });

  // Filter Event Listeners
  document.getElementById("filterTicketStatus").addEventListener("change", renderTickets);
  document.getElementById("filterTicketMall").addEventListener("change", renderTickets);
  document.getElementById("filterTrxType").addEventListener("change", renderTransactions);
  document.getElementById("filterTrxMethod").addEventListener("change", renderTransactions);

  // Toast helper
  function showToast(message) {
    const container = document.getElementById("toastContainer");
    const toast = document.createElement("div");
    toast.className = "toast";
    toast.textContent = message;
    container.appendChild(toast);
    setTimeout(() => toast.remove(), 3200);
  }

  // Modal helpers
  function openModal(id) {
    document.getElementById(id).classList.remove("hidden");
  }
  function closeModal(id) {
    document.getElementById(id).classList.add("hidden");
  }

  document.querySelectorAll("[data-close-modal]").forEach((btn) => {
    btn.addEventListener("click", () => closeModal(btn.dataset.closeModal));
  });

  document.querySelectorAll(".modal-backdrop").forEach((backdrop) => {
    backdrop.addEventListener("click", (e) => {
      if (e.target === backdrop) backdrop.classList.add("hidden");
    });
  });

  function statusBadgeClass(status) {
    if (status === "Terparkir aman") return "badge-green";
    if (status === "Menuju lobi penjemputan") return "badge-warn";
    if (status === "Diserahkan ke petugas") return "badge-gold";
    return "badge-muted";
  }

  // Populasi dropdown dinamis (Mall & Petugas)
  function populateSelectOptions() {
    const state = getState();
    const filterMall = document.getElementById("filterTicketMall");
    const prevFilterMall = filterMall.value;
    filterMall.innerHTML =
      `<option value="all">Semua Mall</option>` +
      state.malls
        .map((m) => `<option value="${escapeHtml(m.name)}">${escapeHtml(m.name)}</option>`)
        .join("");
    filterMall.value = prevFilterMall || "all";

    const ntMall = document.getElementById("ntMall");
    ntMall.innerHTML = state.malls
      .map((m) => {
        const avail = getAvailableSlots(m);
        return `<option value="${escapeHtml(m.name)}">${escapeHtml(m.name)} (${avail}/${m.totalSlots} slot tersedia)</option>`;
      })
      .join("");

    const newOfficerMall = document.getElementById("newOfficerMall");
    newOfficerMall.innerHTML = state.malls
      .map((m) => `<option value="${escapeHtml(m.name)}">${escapeHtml(m.name)}</option>`)
      .join("");

    const ntOfficer = document.getElementById("ntOfficer");
    ntOfficer.innerHTML = state.officers
      .map(
        (o) =>
          `<option value="${escapeHtml(o.name)}">${escapeHtml(o.name)} (${escapeHtml(o.mallName)})</option>`
      )
      .join("");
  }

  // 1. RENDER OVERVIEW
  function renderOverview() {
    const state = getState();
    const activeTickets = state.tickets.filter((t) => t.isActive);
    const pickupRequests = activeTickets.filter(
      (t) => t.statusText === "Menuju lobi penjemputan"
    ).length;

    const totalSlots = state.malls.reduce((sum, m) => sum + m.totalSlots, 0);
    const totalOccupied = state.malls.reduce((sum, m) => sum + getOccupiedSlots(m), 0);
    const totalAvailable = totalSlots - totalOccupied;

    const serviceRevenue = state.transactions
      .filter((t) => t.type !== "Isi saldo")
      .reduce((sum, t) => sum + t.amount, 0);

    document.getElementById("navActiveBadge").textContent = activeTickets.length;

    document.getElementById("overviewKpis").innerHTML = `
      <div class="kpi-card hero">
        <span class="kpi-label">Total Pendapatan Layanan</span>
        <span class="kpi-value">${formatRupiah(serviceRevenue)}</span>
        <span class="kpi-sub">Valet &amp; Parkir Gedung (di luar Top-Up)</span>
      </div>
      <div class="kpi-card">
        <span class="kpi-label">Tiket Valet Aktif</span>
        <span class="kpi-value">${activeTickets.length}</span>
        <span class="kpi-sub">${state.tickets.length - activeTickets.length} riwayat selesai</span>
      </div>
      <div class="kpi-card">
        <span class="kpi-label">Sisa Slot Tersedia</span>
        <span class="kpi-value">${totalAvailable} / ${totalSlots}</span>
        <span class="kpi-sub">${totalOccupied} slot sedang terisi di 5 mall</span>
      </div>
      <div class="kpi-card">
        <span class="kpi-label">Permintaan Ambil Mobil</span>
        <span class="kpi-value">${pickupRequests}</span>
        <span class="kpi-sub">Menunggu penyerahan di lobi</span>
      </div>
    `;

    document.getElementById("overviewMallList").innerHTML = state.malls
      .map((m) => {
        const occ = getOccupiedSlots(m);
        const avail = getAvailableSlots(m);
        const pct = Math.round((occ / m.totalSlots) * 100);
        const open = isMallOpen(m);
        const badge = !open
          ? `<span class="badge badge-muted">Tutup</span>`
          : avail === 0
          ? `<span class="badge badge-danger">Penuh</span>`
          : `<span class="badge badge-green">${avail} Tersedia</span>`;

        return `
          <div class="mall-mini-item">
            <div class="mall-mini-top">
              <div>
                <strong>${escapeHtml(m.name)}</strong>
                <div class="muted-text">${escapeHtml(m.lobbySubtitle)}</div>
              </div>
              ${badge}
            </div>
            <div class="progress-track">
              <div class="progress-fill ${avail === 0 ? "full" : ""}" style="width: ${pct}%"></div>
            </div>
          </div>
        `;
      })
      .join("");

    const recentEl = document.getElementById("overviewRecentTickets");
    if (activeTickets.length === 0) {
      recentEl.innerHTML = `<p class="muted-text">Belum ada tiket aktif saat ini.</p>`;
    } else {
      recentEl.innerHTML = activeTickets
        .slice(0, 5)
        .map((t) => {
          const secs = getElapsedSeconds(t);
          return `
            <div class="recent-item">
              <div>
                <strong>${escapeHtml(t.ticketCode)}</strong> • ${escapeHtml(t.plateNumber)}
                <div class="muted-text">${escapeHtml(t.locationName)} — ${escapeHtml(t.userName)}</div>
              </div>
              <div style="text-align:right">
                <div class="stopwatch-pill" data-stopwatch-id="${t.id}">${formatStopwatch(secs)}</div>
                <div><span class="badge ${statusBadgeClass(t.statusText)}">${escapeHtml(t.statusText)}</span></div>
              </div>
            </div>
          `;
        })
        .join("");
    }
  }

  // 2. RENDER TIKET
  function renderTickets() {
    const state = getState();
    const statusFilter = document.getElementById("filterTicketStatus").value;
    const mallFilter = document.getElementById("filterTicketMall").value;

    const filtered = state.tickets.filter((t) => {
      if (statusFilter === "active" && !t.isActive) return false;
      if (statusFilter !== "all" && statusFilter !== "active" && t.statusText !== statusFilter)
        return false;
      if (mallFilter !== "all" && t.locationName !== mallFilter) return false;
      if (globalSearchQuery) {
        const hay = `${t.ticketCode} ${t.userName} ${t.vehicleName} ${t.plateNumber} ${t.locationName} ${t.valetOfficerName}`.toLowerCase();
        if (!hay.includes(globalSearchQuery)) return false;
      }
      return true;
    });

    const tbody = document.getElementById("ticketsTableBody");
    if (filtered.length === 0) {
      tbody.innerHTML = `<tr><td colspan="7" class="muted-text" style="text-align:center;padding:24px;">Tidak ada tiket yang sesuai filter.</td></tr>`;
      return;
    }

    tbody.innerHTML = filtered
      .map((t) => {
        const secs = getElapsedSeconds(t);
        const hours = getAccumulatedHours(t);
        const parkFee = getParkingFee(t);

        return `
          <tr>
            <td>
              <strong>${escapeHtml(t.ticketCode)}</strong>
              <div class="muted-text">Valet: ${escapeHtml(t.valetPaymentMethod)}</div>
            </td>
            <td>
              <strong>${escapeHtml(t.userName)}</strong>
              <div class="muted-text">${escapeHtml(t.vehicleName)} • <strong>${escapeHtml(t.plateNumber)}</strong></div>
            </td>
            <td>
              <strong>${escapeHtml(t.locationName)}</strong>
              <div class="muted-text">${escapeHtml(t.parkingArea)}</div>
            </td>
            <td>${escapeHtml(t.valetOfficerName)}</td>
            <td>
              <div class="stopwatch-pill" data-stopwatch-id="${t.id}">${formatStopwatch(secs)}</div>
              <div class="muted-text" data-fee-id="${t.id}">${hours} jam • ${formatRupiah(parkFee)}</div>
            </td>
            <td>
              <span class="badge ${statusBadgeClass(t.statusText)}">${escapeHtml(t.statusText)}</span>
            </td>
            <td>
              <div class="action-group">
                <button class="btn btn-subtle btn-sm" data-detail-ticket="${t.id}" type="button">Detail</button>
                ${
                  t.isActive
                    ? `<button class="btn btn-gold btn-sm" data-complete-ticket="${t.id}" type="button">Selesaikan</button>`
                    : ""
                }
              </div>
            </td>
          </tr>
        `;
      })
      .join("");
  }

  // 3. RENDER MALLS
  function renderMalls() {
    const state = getState();
    const totalSlots = state.malls.reduce((s, m) => s + m.totalSlots, 0);
    const totalOcc = state.malls.reduce((s, m) => s + getOccupiedSlots(m), 0);
    document.getElementById("mallSummaryPill").textContent = `Total ${totalOcc}/${totalSlots} Slot Terisi`;

    const filteredMalls = state.malls.filter((m) =>
      !globalSearchQuery ||
      `${m.name} ${m.address} ${m.lobbySubtitle}`.toLowerCase().includes(globalSearchQuery)
    );

    document.getElementById("mallsGrid").innerHTML = filteredMalls
      .map((m) => {
        const occ = getOccupiedSlots(m);
        const avail = getAvailableSlots(m);
        const pct = Math.round((occ / m.totalSlots) * 100);
        const open = isMallOpen(m);
        const statusBadge = !open
          ? `<span class="badge badge-muted">Mall Tutup (10.00–22.00)</span>`
          : avail === 0
          ? `<span class="badge badge-danger">Parkir Penuh</span>`
          : `<span class="badge badge-green">Buka • Tersedia</span>`;

        return `
          <div class="mall-card">
            <div class="mall-card-top">
              <div>
                <h3>${escapeHtml(m.name)}</h3>
                <div class="muted-text">${escapeHtml(m.lobbySubtitle)}</div>
              </div>
              ${statusBadge}
            </div>

            <div class="mall-meta">
              <span>📍 ${escapeHtml(m.address)}</span>
              <span>🅿️ ${escapeHtml(m.parkingArea)} (${escapeHtml(m.shortSlot)})</span>
              <span>🕒 ${String(m.openHour).padStart(2, "0")}.00 – ${String(m.closeHour).padStart(2, "0")}.00 WIB</span>
            </div>

            <div>
              <div style="display:flex;justify-content:space-between;font-size:0.84rem;margin-bottom:6px;">
                <strong>${avail} dari ${m.totalSlots} slot tersedia</strong>
                <span class="muted-text">${occ} terisi (${pct}%)</span>
              </div>
              <div class="progress-track">
                <div class="progress-fill ${avail === 0 ? "full" : ""}" style="width:${pct}%"></div>
              </div>
            </div>

            <div class="facility-tags">
              ${m.facilities.map((f) => `<span class="facility-tag">${escapeHtml(f)}</span>`).join("")}
            </div>

            <div class="mall-controls">
              <span class="muted-text">Simulasi Slot Manual:</span>
              <div class="action-group">
                <button class="btn btn-subtle btn-sm" data-slot-delta="-1" data-mall-id="${m.id}" type="button">-1</button>
                <button class="btn btn-subtle btn-sm" data-slot-delta="1" data-mall-id="${m.id}" type="button">+1</button>
                <button class="btn btn-subtle btn-sm" data-slot-reset="${m.id}" type="button">Reset</button>
              </div>
            </div>
          </div>
        `;
      })
      .join("");
  }

  // 4. RENDER TRANSAKSI
  function renderTransactions() {
    const state = getState();
    const typeFilter = document.getElementById("filterTrxType").value;
    const methodFilter = document.getElementById("filterTrxMethod").value;

    const valetTotal = state.transactions
      .filter((t) => t.type === "Layanan valet")
      .reduce((s, t) => s + t.amount, 0);
    const parkTotal = state.transactions
      .filter((t) => t.type === "Parkir gedung")
      .reduce((s, t) => s + t.amount, 0);
    const topupTotal = state.transactions
      .filter((t) => t.type === "Isi saldo")
      .reduce((s, t) => s + t.amount, 0);

    document.getElementById("transactionKpis").innerHTML = `
      <div class="kpi-card hero">
        <span class="kpi-label">Pendapatan Layanan Valet</span>
        <span class="kpi-value">${formatRupiah(valetTotal)}</span>
        <span class="kpi-sub">Tarif aktif ${formatRupiah(state.settings.valetFee)}/sesi</span>
      </div>
      <div class="kpi-card">
        <span class="kpi-label">Pendapatan Parkir Gedung</span>
        <span class="kpi-value">${formatRupiah(parkTotal)}</span>
        <span class="kpi-sub">Tarif aktif ${formatRupiah(state.settings.hourlyRate)}/jam</span>
      </div>
      <div class="kpi-card">
        <span class="kpi-label">Total Top-Up Dompet PARVE</span>
        <span class="kpi-value">${formatRupiah(topupTotal)}</span>
        <span class="kpi-sub">Saldo masuk pelanggan</span>
      </div>
    `;

    const filtered = state.transactions.filter((t) => {
      if (typeFilter !== "all" && t.type !== typeFilter) return false;
      if (methodFilter !== "all" && t.method !== methodFilter) return false;
      if (globalSearchQuery) {
        const hay = `${t.id} ${t.type} ${t.subtitle} ${t.method}`.toLowerCase();
        if (!hay.includes(globalSearchQuery)) return false;
      }
      return true;
    });

    const tbody = document.getElementById("transactionsTableBody");
    if (filtered.length === 0) {
      tbody.innerHTML = `<tr><td colspan="6" class="muted-text" style="text-align:center;padding:24px;">Tidak ada transaksi ditemukan.</td></tr>`;
      return;
    }

    tbody.innerHTML = filtered
      .map(
        (t) => `
        <tr>
          <td><strong>${escapeHtml(t.id)}</strong></td>
          <td>${escapeHtml(t.date)}</td>
          <td><span class="badge ${t.type === "Isi saldo" ? "badge-green" : "badge-gold"}">${escapeHtml(t.type)}</span></td>
          <td>${escapeHtml(t.subtitle)}</td>
          <td>${escapeHtml(t.method)}</td>
          <td><strong>${formatRupiah(t.amount)}</strong></td>
        </tr>
      `
      )
      .join("");
  }

  // 5. RENDER PENGGUNA
  function renderUsers() {
    const state = getState();
    const filtered = state.users.filter((u) => {
      if (!globalSearchQuery) return true;
      const hay = `${u.fullName} ${u.email} ${u.phone} ${u.vehicle.name} ${u.vehicle.plateNumber}`.toLowerCase();
      return hay.includes(globalSearchQuery);
    });

    const tbody = document.getElementById("usersTableBody");
    tbody.innerHTML = filtered
      .map(
        (u) => `
        <tr>
          <td><strong>${escapeHtml(u.fullName)}</strong></td>
          <td>
            <div>${escapeHtml(u.phone)}</div>
            <div class="muted-text">${escapeHtml(u.email)}</div>
          </td>
          <td>
            <strong>${escapeHtml(u.vehicle.name)}</strong>
            <div class="muted-text">${escapeHtml(u.vehicle.specs)}</div>
          </td>
          <td><span class="badge badge-muted">${escapeHtml(u.vehicle.plateNumber)}</span></td>
          <td><strong>${formatRupiah(u.walletBalance)}</strong></td>
          <td>
            <button class="btn btn-gold btn-sm" data-topup-user="${u.id}" type="button">+ Isi Saldo</button>
          </td>
        </tr>
      `
      )
      .join("");
  }

  // 6. RENDER PENGATURAN
  function renderSettings() {
    const state = getState();
    document.getElementById("inputValetFee").value = state.settings.valetFee;
    document.getElementById("inputHourlyRate").value = state.settings.hourlyRate;

    document.getElementById("officersList").innerHTML = state.officers
      .map(
        (o) => `
        <div class="officer-item">
          <div>
            <strong>${escapeHtml(o.name)}</strong>
            <div class="muted-text">Penempatan: ${escapeHtml(o.mallName)}</div>
          </div>
          <button class="btn btn-danger btn-sm" data-delete-officer="${o.id}" type="button">Hapus</button>
        </div>
      `
      )
      .join("");
  }

  function renderAll() {
    populateSelectOptions();
    renderOverview();
    renderTickets();
    renderMalls();
    renderTransactions();
    renderUsers();
    renderSettings();
  }

  // AKSI: BUAT TIKET BARU
  document.getElementById("openNewTicketBtn").addEventListener("click", () => {
    populateSelectOptions();
    openModal("ticketModal");
  });

  document.getElementById("newTicketForm").addEventListener("submit", (e) => {
    e.preventDefault();
    const state = getState();
    const mallName = document.getElementById("ntMall").value;
    const mall = state.malls.find((m) => m.name === mallName);

    if (!mall || getAvailableSlots(mall) <= 0) {
      showToast(`Slot parkir di ${mallName} sedang penuh!`);
      return;
    }

    const userName = document.getElementById("ntCustomer").value.trim();
    const vehicleName = document.getElementById("ntVehicle").value.trim();
    const plateNumber = document.getElementById("ntPlate").value.trim().toUpperCase();
    const vehicleSpecs = document.getElementById("ntSpecs").value.trim();
    const officerName = document.getElementById("ntOfficer").value;
    const paymentMethod = document.getElementById("ntPayment").value;

    const code = generateTicketCode();
    const timeNow = formatTimeDot();

    const newTicket = {
      id: `tkt-${Date.now()}`,
      ticketCode: code,
      userName,
      locationName: mall.name,
      pickupLobby: mall.lobbySubtitle,
      parkingArea: mall.parkingArea,
      shortSlot: mall.shortSlot,
      vehicleName,
      plateNumber,
      vehicleSpecs,
      valetOfficerName: officerName,
      valetPaymentMethod: paymentMethod,
      valetFeeAmount: state.settings.valetFee,
      hourlyRate: state.settings.hourlyRate,
      statusText: "Diserahkan ke petugas",
      isActive: true,
      parkingStartedAt: Date.now(),
      frozenElapsedSeconds: null,
      journeySteps: [
        {
          title: "Diserahkan ke petugas",
          subtitle: mall.lobbySubtitle,
          time: timeNow,
        },
      ],
    };

    state.tickets.unshift(newTicket);
    state.transactions.unshift({
      id: `TRX-${Date.now().toString().slice(-8)}`,
      date: `Hari ini • ${timeNow}`,
      type: "Layanan valet",
      subtitle: `${mall.name} • ${plateNumber}`,
      method: paymentMethod,
      amount: state.settings.valetFee,
    });

    saveState(state);
    e.target.reset();
    closeModal("ticketModal");
    renderAll();
    showToast(`Tiket ${code} berhasil diterbitkan di ${mall.name}.`);
  });

  // AKSI: DETAIL TIKET & UPDATE STATUS
  function openTicketDetail(ticketId) {
    const state = getState();
    const ticket = state.tickets.find((t) => t.id === ticketId);
    if (!ticket) return;

    const secs = getElapsedSeconds(ticket);
    const hours = getAccumulatedHours(ticket);
    const parkFee = getParkingFee(ticket);

    document.getElementById("detailTicketCode").textContent = ticket.ticketCode;
    document.getElementById("detailTicketSubtitle").textContent = `${ticket.locationName} • ${ticket.parkingArea}`;

    document.getElementById("detailModalBody").innerHTML = `
      <div class="detail-grid">
        <div class="detail-box">
          <small>Pelanggan &amp; Kendaraan</small>
          <strong>${escapeHtml(ticket.userName)}</strong>
          <div>${escapeHtml(ticket.vehicleName)} (${escapeHtml(ticket.plateNumber)})</div>
          <div class="muted-text">${escapeHtml(ticket.vehicleSpecs)}</div>
        </div>
        <div class="detail-box">
          <small>Durasi &amp; Estimasi Biaya Parkir</small>
          <div class="stopwatch-pill">${formatStopwatch(secs)}</div>
          <div>${hours} jam × ${formatRupiah(ticket.hourlyRate)} = <strong>${formatRupiah(parkFee)}</strong></div>
          <div class="muted-text">Valet (${formatRupiah(ticket.valetFeeAmount)}) lunas via ${escapeHtml(ticket.valetPaymentMethod)}</div>
        </div>
      </div>

      ${
        ticket.isActive
          ? `
        <div class="detail-box" style="margin-bottom:14px;">
          <small>Perbarui Tahap Perjalanan Kendaraan</small>
          <div class="action-group" style="margin-top:8px;">
            <button class="btn btn-subtle btn-sm" data-set-status="Diserahkan ke petugas" data-tid="${ticket.id}" type="button">1. Diserahkan</button>
            <button class="btn btn-subtle btn-sm" data-set-status="Terparkir aman" data-tid="${ticket.id}" type="button">2. Terparkir Aman</button>
            <button class="btn btn-subtle btn-sm" data-set-status="Menuju lobi penjemputan" data-tid="${ticket.id}" type="button">3. Menuju Lobi</button>
            <button class="btn btn-gold btn-sm" data-complete-ticket="${ticket.id}" type="button">4. Selesaikan &amp; Bayar</button>
          </div>
        </div>
      `
          : ""
      }

      <strong>Riwayat Perjalanan Kendaraan</strong>
      <div class="journey-list">
        ${ticket.journeySteps
          .map(
            (step) => `
          <div class="journey-step">
            <div>
              <strong>${escapeHtml(step.title)}</strong>
              <div class="muted-text">${escapeHtml(step.subtitle)}</div>
            </div>
            <strong>${escapeHtml(step.time)} WIB</strong>
          </div>
        `
          )
          .join("")}
      </div>
    `;

    openModal("detailModal");
  }

  function updateTicketStatus(ticketId, nextStatus) {
    const state = getState();
    const ticket = state.tickets.find((t) => t.id === ticketId);
    if (!ticket || !ticket.isActive) return;

    ticket.statusText = nextStatus;
    const subtitleMap = {
      "Diserahkan ke petugas": ticket.pickupLobby,
      "Terparkir aman": ticket.parkingArea,
      "Menuju lobi penjemputan": `Petugas ${ticket.valetOfficerName} membawa kendaraan ke lobi`,
    };
    ticket.journeySteps.push({
      title: nextStatus,
      subtitle: subtitleMap[nextStatus] || ticket.locationName,
      time: formatTimeDot(),
    });

    saveState(state);
    renderAll();
    openTicketDetail(ticketId);
    showToast(`Status ${ticket.ticketCode} diperbarui: ${nextStatus}`);
  }

  function completeTicket(ticketId) {
    const state = getState();
    const ticket = state.tickets.find((t) => t.id === ticketId);
    if (!ticket || !ticket.isActive) return;

    const elapsed = getElapsedSeconds(ticket);
    const hours = Math.max(1, Math.ceil(elapsed / 3600));
    const parkingFee = hours * ticket.hourlyRate;
    const timeNow = formatTimeDot();

    ticket.frozenElapsedSeconds = elapsed;
    ticket.isActive = false;
    ticket.statusText = "Selesai";
    ticket.journeySteps.push({
      title: "Selesai",
      subtitle: `Kendaraan diserahkan • Parkir ${hours} jam (${formatRupiah(parkingFee)}) lunas`,
      time: timeNow,
    });

    state.transactions.unshift({
      id: `TRX-${Date.now().toString().slice(-8)}`,
      date: `Hari ini • ${timeNow}`,
      type: "Parkir gedung",
      subtitle: `${ticket.locationName} • ${ticket.plateNumber} (${hours} jam)`,
      method: ticket.valetPaymentMethod,
      amount: parkingFee,
    });

    saveState(state);
    closeModal("detailModal");
    renderAll();
    showToast(`Tiket ${ticket.ticketCode} selesai. 1 slot di ${ticket.locationName} kembali tersedia.`);
  }

  // EVENT DELEGATION UNTUK SEMUA TOMBOL DINAMIS
  document.addEventListener("click", (e) => {
    const detailBtn = e.target.closest("[data-detail-ticket]");
    if (detailBtn) {
      openTicketDetail(detailBtn.dataset.detailTicket);
      return;
    }

    const completeBtn = e.target.closest("[data-complete-ticket]");
    if (completeBtn) {
      completeTicket(completeBtn.dataset.completeTicket);
      return;
    }

    const statusBtn = e.target.closest("[data-set-status]");
    if (statusBtn) {
      updateTicketStatus(statusBtn.dataset.tid, statusBtn.dataset.setStatus);
      return;
    }

    const slotDeltaBtn = e.target.closest("[data-slot-delta]");
    if (slotDeltaBtn) {
      const state = getState();
      const mall = state.malls.find((m) => m.id === slotDeltaBtn.dataset.mallId);
      if (mall) {
        const delta = Number(slotDeltaBtn.dataset.slotDelta);
        const activeCount = state.tickets.filter(
          (t) => t.isActive && t.locationName === mall.name
        ).length;
        const maxExtra = Math.max(0, mall.totalSlots - activeCount);
        mall.manualExtraSlots = Math.max(0, Math.min(maxExtra, (mall.manualExtraSlots || 0) + delta));
        saveState(state);
        renderAll();
      }
      return;
    }

    const slotResetBtn = e.target.closest("[data-slot-reset]");
    if (slotResetBtn) {
      const state = getState();
      const mall = state.malls.find((m) => m.id === slotResetBtn.dataset.slotReset);
      if (mall) {
        mall.manualExtraSlots = 0;
        saveState(state);
        renderAll();
        showToast(`Slot manual ${mall.name} direset.`);
      }
      return;
    }

    const topupBtn = e.target.closest("[data-topup-user]");
    if (topupBtn) {
      const state = getState();
      const user = state.users.find((u) => u.id === topupBtn.dataset.topupUser);
      if (user) {
        document.getElementById("topupUserId").value = user.id;
        document.getElementById("topupUserLabel").textContent =
          `Pelanggan: ${user.fullName} (Saldo saat ini: ${formatRupiah(user.walletBalance)})`;
        openModal("topupModal");
      }
      return;
    }

    const delOfficerBtn = e.target.closest("[data-delete-officer]");
    if (delOfficerBtn) {
      const state = getState();
      state.officers = state.officers.filter((o) => o.id !== delOfficerBtn.dataset.deleteOfficer);
      saveState(state);
      renderAll();
      showToast("Petugas berhasil dihapus.");
    }
  });

  // TOP-UP SALDO PELANGGAN
  document.getElementById("topupForm").addEventListener("submit", (e) => {
    e.preventDefault();
    const state = getState();
    const userId = document.getElementById("topupUserId").value;
    const amount = Number(document.getElementById("topupAmount").value);
    const method = document.getElementById("topupMethod").value;

    const user = state.users.find((u) => u.id === userId);
    if (!user || amount <= 0) return;

    user.walletBalance += amount;
    state.transactions.unshift({
      id: `TRX-${Date.now().toString().slice(-8)}`,
      date: `Hari ini • ${formatTimeDot()}`,
      type: "Isi saldo",
      subtitle: `Top-Up Dompet PARVE • ${user.fullName}`,
      method,
      amount,
    });

    saveState(state);
    closeModal("topupModal");
    renderAll();
    showToast(`Berhasil top-up ${formatRupiah(amount)} untuk ${user.fullName}.`);
  });

  // PENGATURAN TARIF
  document.getElementById("tariffForm").addEventListener("submit", (e) => {
    e.preventDefault();
    const state = getState();
    state.settings.valetFee = Number(document.getElementById("inputValetFee").value);
    state.settings.hourlyRate = Number(document.getElementById("inputHourlyRate").value);
    saveState(state);
    renderAll();
    showToast("Tarif valet & parkir gedung berhasil disimpan.");
  });

  // TAMBAH PETUGAS VALET
  document.getElementById("officerForm").addEventListener("submit", (e) => {
    e.preventDefault();
    const state = getState();
    const name = document.getElementById("newOfficerName").value.trim();
    const mallName = document.getElementById("newOfficerMall").value;
    if (!name) return;

    state.officers.push({
      id: `off-${Date.now()}`,
      name,
      mallName,
    });
    saveState(state);
    e.target.reset();
    renderAll();
    showToast(`Petugas ${name} ditambahkan.`);
  });

  // RESET DATA DEMO
  document.getElementById("resetDemoBtn").addEventListener("click", () => {
    if (confirm("Kembalikan seluruh data admin PARVE ke kondisi awal demo?")) {
      resetState();
      renderAll();
      showToast("Data simulasi berhasil direset.");
    }
  });

  // EXPORT CSV TRANSAKSI
  document.getElementById("exportCsvBtn").addEventListener("click", () => {
    const state = getState();
    const rows = [
      ["ID Transaksi", "Tanggal & Waktu", "Jenis Layanan", "Keterangan", "Metode Pembayaran", "Nominal (Rp)"],
      ...state.transactions.map((t) => [t.id, t.date, t.type, t.subtitle, t.method, t.amount]),
    ];
    const csv = rows
      .map((r) => r.map((cell) => `"${String(cell).replace(/"/g, '""')}"`).join(","))
      .join("\n");

    const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = "laporan-transaksi-parve.csv";
    link.click();
    URL.revokeObjectURL(url);
    showToast("File laporan-transaksi-parve.csv berhasil diunduh.");
  });

  // TICKER REAL-TIME (Jam WIB & Stopwatch Tiket Aktif setiap 1 detik)
  function tickRealTime() {
    document.getElementById("liveDateTime").textContent = formatIndonesianDateTime();
    const state = getState();
    state.tickets.forEach((t) => {
      if (!t.isActive) return;
      const secs = getElapsedSeconds(t);
      document.querySelectorAll(`[data-stopwatch-id="${t.id}"]`).forEach((el) => {
        el.textContent = formatStopwatch(secs);
      });
      document.querySelectorAll(`[data-fee-id="${t.id}"]`).forEach((el) => {
        el.textContent = `${getAccumulatedHours(t)} jam • ${formatRupiah(getParkingFee(t))}`;
      });
    });
  }

  renderAll();
  tickRealTime();
  setInterval(tickRealTime, 1000);
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initParveDashboard);
} else {
  initParveDashboard();
}