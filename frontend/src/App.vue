<template>
  <!-- Contenedor Principal Pantalla Completa -->
  <div class="flex h-screen w-full bg-slate-50 overflow-hidden font-sans text-slate-800">

    <!-- ================= SIDEBAR (SOLO PC) ================= -->
    <aside v-if="isLoggedIn" class="hidden md:flex flex-col w-64 bg-[#1e3a5f] text-white shrink-0 transition-all">
      <div class="p-6 border-b border-white/10 flex items-center gap-3">
        <img src="/logo.png" alt="Logo" class="w-10 h-10 object-contain bg-white rounded-lg p-1">
        <div>
          <h1 class="text-sm font-bold tracking-tight leading-tight">CS Préstamos</h1>
          <p class="text-[9px] text-blue-200">Ciencias de la Computación</p>
        </div>
      </div>
      
      <nav class="flex-1 py-6 px-4 space-y-2 overflow-y-auto">
        <template v-if="role === 'student'">
          <button @click="view = 'student-home'" :class="['w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-colors', view === 'student-home' ? 'bg-blue-600/30 text-white' : 'text-slate-300 hover:bg-white/5 hover:text-white']">
            <span>🏠</span> Inicio
          </button>
          <button @click="scrollToCategory('all')" :class="['w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-colors', view === 'catalog' || view === 'item-detail' ? 'bg-blue-600/30 text-white' : 'text-slate-300 hover:bg-white/5 hover:text-white']">
            <span>🗂️</span> Catálogo
          </button>
        </template>
        
        <template v-else-if="role === 'operator'">
          <button @click="view = 'operator-home'" :class="['w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-colors', view === 'operator-home' ? 'bg-blue-600/30 text-white' : 'text-slate-300 hover:bg-white/5 hover:text-white']">
            <span>📦</span> Panel Operador
          </button>
          <button @click="scrollToCategory('all')" :class="['w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-colors', view === 'catalog' || view === 'item-detail' ? 'bg-blue-600/30 text-white' : 'text-slate-300 hover:bg-white/5 hover:text-white']">
            <span>🗂️</span> Catálogo
          </button>
        </template>

        <template v-else-if="role === 'admin'">
          <button @click="view = 'admin-appeals'" :class="['w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-colors', view === 'admin-appeals' ? 'bg-blue-600/30 text-white' : 'text-slate-300 hover:bg-white/5 hover:text-white']">
            <span>⚖️</span> Apelaciones
            <span v-if="pendingAppealsCount > 0" class="ml-auto bg-red-500 text-white text-[10px] font-bold px-2 py-0.5 rounded-full">{{ pendingAppealsCount }}</span>
          </button>
          <button @click="view = 'admin-users'" :class="['w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-colors', view === 'admin-users' ? 'bg-blue-600/30 text-white' : 'text-slate-300 hover:bg-white/5 hover:text-white']">
            <span>👥</span> Usuarios
          </button>
          <button @click="view = 'admin-catalog'" :class="['w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-colors', view === 'admin-catalog' ? 'bg-blue-600/30 text-white' : 'text-slate-300 hover:bg-white/5 hover:text-white']">
            <span>🗂️</span> Catálogo
          </button>
          <button @click="view = 'operator-home'" :class="['w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-colors', view === 'operator-home' ? 'bg-blue-600/30 text-white' : 'text-slate-300 hover:bg-white/5 hover:text-white']">
            <span>📦</span> Panel Operador
          </button>
        </template>
      </nav>

      <div class="p-4 border-t border-white/10">
        <button @click="showMainView" class="w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium text-red-400 hover:bg-red-500/10 hover:text-red-300 transition-colors">
          <span>🚪</span> Cerrar sesión
        </button>
      </div>
    </aside>

    <!-- Área Principal de Contenido -->
    <div class="flex-1 flex flex-col h-full overflow-hidden relative">
      
      <!-- ================= TOPBAR (SOLO PC) ================= -->
      <header v-if="isLoggedIn" class="hidden md:flex items-center justify-between bg-white px-8 py-4 border-b border-slate-200 shrink-0">
        <h2 class="text-lg font-bold text-slate-800 tracking-tight">
          {{ viewTitle }}
        </h2>
        <div class="flex items-center gap-4">
          <div class="text-right">
            <p class="text-sm font-bold text-slate-800">{{ currentUser?.name }}</p>
            <p class="text-xs text-slate-500">{{ currentUser?.email }}</p>
          </div>
          <div class="w-10 h-10 rounded-full bg-[#1e3a5f] text-white flex items-center justify-center font-bold text-lg">
            {{ currentUser?.name.charAt(0).toUpperCase() }}
          </div>
        </div>
      </header>

      <!-- Contenedor scrolleable de las vistas -->
      <main class="flex-1 overflow-y-auto relative w-full h-full">

        <!-- ================= VISTAS DE AUTENTICACIÓN (CENTRADAS) ================= -->
        <div v-show="!isLoggedIn" class="min-h-full flex items-center justify-center p-4 md:p-8 bg-slate-100">
          <div class="w-full max-w-md bg-white rounded-[24px] shadow-xl overflow-hidden border border-slate-200 flex flex-col">
            
            <!-- Login -->
            <template v-if="view === 'main'">
              <header class="bg-[#1e3a5f] text-white pt-8 pb-6 px-6 text-center rounded-b-[32px]">
                <img src="/logo.png" alt="Logo" class="w-24 h-24 object-contain mx-auto mb-3 bg-white/10 rounded-2xl p-2">
                <h1 class="text-2xl font-bold tracking-tight">CS Préstamos</h1>
                <p class="text-sm text-blue-200 mt-1">Escuela de Cs. de la Computación</p>
              </header>
              <div class="px-8 py-6 flex flex-col gap-4">
                <div class="text-center mb-2">
                  <h2 class="text-slate-800 font-bold text-xl mb-1">Inicia sesión</h2>
                  <p class="text-slate-500 text-sm">Usa tu cuenta institucional</p>
                </div>
                <button @click="showGoogleView" class="w-full py-3 px-4 border border-slate-300 rounded-xl hover:bg-slate-50 transition text-slate-700 text-sm font-medium flex items-center justify-center gap-3 shadow-sm">
                  <img src="/images.png" alt="Google" class="w-5 h-5 object-contain"> Continuar con Google
                </button>
                <div class="flex items-center my-2">
                  <div class="flex-grow border-t border-slate-200"></div>
                  <span class="px-4 text-slate-400 text-xs">o</span>
                  <div class="flex-grow border-t border-slate-200"></div>
                </div>
                <div class="flex flex-col gap-1.5">
                  <label class="text-xs font-bold text-slate-600 tracking-wider">CORREO INSTITUCIONAL</label>
                  <input type="text" v-model="emailInput" placeholder="usuario@unsa.edu.pe" class="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm text-slate-700 focus:outline-none focus:border-blue-500">
                </div>
                <div class="flex flex-col gap-1.5">
                  <label class="text-xs font-bold text-slate-600 tracking-wider">CONTRASEÑA</label>
                  <div class="relative">
                    <input :type="passwordVisible ? 'text' : 'password'" v-model="password" class="w-full px-4 py-3 pr-12 border border-slate-300 rounded-xl text-sm text-slate-700 focus:outline-none focus:border-blue-500">
                    <span @click="passwordVisible = !passwordVisible" class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 text-sm cursor-pointer font-medium hover:text-slate-600">
                      {{ passwordVisible ? 'Ocultar' : 'Ver' }}
                    </span>
                  </div>
                </div>
                <button @click="handleLogin" :disabled="loggingIn" class="w-full py-3 text-white rounded-xl text-sm font-bold shadow-sm transition-all duration-200 mt-2" :class="loggingIn ? 'bg-[#3b659c]' : 'bg-[#1e3a5f] hover:bg-[#152a45]'">
                  {{ loggingIn ? 'Ingresando...' : 'Ingresar' }}
                </button>
                <div class="text-center mt-2">
                  <a href="#" @click.prevent="showRegisterView" class="text-blue-600 text-sm font-medium hover:underline">¿No tienes cuenta? Regístrate</a>
                </div>
              </div>
            </template>

            <!-- Google -->
            <template v-if="view === 'google'">
              <header class="bg-[#1e3a5f] text-white pt-8 pb-6 px-6 text-center rounded-b-[32px]">
                <img src="/logo.png" alt="Logo" class="w-24 h-24 object-contain mx-auto mb-3 bg-white/10 rounded-2xl p-2">
                <h1 class="text-2xl font-bold tracking-tight">CS Préstamos</h1>
              </header>
              <div class="p-8 flex flex-col gap-4">
                <div class="flex flex-col items-center justify-center mb-4">
                  <div class="w-16 h-16 rounded-full border border-slate-200 flex items-center justify-center shadow-sm mb-3 p-3 bg-white">
                    <img src="/images.png" alt="Google Logo" class="w-full h-full object-contain">
                  </div>
                  <h2 class="text-slate-800 font-bold text-xl mb-1">Acceso con Google</h2>
                  <p class="text-slate-500 text-sm">Ingresa tu correo institucional</p>
                </div>
                <div class="flex flex-col gap-1.5">
                  <label class="text-xs font-bold text-slate-600 tracking-wider">CORREO @UNSA.EDU.PE</label>
                  <div class="w-full flex items-center px-4 py-3 border border-slate-300 rounded-xl text-sm text-slate-700 focus-within:border-blue-500">
                    <input type="text" v-model="googleEmailLocal" @input="onGoogleEmailInput" @keyup.enter="handleGoogleContinue" placeholder="usuario" class="flex-grow min-w-0 outline-none border-none p-0 bg-transparent text-slate-700">
                    <span class="text-slate-400 whitespace-nowrap ml-2">@unsa.edu.pe</span>
                  </div>
                </div>
                <div v-if="googleError" class="flex items-start gap-2 bg-red-50 border border-red-200 text-red-600 rounded-xl px-4 py-3 text-sm">
                  <span>⚠️</span><span>{{ googleError }}</span>
                </div>
                <button @click="handleGoogleContinue" class="w-full py-3 bg-[#1e3a5f] hover:bg-[#152a45] text-white rounded-xl text-sm font-bold shadow-sm mt-4">
                  Continuar
                </button>
                <button @click="showMainView" class="w-full py-2 text-center text-slate-500 text-sm font-medium hover:text-slate-700">
                  ← Volver
                </button>
              </div>
            </template>

            <!-- Registro -->
            <template v-if="view === 'register'">
              <header class="bg-[#1e3a5f] text-white pt-6 pb-4 px-6 text-center rounded-b-[24px]">
                <h1 class="text-xl font-bold tracking-tight">CS Préstamos</h1>
              </header>
              <div class="p-6 flex flex-col gap-4">
                <div class="text-center mb-2">
                  <h2 class="text-slate-800 font-bold text-xl mb-1">Crear cuenta</h2>
                </div>
                <div class="flex flex-col gap-1">
                  <label class="text-xs font-bold text-slate-600 tracking-wider">NOMBRE COMPLETO</label>
                  <input type="text" placeholder="Ej. Juan Pérez" class="w-full px-4 py-2.5 border border-slate-300 rounded-xl text-sm focus:outline-none focus:border-blue-500">
                </div>
                <div class="flex flex-col gap-1">
                  <label class="text-xs font-bold text-slate-600 tracking-wider">CORREO INSTITUCIONAL</label>
                  <input type="text" placeholder="usuario@unsa.edu.pe" class="w-full px-4 py-2.5 border border-slate-300 rounded-xl text-sm focus:outline-none focus:border-blue-500">
                </div>
                <div class="flex flex-col gap-1">
                  <label class="text-xs font-bold text-slate-600 tracking-wider">CONTRASEÑA</label>
                  <div class="relative">
                    <input :type="passwordVisibleRegister ? 'text' : 'password'" v-model="registerPassword" class="w-full px-4 py-2.5 pr-12 border border-slate-300 rounded-xl text-sm focus:outline-none focus:border-blue-500">
                    <span @click="passwordVisibleRegister = !passwordVisibleRegister" class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 text-xs cursor-pointer hover:text-slate-600">
                      {{ passwordVisibleRegister ? 'Ocultar' : 'Ver' }}
                    </span>
                  </div>
                </div>

                <!-- Contenedor de Reglas de Negocio -->
                <div class="border border-slate-200 rounded-xl flex flex-col bg-slate-50 h-48 md:h-40">
                  <div class="bg-slate-100 px-4 py-2.5 border-b border-slate-200 flex-shrink-0">
                    <h3 class="font-bold text-slate-800 text-xs uppercase tracking-wider">Reglas de Negocio EPCC</h3>
                  </div>
                  <div ref="registerScroll" @scroll="checkRegisterScroll" class="p-4 overflow-y-auto text-xs text-slate-700 h-full space-y-4">
                    <p class="font-medium text-slate-600">Desplácese hasta el final para habilitar la casilla de aceptación de términos y condiciones de la EPCC.</p>
                    
                    <div class="space-y-2">
                      <h4 class="font-bold text-slate-800">1. Condiciones Generales</h4>
                      <ul class="list-disc pl-4 space-y-1 text-slate-600">
                        <li>El uso de los equipos es estrictamente académico y personal.</li>
                        <li>Todo artículo debe devolverse con todos sus accesorios completos (verificado en checklist por el operador).</li>
                        <li>Usuarios con cuentas suspendidas no podrán realizar nuevas reservas.</li>
                      </ul>
                    </div>

                    <div class="space-y-2">
                      <h4 class="font-bold text-slate-800">2. Categorías y Tiempos Máximos</h4>
                      <ul class="list-disc pl-4 space-y-1 text-slate-600">
                        <li><strong>Electrónicos (Laptops, Tablets, etc.):</strong> De 3 a 7 días hábiles según el equipo.</li>
                        <li><strong>Libros:</strong> Máximo 14 días calendarios.</li>
                        <li><strong>Deportes:</strong> Máximo 2 días calendarios.</li>
                      </ul>
                    </div>

                    <div class="space-y-2">
                      <h4 class="font-bold text-slate-800">3. Sistema de Sanciones (RN-11)</h4>
                      <p class="text-slate-600">La devolución fuera del plazo establecido aplica sanciones automáticas e irrevocables al momento de la entrega:</p>
                      <ul class="list-disc pl-4 space-y-1 text-slate-600">
                        <li><strong>Sanción Leve (Equipos Deportivos):</strong> 7 días de suspensión.</li>
                        <li><strong>Sanción Moderada (Libros):</strong> 15 días de suspensión.</li>
                        <li><strong>Sanción Grave (Electrónicos):</strong> 30 días de suspensión.</li>
                      </ul>
                    </div>

                    <div class="space-y-2">
                      <h4 class="font-bold text-slate-800">4. Pérdidas y Daños</h4>
                      <p class="text-slate-600 pb-4">En caso de pérdida o daño irreparable, el estudiante deberá reponer el equipo por uno de iguales o mejores características en un plazo no mayor a 30 días, manteniéndose suspendido hasta la reposición.</p>
                    </div>
                  </div>
                </div>

                <div class="flex items-center gap-2 mt-1">
                  <input type="checkbox" v-model="registerChecked" :disabled="!canCheckRegister" class="w-5 h-5 text-blue-600 rounded border-slate-300 disabled:opacity-50 cursor-pointer">
                  <label class="text-xs text-slate-600 select-none">He leído y acepto todas las reglas de negocio.</label>
                </div>
                <button :disabled="!(canCheckRegister && registerChecked)" class="w-full py-3 text-white rounded-xl text-sm font-bold transition-colors bg-[#1e3a5f] hover:bg-[#152a45] disabled:bg-slate-400 mt-2">
                  Registrarse
                </button>
                <div class="text-center">
                  <a href="#" @click.prevent="showMainView" class="text-blue-600 text-sm font-medium hover:underline">¿Ya tienes cuenta? Inicia sesión</a>
                </div>
              </div>
            </template>
          </div>
        </div>

        <!-- ================= VISTA: INICIO ESTUDIANTE ================= -->
        <div v-show="view === 'student-home'" class="p-4 md:p-8 space-y-6 md:space-y-8 max-w-7xl mx-auto">
          <!-- Móvil Header -->
          <div class="md:hidden bg-white -mx-4 -mt-4 p-5 border-b border-slate-200 mb-6">
            <p class="text-xs text-slate-500">Bienvenido/a,</p>
            <h2 class="text-xl font-extrabold text-slate-900">{{ currentUser?.name }}</h2>
          </div>

          <div v-if="toast" class="bg-emerald-50 border border-emerald-200 text-emerald-800 rounded-xl px-4 py-3 text-sm font-medium shadow-sm">
            {{ toast }}
          </div>

          <!-- Suspensión Alert -->
          <div v-if="isSuspended" class="bg-red-50 border border-red-200 rounded-2xl p-5 md:p-6 shadow-sm flex flex-col md:flex-row gap-4 md:items-center justify-between">
            <div class="flex gap-3 items-start">
              <span class="text-2xl">⚠️</span>
              <div>
                <h3 class="text-base md:text-lg font-bold text-red-800">
                  {{ activeSanction ? `Sanción activa (${activeSanction.level.toLowerCase()})` : 'Cuenta suspendida' }}
                </h3>
                <p class="text-sm text-red-700 mt-1">
                  {{ activeSanction ? `Motivo: ${activeSanction.reason}. Vigente hasta ${activeSanction.until}.` : 'Comunícate con la Escuela para más información.' }}
                </p>
              </div>
            </div>
            <div class="shrink-0" v-if="activeSanction">
              <button v-if="!myAppeal" @click="openAppealModal" class="w-full md:w-auto px-6 py-3 rounded-xl bg-red-600 hover:bg-red-700 text-white text-sm font-bold shadow-sm">
                Apelar sanción
              </button>
              <p v-else-if="myAppeal.status === 'PENDIENTE'" class="text-xs text-amber-800 bg-amber-100 px-4 py-2 rounded-xl font-medium">
                ⏳ Apelación en revisión
              </p>
              <p v-else class="text-xs text-red-800 bg-red-100 px-4 py-2 rounded-xl font-medium">
                Apelación rechazada
              </p>
            </div>
          </div>

          <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 md:gap-8">
            <!-- Izquierda: Préstamos y Explorar -->
            <div class="lg:col-span-2 space-y-6 md:space-y-8">
              
              <!-- Explorar Catálogo -->
              <section>
                <div class="flex justify-between items-center mb-4">
                  <h3 class="text-sm md:text-base font-bold text-slate-800 uppercase tracking-wider">Explorar catálogo</h3>
                  <button @click="scrollToCategory('all')" class="text-sm text-blue-600 font-bold hover:underline">Ver todo ›</button>
                </div>
                <div class="grid grid-cols-3 gap-3 md:gap-6">
                  <div @click="scrollToCategory('electricos')" class="bg-white p-4 md:p-6 rounded-2xl border border-slate-200 shadow-sm hover:border-blue-400 hover:shadow-md cursor-pointer transition flex flex-col items-center md:items-start text-center md:text-left">
                    <div class="text-blue-600 text-2xl md:text-3xl mb-2 md:mb-3">💻</div>
                    <h4 class="text-xs md:text-sm font-bold text-slate-800">Electrónicos</h4>
                    <p class="text-[10px] md:text-xs text-emerald-600 font-medium mt-1">{{ availableByCategory.electricos }} disp.</p>
                  </div>
                  <div @click="scrollToCategory('libros')" class="bg-white p-4 md:p-6 rounded-2xl border border-slate-200 shadow-sm hover:border-purple-400 hover:shadow-md cursor-pointer transition flex flex-col items-center md:items-start text-center md:text-left">
                    <div class="text-purple-600 text-2xl md:text-3xl mb-2 md:mb-3">📖</div>
                    <h4 class="text-xs md:text-sm font-bold text-slate-800">Libros</h4>
                    <p class="text-[10px] md:text-xs text-emerald-600 font-medium mt-1">{{ availableByCategory.libros }} disp.</p>
                  </div>
                  <div @click="scrollToCategory('deportes')" class="bg-white p-4 md:p-6 rounded-2xl border border-slate-200 shadow-sm hover:border-emerald-400 hover:shadow-md cursor-pointer transition flex flex-col items-center md:items-start text-center md:text-left">
                    <div class="text-emerald-600 text-2xl md:text-3xl mb-2 md:mb-3">⚽</div>
                    <h4 class="text-xs md:text-sm font-bold text-slate-800">Deportes</h4>
                    <p class="text-[10px] md:text-xs text-emerald-600 font-medium mt-1">{{ availableByCategory.deportes }} disp.</p>
                  </div>
                </div>
              </section>

              <!-- Mis Préstamos -->
              <section>
                <div class="flex justify-between items-center mb-4">
                  <h3 class="text-sm md:text-base font-bold text-slate-800 uppercase tracking-wider">Mis Préstamos Activos</h3>
                  <span class="text-xs font-medium bg-slate-200 text-slate-700 px-3 py-1 rounded-full">{{ myActiveLoans.length }}</span>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div v-for="(loan, idx) in myActiveLoans" :key="idx" class="bg-white p-4 md:p-5 rounded-2xl border border-slate-200 shadow-sm">
                    <div class="flex justify-between items-start mb-3">
                      <div>
                        <h4 class="text-sm md:text-base font-bold text-slate-900">{{ loan.item }}</h4>
                        <p class="text-xs text-slate-500">{{ loan.code }} · {{ loan.category }}</p>
                      </div>
                      <span class="px-2.5 py-1 rounded-full text-[10px] font-bold tracking-wide uppercase border" :class="isOverdue(loan) ? 'bg-red-50 text-red-700 border-red-200' : 'bg-blue-50 text-blue-700 border-blue-200'">
                        {{ isOverdue(loan) ? 'Mora' : 'Activo' }}
                      </span>
                    </div>
                    <div class="flex justify-between items-center pt-3 border-t border-slate-100">
                      <div class="flex items-center gap-2">
                        <span class="text-sm">🕒</span>
                        <div class="flex flex-col">
                          <span class="text-xs font-semibold" :class="isOverdue(loan) ? 'text-red-600' : 'text-slate-700'">{{ loan.date }}</span>
                          <span class="text-[10px] font-medium" :class="isOverdue(loan) ? 'text-red-500' : 'text-slate-400'">{{ loan.daysLeft }} días rest.</span>
                        </div>
                      </div>
                      <button class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-xs font-bold transition">
                        Renovar
                      </button>
                    </div>
                  </div>
                  <div v-if="myActiveLoans.length === 0" class="md:col-span-2 bg-white p-8 rounded-2xl border border-slate-200 shadow-sm text-center">
                    <p class="text-sm text-slate-400">No tienes préstamos activos.</p>
                  </div>
                </div>
              </section>

            </div>

            <!-- Derecha: Sanciones (Sidebar en PC) -->
            <div class="lg:col-span-1">
              <section class="bg-slate-100 p-4 md:p-6 rounded-3xl h-full">
                <h3 class="text-sm md:text-base font-bold text-slate-800 uppercase tracking-wider mb-4">Historial Sanciones</h3>
                <div class="space-y-3">
                  <div v-for="sanction in currentUser?.sanctions" :key="sanction.id" class="bg-white p-4 rounded-2xl border-l-4 border-red-500 shadow-sm">
                    <div class="flex justify-between items-start mb-2">
                      <span class="px-2 py-0.5 rounded text-[9px] font-bold bg-red-100 text-red-700">ACTIVA</span>
                      <span class="text-xs font-bold text-slate-700">{{ sanction.level }}</span>
                    </div>
                    <h4 class="text-sm font-bold text-slate-900 leading-tight">{{ sanction.rule }}</h4>
                    <p class="text-xs text-slate-500 mt-1">{{ sanction.reason }}</p>
                    <p class="text-[10px] text-slate-400 mt-2">Hasta: {{ sanction.until }}</p>
                  </div>
                  <div v-if="!currentUser || currentUser.sanctions.length === 0" class="text-center py-6">
                    <span class="text-3xl block mb-2">✨</span>
                    <p class="text-sm text-slate-500">Historial limpio.</p>
                  </div>
                </div>
              </section>
            </div>
          </div>
        </div>

        <!-- ================= VISTA: CATÁLOGO ================= -->
        <div v-show="view === 'catalog'" class="p-4 md:p-8 flex flex-col h-full max-w-7xl mx-auto">
          <!-- Cabecera Catálogo -->
          <div class="mb-6 flex flex-col md:flex-row md:items-end justify-between gap-4 shrink-0">
            <div>
              <h2 class="text-xl md:text-2xl font-extrabold text-slate-900">Catálogo de Artículos</h2>
              <p class="text-sm text-slate-500">{{ filteredItems.length }} resultados</p>
            </div>
            <div class="flex flex-col sm:flex-row gap-3 md:w-1/2 lg:w-1/3">
              <div class="relative flex-grow">
                <span class="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">🔍</span>
                <input type="text" v-model="searchQuery" placeholder="Buscar..." class="w-full pl-9 pr-4 py-2.5 border border-slate-200 rounded-xl text-sm bg-white focus:outline-none focus:border-blue-500 shadow-sm">
              </div>
              <label class="flex items-center gap-2 text-sm font-medium text-slate-600 bg-white px-4 py-2.5 rounded-xl border border-slate-200 shadow-sm cursor-pointer whitespace-nowrap">
                <input type="checkbox" v-model="onlyAvailable" class="w-4 h-4 rounded border-slate-300 text-blue-600 focus:ring-blue-500"> Disp.
              </label>
            </div>
          </div>

          <!-- Listado scrolleable -->
          <div ref="catalogContainer" class="flex-grow overflow-y-auto space-y-8 pb-10">
            
            <section id="section-electricos" v-if="electricosItems.length > 0">
              <div class="flex items-center gap-3 mb-4">
                <span class="text-2xl">💻</span>
                <h3 class="text-lg font-bold text-slate-800">Electrónicos</h3>
                <div class="h-px bg-slate-200 flex-grow ml-4"></div>
              </div>
              <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 md:gap-6">
                <div v-for="item in electricosItems" :key="item.code" @click="openItemDetail(item)" class="bg-white p-4 md:p-5 rounded-2xl border border-slate-200 shadow-sm hover:shadow-lg hover:border-blue-300 transition cursor-pointer flex flex-col h-full">
                  <div class="flex justify-between items-start mb-3">
                    <span class="text-xs font-extrabold px-2.5 py-1 rounded-full bg-slate-100" :class="item.availableCount > 0 ? 'text-emerald-700' : 'text-red-600'">
                      {{ item.stockText }}
                    </span>
                    <span class="text-[10px] font-bold text-slate-400 bg-slate-50 px-2 py-1 rounded">{{ item.code }}</span>
                  </div>
                  <h4 class="text-base font-bold text-slate-900 mb-2 leading-tight">{{ item.name }}</h4>
                  <p class="text-xs text-slate-500 line-clamp-3 mb-4 flex-grow">{{ item.description }}</p>
                  <div class="flex justify-between items-center pt-3 border-t border-slate-100 text-xs font-semibold">
                    <span class="text-slate-500">🕒 {{ item.maxTime }}</span>
                    <span class="text-blue-600">Ver más →</span>
                  </div>
                </div>
              </div>
            </section>

            <section id="section-libros" v-if="librosItems.length > 0">
              <div class="flex items-center gap-3 mb-4">
                <span class="text-2xl">📖</span>
                <h3 class="text-lg font-bold text-slate-800">Libros</h3>
                <div class="h-px bg-slate-200 flex-grow ml-4"></div>
              </div>
              <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 md:gap-6">
                <div v-for="item in librosItems" :key="item.code" @click="openItemDetail(item)" class="bg-white p-4 md:p-5 rounded-2xl border border-slate-200 shadow-sm hover:shadow-lg hover:border-purple-300 transition cursor-pointer flex flex-col h-full">
                  <div class="flex justify-between items-start mb-3">
                    <span class="text-xs font-extrabold px-2.5 py-1 rounded-full bg-slate-100" :class="item.availableCount > 0 ? 'text-emerald-700' : 'text-red-600'">
                      {{ item.stockText }}
                    </span>
                    <span class="text-[10px] font-bold text-slate-400 bg-slate-50 px-2 py-1 rounded">{{ item.code }}</span>
                  </div>
                  <h4 class="text-base font-bold text-slate-900 mb-2 leading-tight">{{ item.name }}</h4>
                  <p class="text-xs text-slate-500 line-clamp-3 mb-4 flex-grow">{{ item.description }}</p>
                  <div class="flex justify-between items-center pt-3 border-t border-slate-100 text-xs font-semibold">
                    <span class="text-slate-500">🕒 {{ item.maxTime }}</span>
                    <span class="text-purple-600">Ver más →</span>
                  </div>
                </div>
              </div>
            </section>

            <section id="section-deportes" v-if="deportesItems.length > 0">
              <div class="flex items-center gap-3 mb-4">
                <span class="text-2xl">⚽</span>
                <h3 class="text-lg font-bold text-slate-800">Deportes</h3>
                <div class="h-px bg-slate-200 flex-grow ml-4"></div>
              </div>
              <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 md:gap-6">
                <div v-for="item in deportesItems" :key="item.code" @click="openItemDetail(item)" class="bg-white p-4 md:p-5 rounded-2xl border border-slate-200 shadow-sm hover:shadow-lg hover:border-emerald-300 transition cursor-pointer flex flex-col h-full">
                  <div class="flex justify-between items-start mb-3">
                    <span class="text-xs font-extrabold px-2.5 py-1 rounded-full bg-slate-100" :class="item.availableCount > 0 ? 'text-emerald-700' : 'text-red-600'">
                      {{ item.stockText }}
                    </span>
                    <span class="text-[10px] font-bold text-slate-400 bg-slate-50 px-2 py-1 rounded">{{ item.code }}</span>
                  </div>
                  <h4 class="text-base font-bold text-slate-900 mb-2 leading-tight">{{ item.name }}</h4>
                  <p class="text-xs text-slate-500 line-clamp-3 mb-4 flex-grow">{{ item.description }}</p>
                  <div class="flex justify-between items-center pt-3 border-t border-slate-100 text-xs font-semibold">
                    <span class="text-slate-500">🕒 {{ item.maxTime }}</span>
                    <span class="text-emerald-600">Ver más →</span>
                  </div>
                </div>
              </div>
            </section>

            <div v-if="filteredItems.length === 0" class="text-center py-20">
              <span class="text-4xl block mb-4">🔍</span>
              <h3 class="text-lg font-bold text-slate-700">Sin resultados</h3>
              <p class="text-sm text-slate-500">No se encontraron artículos con los filtros aplicados.</p>
            </div>
          </div>
        </div>

        <!-- ================= VISTA: DETALLE ARTÍCULO ================= -->
        <div v-show="view === 'item-detail'" class="p-4 md:p-8 max-w-5xl mx-auto h-full overflow-y-auto">
          <button @click="view = 'catalog'" class="text-sm text-slate-500 hover:text-blue-600 font-bold flex items-center gap-2 mb-6 transition">
            <span>←</span> Volver al catálogo
          </button>
          
          <div class="grid grid-cols-1 md:grid-cols-5 gap-6 md:gap-8" v-if="selectedItem">
            <!-- Columna Principal -->
            <div class="md:col-span-3 space-y-6">
              <div>
                <span class="px-3 py-1 bg-slate-200 text-slate-700 text-xs font-bold rounded-full uppercase tracking-wide">{{ selectedItem.categoryName }}</span>
                <h2 class="text-2xl md:text-3xl font-extrabold text-slate-900 mt-3">{{ selectedItem.name }}</h2>
                <p class="text-sm text-slate-500 mt-1 font-medium">Código: {{ selectedItem.code }}</p>
              </div>

              <div class="bg-white p-5 md:p-6 rounded-3xl border border-slate-200 shadow-sm">
                <h3 class="text-sm font-bold text-slate-900 mb-3 uppercase tracking-wider">Descripción</h3>
                <p class="text-sm text-slate-600 leading-relaxed">{{ selectedItem.description }}</p>
              </div>

              <div class="bg-white p-5 md:p-6 rounded-3xl border border-slate-200 shadow-sm">
                <h3 class="text-sm font-bold text-slate-900 mb-4 uppercase tracking-wider">Partes y Accesorios</h3>
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <div v-for="(part, idx) in selectedItem.parts" :key="idx" class="px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-700 flex items-center gap-3">
                    <span class="w-2 h-2 rounded-full bg-blue-500"></span>
                    {{ part }}
                  </div>
                </div>
              </div>
            </div>

            <!-- Columna Secundaria (Acción / Info extra) -->
            <div class="md:col-span-2 space-y-6">
              <div class="bg-white p-6 rounded-3xl border border-slate-200 shadow-sm">
                <h3 class="text-sm font-bold text-slate-900 mb-4 uppercase tracking-wider">Disponibilidad</h3>
                <div class="flex items-end gap-3 mb-4">
                  <span class="text-4xl md:text-5xl font-extrabold leading-none" :class="selectedItem.availableCount > 0 ? 'text-emerald-600' : 'text-red-500'">
                    {{ selectedItem.availableCount }}
                  </span>
                  <div class="pb-1">
                    <span class="text-sm font-bold text-slate-700 block">{{ selectedItem.availableCount > 0 ? 'disponibles' : 'agotado' }}</span>
                    <span class="text-xs text-slate-500">de {{ selectedItem.totalCount }} en total</span>
                  </div>
                </div>
                <div class="w-full bg-slate-100 h-2 rounded-full overflow-hidden mb-6">
                  <div class="h-full rounded-full transition-all" :class="selectedItem.availableCount > 0 ? 'bg-emerald-500' : 'bg-red-500'" :style="{ width: (selectedItem.availableCount / selectedItem.totalCount) * 100 + '%' }"></div>
                </div>

                <button v-if="!isOperator && !isAdmin" :disabled="!canReserve" class="w-full py-3.5 rounded-xl text-sm font-bold transition shadow-sm" :class="canReserve ? 'bg-[#1e3a5f] hover:bg-[#152a45] text-white' : 'bg-slate-100 text-slate-400 cursor-not-allowed'">
                  {{ isSuspended ? 'Cuenta suspendida' : (canReserve ? 'Reservar equipo' : 'Sin disponibilidad') }}
                </button>
              </div>

              <div class="bg-white p-6 rounded-3xl border border-slate-200 shadow-sm">
                <h3 class="text-sm font-bold text-slate-900 mb-4 uppercase tracking-wider flex items-center gap-2">
                  <span>🕒</span> Historial Reciente
                </h3>
                <div class="space-y-4" v-if="selectedItem.history.length > 0">
                  <div v-for="(hist, idx) in selectedItem.history" :key="idx" class="flex justify-between items-center border-b border-slate-100 pb-3 last:border-0 last:pb-0">
                    <div>
                      <h4 class="text-sm font-bold text-slate-800">{{ hist.user }}</h4>
                      <p class="text-xs text-slate-500">{{ hist.date }}</p>
                    </div>
                    <span class="px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider" :class="hist.status === 'LOANED' ? 'bg-blue-50 text-blue-600' : 'bg-slate-100 text-slate-600'">
                      {{ hist.status }}
                    </span>
                  </div>
                </div>
                <div v-else class="text-center py-4">
                  <p class="text-sm text-slate-400 italic">No hay registros.</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- ================= VISTA: OPERADOR ================= -->
        <div v-show="view === 'operator-home'" class="p-4 md:p-8 flex flex-col h-full max-w-7xl mx-auto">
          <div class="mb-6 shrink-0">
            <h2 class="text-xl md:text-2xl font-extrabold text-slate-900">Panel Operador</h2>
            <p class="text-sm text-slate-500">Gestión de devoluciones y mora</p>
          </div>

          <div class="flex gap-2 mb-6 border-b border-slate-200 pb-px shrink-0 overflow-x-auto">
            <button @click="operatorTab = 'active'" class="px-5 py-3 text-sm font-bold border-b-2 transition whitespace-nowrap" :class="operatorTab === 'active' ? 'border-[#1e3a5f] text-[#1e3a5f]' : 'border-transparent text-slate-500 hover:text-slate-800'">
              Préstamos Activos ({{ operatorLoans.length }})
            </button>
            <button @click="operatorTab = 'overdue'" class="px-5 py-3 text-sm font-bold border-b-2 transition whitespace-nowrap" :class="operatorTab === 'overdue' ? 'border-red-600 text-red-600' : 'border-transparent text-slate-500 hover:text-red-600'">
              Equipos en Mora ({{ overdueLoans.length }})
            </button>
          </div>

          <div class="flex-grow overflow-y-auto">
            <div v-if="toast" class="mb-4 bg-emerald-50 border border-emerald-200 text-emerald-800 rounded-xl px-4 py-3 text-sm font-medium shadow-sm">
              {{ toast }}
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 md:gap-6">
              <div v-for="loan in visibleOperatorLoans" :key="loan.id" class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex flex-col justify-between" :class="{'border-red-300 bg-red-50/30': loan.overdue}">
                <div class="mb-4">
                  <div class="flex justify-between items-start mb-2">
                    <h4 class="text-base font-bold text-slate-900">{{ loan.borrower }}</h4>
                    <span v-if="loan.overdue" class="bg-red-600 text-white text-[10px] font-bold px-2 py-0.5 rounded-md uppercase">Mora</span>
                  </div>
                  <p class="text-sm text-slate-700 font-medium">{{ loan.itemName }}</p>
                  <p class="text-xs text-slate-500">{{ loan.itemCode }}</p>
                  <p class="text-xs mt-2" :class="loan.overdue ? 'text-red-600 font-bold' : 'text-slate-500'">Límite: {{ loan.dueDate }}</p>
                </div>
                <button @click="openChecklist(loan)" class="w-full py-2.5 rounded-xl text-sm font-bold transition shadow-sm" :class="loan.overdue ? 'bg-red-100 hover:bg-red-200 text-red-700' : 'bg-emerald-50 hover:bg-emerald-100 text-emerald-700'">
                  ✓ Recibir Equipo
                </button>
              </div>
            </div>

            <div v-if="visibleOperatorLoans.length === 0" class="text-center py-20">
              <span class="text-4xl block mb-4">👍</span>
              <p class="text-sm text-slate-500 font-medium">{{ operatorTab === 'overdue' ? 'No hay equipos en mora.' : 'No hay préstamos activos.' }}</p>
            </div>
          </div>
        </div>

        <!-- ================= VISTA: ADMIN APELACIONES ================= -->
        <div v-show="view === 'admin-appeals'" class="p-4 md:p-8 flex flex-col h-full max-w-7xl mx-auto">
          <div class="mb-6 shrink-0">
            <h2 class="text-xl md:text-2xl font-extrabold text-slate-900">Apelaciones Recibidas</h2>
            <p class="text-sm text-slate-500">{{ pendingAppealsCount }} pendiente(s) de revisión</p>
          </div>

          <div class="flex-grow overflow-y-auto space-y-4">
            <div v-if="toast" class="mb-2 bg-emerald-50 border border-emerald-200 text-emerald-800 rounded-xl px-4 py-3 text-sm font-medium shadow-sm">
              {{ toast }}
            </div>

            <div v-for="appeal in sortedAppeals" :key="appeal.id" class="bg-white p-5 md:p-6 rounded-2xl border border-slate-200 shadow-sm" :class="{'opacity-70': appeal.status !== 'PENDIENTE'}">
              <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-4">
                <div>
                  <h4 class="text-base font-bold text-slate-900">{{ appeal.studentName }}</h4>
                  <p class="text-xs text-slate-500">{{ appeal.email }}</p>
                </div>
                <span class="px-3 py-1 rounded-md text-xs font-bold" :class="appeal.status === 'PENDIENTE' ? 'bg-amber-100 text-amber-800' : appeal.status === 'APROBADA' ? 'bg-emerald-100 text-emerald-800' : 'bg-red-100 text-red-800'">
                  {{ appeal.status }}
                </span>
              </div>

              <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm text-slate-600 mb-4">
                <p><strong class="text-slate-800">Equipo:</strong> {{ appeal.itemName }} ({{ appeal.itemCode }})</p>
                <p><strong class="text-slate-800">Sanción:</strong> {{ appeal.sanctionLevel }} ({{ appeal.sanctionDays }} días)</p>
                <p><strong class="text-slate-800">Motivo de sanción:</strong> {{ users.find(u=>u.id===appeal.userId)?.sanctions.find(s=>s.id===appeal.sanctionId)?.reason || 'Devolución tardía' }}</p>
                <p><strong class="text-slate-800">Fecha Apelación:</strong> {{ appeal.date }}</p>
              </div>

              <div class="bg-slate-50 border border-slate-200 rounded-xl p-4 mb-4">
                <p class="text-xs font-bold text-slate-500 tracking-wider mb-2">ARGUMENTO DEL ESTUDIANTE</p>
                <p class="text-sm text-slate-700 leading-relaxed italic">"{{ appeal.reason }}"</p>
              </div>

              <div v-if="appeal.status === 'PENDIENTE'" class="flex gap-3 justify-end border-t border-slate-100 pt-4">
                <button @click="resolveAppeal(appeal, false)" class="px-6 py-2.5 rounded-xl text-sm font-bold bg-white hover:bg-red-50 text-red-600 border border-red-200 transition">
                  Rechazar
                </button>
                <button @click="resolveAppeal(appeal, true)" class="px-6 py-2.5 rounded-xl text-sm font-bold bg-[#1e3a5f] hover:bg-[#152a45] text-white transition">
                  Aprobar Apelación
                </button>
              </div>
            </div>

            <p v-if="appeals.length === 0" class="text-sm text-slate-500 text-center py-10">No hay apelaciones registradas.</p>
          </div>
        </div>

        <!-- ================= VISTA: ADMIN USUARIOS ================= -->
        <div v-show="view === 'admin-users'" class="p-4 md:p-8 flex flex-col h-full max-w-7xl mx-auto">
          <div class="mb-6 shrink-0 flex flex-col md:flex-row md:items-end justify-between gap-4">
            <div>
              <h2 class="text-xl md:text-2xl font-extrabold text-slate-900">Gestión de Usuarios</h2>
              <p class="text-sm text-slate-500">Suspensiones, roles e historiales</p>
            </div>
            <div class="relative md:w-80">
              <span class="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">🔍</span>
              <input type="text" v-model="userSearch" placeholder="Buscar usuario..." class="w-full pl-9 pr-8 py-2.5 border border-slate-200 rounded-xl text-sm bg-white focus:outline-none focus:border-blue-500 shadow-sm">
            </div>
          </div>

          <div class="flex-grow overflow-y-auto space-y-4">
            <div v-if="toast" class="mb-2 bg-emerald-50 border border-emerald-200 text-emerald-800 rounded-xl px-4 py-3 text-sm font-medium shadow-sm">
              {{ toast }}
            </div>

            <div v-for="user in filteredUsers" :key="user.id" class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
              <div class="flex-grow min-w-0">
                <div class="flex items-center gap-3 mb-1">
                  <h4 class="text-base font-bold text-slate-900 truncate">{{ user.name }}</h4>
                  <span class="px-2 py-0.5 rounded text-[10px] font-bold border" :class="user.suspended ? 'bg-red-50 text-red-700 border-red-200' : 'bg-emerald-50 text-emerald-700 border-emerald-200'">
                    {{ user.suspended ? 'SUSPENDIDO' : 'ACTIVO' }}
                  </span>
                </div>
                <p class="text-xs text-slate-500">{{ user.email }} | {{ user.phone }}</p>
                <button @click="openUserHistory(user)" class="text-xs text-blue-600 font-bold hover:underline mt-2">
                  Ver historial completo →
                </button>
              </div>

              <div class="flex items-center gap-3 shrink-0 pt-3 md:pt-0 border-t border-slate-100 md:border-0">
                <span v-if="user.role === 'Admin'" class="px-4 py-2 border border-slate-200 bg-slate-50 rounded-xl text-sm font-bold text-slate-500">
                  Admin
                </span>
                <select v-else v-model="user.role" @change="onRoleChange(user)" class="px-4 py-2 border border-slate-300 rounded-xl text-sm font-bold text-slate-800 bg-white focus:outline-none cursor-pointer">
                  <option value="Estudiante">Estudiante</option>
                  <option value="Operador">Operador</option>
                </select>

                <button v-if="user.role !== 'Admin'" @click="toggleSuspension(user)" class="px-4 py-2 rounded-xl text-sm font-bold transition border" :class="user.suspended ? 'bg-emerald-50 hover:bg-emerald-100 text-emerald-700 border-emerald-200' : 'bg-red-50 hover:bg-red-100 text-red-600 border-red-200'">
                  {{ user.suspended ? 'Levantar' : 'Suspender' }}
                </button>
              </div>
            </div>

            <p v-if="filteredUsers.length === 0" class="text-sm text-slate-500 text-center py-10">No se encontraron usuarios.</p>
          </div>
        </div>

        <!-- ================= VISTA: ADMIN CATÁLOGO ================= -->
        <div v-show="view === 'admin-catalog'" class="p-4 md:p-8 flex flex-col h-full max-w-7xl mx-auto">
          <div class="mb-6 shrink-0 flex flex-col md:flex-row md:items-end justify-between gap-4">
            <div>
              <h2 class="text-xl md:text-2xl font-extrabold text-slate-900">Gestión de Catálogo</h2>
              <p class="text-sm text-slate-500">Añade o modifica los artículos del inventario</p>
            </div>
            <div class="flex items-center gap-3">
              <div class="relative w-full md:w-64">
                <span class="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">🔍</span>
                <input type="text" v-model="searchQuery" placeholder="Buscar artículo..." class="w-full pl-9 pr-4 py-2.5 border border-slate-200 rounded-xl text-sm bg-white focus:outline-none focus:border-blue-500 shadow-sm">
              </div>
              <button @click="openAddProduct" class="px-5 py-2.5 bg-[#1e3a5f] hover:bg-[#152a45] text-white rounded-xl text-sm font-bold shadow-sm transition flex items-center gap-2 shrink-0">
                <span>➕</span> <span class="hidden md:inline">Nuevo Artículo</span>
              </button>
            </div>
          </div>

          <div class="flex-grow overflow-y-auto">
            <div v-if="toast" class="mb-4 bg-emerald-50 border border-emerald-200 text-emerald-800 rounded-xl px-4 py-3 text-sm font-medium shadow-sm">
              {{ toast }}
            </div>

            <!-- Lista de Artículos (Estilo Panel de Gestión) -->
            <div class="bg-white border border-slate-200 rounded-2xl shadow-sm overflow-hidden">
              <div class="hidden md:grid grid-cols-12 gap-4 p-4 bg-slate-50 border-b border-slate-200 text-xs font-bold text-slate-500 uppercase tracking-wider">
                <div class="col-span-5">Artículo</div>
                <div class="col-span-2">Categoría</div>
                <div class="col-span-3 text-center">Disponibilidad</div>
                <div class="col-span-2 text-right">Acciones</div>
              </div>

              <div v-for="item in filteredItems" :key="item.code" class="flex flex-col md:grid md:grid-cols-12 gap-4 p-4 border-b border-slate-100 items-center hover:bg-slate-50 transition">
                <div class="w-full md:col-span-5 flex flex-col">
                  <h4 class="text-sm font-bold text-slate-900">{{ item.name }}</h4>
                  <p class="text-xs text-slate-500 mt-0.5">{{ item.code }}</p>
                </div>
                <div class="w-full md:col-span-2 flex md:block justify-between items-center mt-2 md:mt-0">
                  <span class="md:hidden text-xs font-bold text-slate-500">Categoría:</span>
                  <span class="px-2.5 py-1 bg-slate-100 text-slate-700 text-[10px] font-bold rounded-md uppercase">{{ item.categoryName }}</span>
                </div>
                <div class="w-full md:col-span-3 flex md:justify-center justify-between items-center mt-2 md:mt-0">
                  <span class="md:hidden text-xs font-bold text-slate-500">Stock:</span>
                  <span class="text-xs font-bold" :class="item.availableCount > 0 ? 'text-emerald-600' : 'text-red-500'">
                    {{ item.availableCount }} / {{ item.totalCount }}
                  </span>
                </div>
                <div class="w-full md:col-span-2 flex justify-end mt-3 md:mt-0">
                  <button @click="openEditProduct(item)" class="px-4 py-2 bg-blue-50 hover:bg-blue-100 text-blue-700 rounded-lg text-xs font-bold transition flex items-center gap-1.5 w-full md:w-auto justify-center">
                    <span>✏️</span> Editar
                  </button>
                </div>
              </div>

              <div v-if="filteredItems.length === 0" class="p-8 text-center text-sm text-slate-500">
                No se encontraron artículos en el catálogo.
              </div>
            </div>
          </div>
        </div>

      </main>

      <!-- ================= BOTTOM NAV (SOLO MÓVIL) ================= -->
      <nav v-if="isLoggedIn" class="md:hidden bg-white border-t border-slate-200 py-2 px-6 flex justify-around items-center shrink-0">
        <template v-if="role === 'student'">
          <button @click="view = 'student-home'" class="flex flex-col items-center cursor-pointer" :class="view === 'student-home' ? 'text-blue-600' : 'text-slate-400 hover:text-slate-600'">
            <span class="text-xl">🏠</span><span class="text-[10px] font-semibold mt-0.5">Inicio</span>
          </button>
          <button @click="scrollToCategory('all')" class="flex flex-col items-center cursor-pointer" :class="view === 'catalog' || view === 'item-detail' ? 'text-blue-600' : 'text-slate-400 hover:text-slate-600'">
            <span class="text-xl">🗂️</span><span class="text-[10px] font-semibold mt-0.5">Catálogo</span>
          </button>
        </template>

        <template v-else-if="role === 'operator'">
          <button @click="view = 'operator-home'" class="flex flex-col items-center cursor-pointer" :class="view === 'operator-home' ? 'text-blue-600' : 'text-slate-400 hover:text-slate-600'">
            <span class="text-xl">📦</span><span class="text-[10px] font-semibold mt-0.5">Operador</span>
          </button>
          <button @click="scrollToCategory('all')" class="flex flex-col items-center cursor-pointer" :class="view === 'catalog' || view === 'item-detail' ? 'text-blue-600' : 'text-slate-400 hover:text-slate-600'">
            <span class="text-xl">🗂️</span><span class="text-[10px] font-semibold mt-0.5">Catálogo</span>
          </button>
        </template>

        <template v-else-if="role === 'admin'">
          <button @click="view = 'admin-appeals'" class="flex flex-col items-center cursor-pointer relative" :class="view === 'admin-appeals' ? 'text-blue-600' : 'text-slate-400 hover:text-slate-600'">
            <span class="text-xl">⚖️</span><span class="text-[10px] font-semibold mt-0.5">Apelaciones</span>
            <span v-if="pendingAppealsCount > 0" class="absolute -top-1 -right-2 bg-red-500 text-white text-[9px] font-bold px-1.5 py-0.5 rounded-full">{{ pendingAppealsCount }}</span>
          </button>
          <button @click="view = 'admin-users'" class="flex flex-col items-center cursor-pointer" :class="view === 'admin-users' ? 'text-blue-600' : 'text-slate-400 hover:text-slate-600'">
            <span class="text-xl">👥</span><span class="text-[10px] font-semibold mt-0.5">Usuarios</span>
          </button>
          <button @click="view = 'admin-catalog'" class="flex flex-col items-center cursor-pointer" :class="view === 'admin-catalog' ? 'text-blue-600' : 'text-slate-400 hover:text-slate-600'">
            <span class="text-xl">🗂️</span><span class="text-[10px] font-semibold mt-0.5">Catálogo</span>
          </button>
          <button @click="view = 'operator-home'" class="flex flex-col items-center cursor-pointer" :class="view === 'operator-home' ? 'text-blue-600' : 'text-slate-400 hover:text-slate-600'">
            <span class="text-xl">📦</span><span class="text-[10px] font-semibold mt-0.5">Operador</span>
          </button>
        </template>

        <button @click="showMainView" class="flex flex-col items-center text-red-400 hover:text-red-600 cursor-pointer">
          <span class="text-xl">🚪</span><span class="text-[10px] font-semibold mt-0.5">Salir</span>
        </button>
      </nav>

    </div> <!-- Fin Área Principal -->

    <!-- ================= MODALES GLOBALES ================= -->
    
    <!-- Modal Historial Admin -->
    <div v-if="historyUser" class="absolute inset-0 z-[60] bg-slate-900/60 flex items-center justify-center p-4 backdrop-blur-sm">
      <div class="w-full max-w-lg max-h-[90vh] bg-white rounded-3xl shadow-2xl flex flex-col overflow-hidden">
        <div class="px-6 py-5 bg-slate-50 border-b border-slate-200 flex justify-between items-center">
          <div>
            <h3 class="text-lg font-extrabold text-slate-900">Historial de Usuario</h3>
            <p class="text-sm text-slate-500">{{ historyUser.name }}</p>
          </div>
          <button @click="closeUserHistory" class="w-8 h-8 flex items-center justify-center rounded-full bg-slate-200 hover:bg-slate-300 text-slate-700 font-bold transition">✕</button>
        </div>
        <div class="p-6 overflow-y-auto space-y-6">
          <div>
            <h4 class="text-xs font-bold text-slate-500 tracking-wider mb-3">PRÉSTAMOS REGISTRADOS</h4>
            <div class="space-y-3">
              <div v-for="(loan, idx) in historyUser.loans" :key="idx" class="border-l-4 border-blue-500 bg-slate-50 rounded-xl p-4 flex justify-between items-start shadow-sm">
                <div>
                  <p class="text-sm font-bold text-slate-900">{{ loan.item }}</p>
                  <p class="text-xs text-slate-500 mt-1">Fecha: {{ loan.date }}</p>
                </div>
                <span class="text-[10px] px-2 py-1 rounded bg-blue-100 text-blue-800 font-bold tracking-wider">{{ loan.status }}</span>
              </div>
              <p v-if="historyUser.loans.length === 0" class="text-sm text-slate-400 italic">No registra préstamos.</p>
            </div>
          </div>
          <div>
            <h4 class="text-xs font-bold text-slate-500 tracking-wider mb-3">SANCIONES RECIBIDAS</h4>
            <div class="space-y-3">
              <div v-for="sanction in historyUser.sanctions" :key="sanction.id" class="border-l-4 border-red-500 bg-red-50 rounded-xl p-4 shadow-sm">
                <div class="flex justify-between mb-1">
                  <p class="text-sm font-bold text-red-800">{{ sanction.level }} ({{ sanction.days }} días)</p>
                  <span class="text-[10px] px-2 py-0.5 rounded bg-red-200 text-red-900 font-bold">ACTIVA</span>
                </div>
                <p class="text-xs text-slate-700 font-medium">{{ sanction.item }}</p>
                <p class="text-xs text-slate-600 mt-1">{{ sanction.reason }}</p>
                <p class="text-xs text-slate-500 mt-2">Vigente hasta {{ sanction.until }}</p>
              </div>
              <p v-if="historyUser.sanctions.length === 0" class="text-sm text-slate-400 italic">No registra sanciones.</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal Apelación Estudiante -->
    <div v-if="showAppealModal" class="absolute inset-0 z-[60] bg-slate-900/60 flex items-center justify-center p-4 backdrop-blur-sm">
      <div class="w-full max-w-md bg-white rounded-3xl shadow-2xl p-6 md:p-8 space-y-4">
        <div>
          <h3 class="text-xl font-extrabold text-slate-900">Formular Apelación</h3>
          <p class="text-sm text-slate-500 mt-1">Motivo original: {{ activeSanction?.reason }}</p>
        </div>
        <textarea v-model="appealText" rows="5" placeholder="Explica tu justificación (puedes agregar enlaces a Drive)..." class="w-full px-4 py-3 border border-slate-300 rounded-xl text-sm text-slate-700 bg-slate-50 focus:bg-white focus:outline-none focus:border-blue-500 focus:ring-4 focus:ring-blue-500/10 resize-none transition"></textarea>
        <div class="flex gap-3 pt-2">
          <button @click="closeAppealModal" class="flex-1 py-3 rounded-xl text-sm font-bold bg-slate-100 hover:bg-slate-200 text-slate-700 transition">
            Cancelar
          </button>
          <button @click="submitAppeal" :disabled="!appealText.trim()" class="flex-1 py-3 rounded-xl text-sm font-bold text-white transition bg-[#1e3a5f] hover:bg-[#152a45] disabled:bg-slate-300 disabled:cursor-not-allowed">
            Enviar apelación
          </button>
        </div>
      </div>
    </div>

    <!-- Modal Recepción Operador -->
    <div v-if="showReturnModal" class="absolute inset-0 z-[60] bg-slate-900/60 flex items-center justify-center p-4 backdrop-blur-sm">
      <div class="w-full max-w-md bg-white rounded-3xl shadow-2xl overflow-hidden flex flex-col">
        <div class="px-6 py-5 bg-slate-50 border-b border-slate-200">
          <h3 class="text-lg font-extrabold text-slate-900">Recepción de Equipo</h3>
          <p class="text-sm text-slate-500 mt-1">{{ selectedLoan?.itemName }} - {{ selectedLoan?.borrower }}</p>
        </div>
        <div class="p-6 space-y-5">
          <div>
            <h4 class="text-sm font-bold text-slate-800 mb-3">Verificación de Partes ({{ loanCategoryLabel }})</h4>
            <div class="border border-slate-200 bg-slate-50 rounded-xl p-4 space-y-3">
              <label v-for="part in checklistParts" :key="part" class="flex items-center gap-3 text-sm text-slate-700 cursor-pointer">
                <input type="checkbox" :value="part" v-model="checkedParts" class="w-5 h-5 rounded border-slate-300 text-blue-600 focus:ring-blue-500">
                <span>{{ part }}</span>
              </label>
            </div>
          </div>
          <div class="border-t border-slate-200 pt-5 space-y-4">
            <label class="flex items-center gap-3 px-4 py-3 rounded-xl border text-sm font-bold cursor-pointer transition" :class="onTime ? 'bg-emerald-50 border-emerald-200 text-emerald-800' : 'bg-red-50 border-red-200 text-red-700'">
              <input type="checkbox" v-model="onTime" class="w-5 h-5 rounded border-slate-300 text-emerald-600 focus:ring-emerald-500">
              <span>Entregado en la hora límite</span>
            </label>
            <div v-if="!onTime" class="bg-red-50 border border-red-200 rounded-xl p-4">
              <p class="text-xs font-extrabold text-red-700 tracking-wider mb-2">⚠ SANCIÓN AUTOMÁTICA</p>
              <p class="text-xs text-red-700 leading-relaxed">
                El sistema aplicará una sanción <strong>{{ currentSanction.level }} ({{ currentSanction.days }} días)</strong> al estudiante basada en las políticas de "{{ loanCategoryLabel }}".
              </p>
            </div>
          </div>
          <div class="flex gap-3 pt-2">
            <button @click="closeReturnModal" class="flex-1 py-3 rounded-xl text-sm font-bold bg-slate-100 hover:bg-slate-200 text-slate-700 transition">
              Cancelar
            </button>
            <button @click="confirmReceive" class="flex-1 py-3 rounded-xl text-sm font-bold bg-[#1e3a5f] hover:bg-[#152a45] text-white transition shadow-md">
              Confirmar Recepción
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal Formulario de Producto (Admin) -->
    <div v-if="showProductModal" class="absolute inset-0 z-[70] bg-slate-900/60 flex items-center justify-center p-4 backdrop-blur-sm">
      <div class="w-full max-w-lg max-h-[95vh] bg-white rounded-3xl shadow-2xl flex flex-col overflow-hidden">
        <div class="px-6 py-5 bg-slate-50 border-b border-slate-200 flex justify-between items-center">
          <div>
            <h3 class="text-lg font-extrabold text-slate-900">{{ isEditingProduct ? 'Modificar Artículo' : 'Nuevo Artículo' }}</h3>
            <p class="text-sm text-slate-500">{{ isEditingProduct ? 'Actualiza los datos del equipo' : 'Ingresa los datos para el catálogo' }}</p>
          </div>
          <button @click="closeProductModal" class="w-8 h-8 flex items-center justify-center rounded-full bg-slate-200 hover:bg-slate-300 text-slate-700 font-bold transition">✕</button>
        </div>
        
        <div class="p-6 overflow-y-auto space-y-4">
          <div class="grid grid-cols-2 gap-4">
            <div class="flex flex-col gap-1.5">
              <label class="text-xs font-bold text-slate-600 tracking-wider">CÓDIGO</label>
              <input type="text" v-model="productForm.code" :disabled="isEditingProduct" placeholder="Ej: EL-1234" class="w-full px-4 py-2.5 border border-slate-300 rounded-xl text-sm focus:outline-none focus:border-blue-500 disabled:bg-slate-100 disabled:text-slate-500">
            </div>
            <div class="flex flex-col gap-1.5">
              <label class="text-xs font-bold text-slate-600 tracking-wider">CATEGORÍA</label>
              <select v-model="productForm.category" class="w-full px-4 py-2.5 border border-slate-300 rounded-xl text-sm focus:outline-none focus:border-blue-500 bg-white">
                <option value="electricos">Electrónicos</option>
                <option value="libros">Libros</option>
                <option value="deportes">Deportes</option>
              </select>
            </div>
          </div>

          <div class="flex flex-col gap-1.5">
            <label class="text-xs font-bold text-slate-600 tracking-wider">NOMBRE DEL ARTÍCULO</label>
            <input type="text" v-model="productForm.name" placeholder="Ej: Laptop Dell XPS 13" class="w-full px-4 py-2.5 border border-slate-300 rounded-xl text-sm focus:outline-none focus:border-blue-500">
          </div>

          <div class="flex flex-col gap-1.5">
            <label class="text-xs font-bold text-slate-600 tracking-wider">DESCRIPCIÓN</label>
            <textarea v-model="productForm.description" rows="3" placeholder="Detalles técnicos, estado, etc." class="w-full px-4 py-2.5 border border-slate-300 rounded-xl text-sm focus:outline-none focus:border-blue-500 resize-none"></textarea>
          </div>

          <div class="grid grid-cols-2 gap-4">
            <div class="flex flex-col gap-1.5">
              <label class="text-xs font-bold text-slate-600 tracking-wider">TIEMPO MÁXIMO</label>
              <input type="text" v-model="productForm.maxTime" placeholder="Ej: Máx. 7 días" class="w-full px-4 py-2.5 border border-slate-300 rounded-xl text-sm focus:outline-none focus:border-blue-500">
            </div>
            <div class="flex flex-col gap-1.5">
              <label class="text-xs font-bold text-slate-600 tracking-wider">CANTIDAD TOTAL</label>
              <input type="number" min="1" v-model="productForm.totalCount" class="w-full px-4 py-2.5 border border-slate-300 rounded-xl text-sm focus:outline-none focus:border-blue-500">
            </div>
          </div>

          <div class="flex flex-col gap-1.5">
            <label class="text-xs font-bold text-slate-600 tracking-wider">PARTES Y ACCESORIOS (SEPARADOS POR COMA)</label>
            <textarea v-model="productForm.partsString" rows="2" placeholder="Ej: Laptop, Cargador, Mouse inalámbrico, Funda" class="w-full px-4 py-2.5 border border-slate-300 rounded-xl text-sm focus:outline-none focus:border-blue-500 resize-none"></textarea>
            <p class="text-[10px] text-slate-500">Estas partes aparecerán como checklist para el operador en la devolución.</p>
          </div>
        </div>

        <div class="p-5 bg-slate-50 border-t border-slate-200 flex gap-3">
          <button @click="closeProductModal" class="flex-1 py-3 rounded-xl text-sm font-bold bg-white border border-slate-300 hover:bg-slate-100 text-slate-700 transition">
            Cancelar
          </button>
          <button @click="saveProduct" :disabled="!isProductFormValid" class="flex-1 py-3 rounded-xl text-sm font-bold text-white transition bg-[#1e3a5f] hover:bg-[#152a45] disabled:bg-slate-300 disabled:cursor-not-allowed shadow-sm">
            {{ isEditingProduct ? 'Guardar Cambios' : 'Crear Artículo' }}
          </button>
        </div>
      </div>
    </div>

  </div> <!-- Fin Contenedor Principal -->
</template>

<script setup lang="ts">
import { ref, computed, nextTick } from 'vue'

type ViewType =
  | 'main'
  | 'google'
  | 'register'
  | 'student-home'
  | 'catalog'
  | 'item-detail'
  | 'operator-home'
  | 'admin-appeals'
  | 'admin-users'
  | 'admin-catalog'

type Role = 'student' | 'operator' | 'admin'

interface HistoryRecord {
  user: string
  date: string
  status: 'LOANED' | 'RETURNED'
}

interface CatalogItem {
  category: 'electricos' | 'libros' | 'deportes'
  categoryName: string
  code: string
  name: string
  description: string
  stockText: string
  availableCount: number
  totalCount: number
  maxTime: string
  parts: string[]
  history: HistoryRecord[]
}

interface OperatorLoan {
  id: number
  borrower: string
  itemName: string
  itemCode: string
  dueDate: string
  overdue: boolean
}

interface LoanRecord {
  item: string
  code?: string
  category?: string
  date: string
  daysLeft?: number 
  status: 'LOANED' | 'RETURNED'
}

interface SanctionRecord {
  id: number
  rule: string
  reason: string
  item: string
  itemCode: string
  level: string
  days: number
  date: string
  until: string
}

interface AppUser {
  id: number
  name: string
  email: string
  phone: string
  role: 'Estudiante' | 'Operador' | 'Admin'
  suspended: boolean
  loans: LoanRecord[]
  sanctions: SanctionRecord[]
}

interface Appeal {
  id: number
  userId: number
  sanctionId: number
  studentName: string
  email: string
  itemName: string
  itemCode: string
  sanctionLevel: string
  sanctionDays: number
  date: string
  reason: string
  status: 'PENDIENTE' | 'APROBADA' | 'RECHAZADA'
}

const view = ref<ViewType>('main')
const role = ref<Role>('student')
const isLoggedIn = computed(() => !['main', 'google', 'register'].includes(view.value))

const viewTitle = computed(() => {
  if (view.value === 'student-home') return 'Panel de Estudiante'
  if (view.value === 'catalog') return 'Catálogo de Artículos'
  if (view.value === 'item-detail') return 'Detalle de Artículo'
  if (view.value === 'operator-home') return 'Panel de Operador'
  if (view.value === 'admin-appeals') return 'Apelaciones'
  if (view.value === 'admin-users') return 'Gestión de Usuarios'
  if (view.value === 'admin-catalog') return 'Gestión de Catálogo'
  return 'CS Préstamos'
})

// Variables de Login/Registro
const passwordVisible = ref<boolean>(false)
const emailInput = ref<string>('estudiante@unsa.edu.pe')
const password = ref<string>('1234')
const loggingIn = ref<boolean>(false)
const googleEmailLocal = ref<string>('')
const googleError = ref<string | null>(null)
const registeredEmails = ref<string[]>([
  'estudiante@unsa.edu.pe',
  'operador@unsa.edu.pe',
  'admin@unsa.edu.pe',
  'cherrera@unsa.edu.pe',
  'lmendez@unsa.edu.pe'
])
const passwordVisibleRegister = ref<boolean>(false)
const registerPassword = ref<string>('')
const canCheckRegister = ref<boolean>(false)
const registerChecked = ref<boolean>(false)
const registerScroll = ref<HTMLElement | null>(null)

// Variables de Catálogo
const searchQuery = ref<string>('')
const onlyAvailable = ref<boolean>(false)
const catalogContainer = ref<HTMLElement | null>(null)
const selectedItem = ref<CatalogItem | null>(null)

// Panel Operador
const operatorTab = ref<'active' | 'overdue'>('active')
const selectedLoan = ref<OperatorLoan | null>(null)
const checkedParts = ref<string[]>([])
const showReturnModal = ref<boolean>(false)
const onTime = ref<boolean>(true)
const toast = ref<string>('')

const categoryLabels: Record<CatalogItem['category'], string> = {
  electricos: 'Electrónico',
  libros: 'Libro',
  deportes: 'Deporte'
}

const sanctionRules: Record<CatalogItem['category'], { level: string; days: number }> = {
  electricos: { level: 'GRAVE', days: 30 },
  libros: { level: 'MODERADA', days: 15 },
  deportes: { level: 'LEVE', days: 7 }
}

const operatorLoans = ref<OperatorLoan[]>([
  { id: 1, borrower: 'Mauricio Farfán', itemName: 'Laptop Dell XPS 13', itemCode: 'EL-2041', dueDate: '2026-09-25', overdue: false },
  { id: 2, borrower: 'Prof. Sandra Gómez', itemName: 'Algoritmos — Cormen', itemCode: 'LB-0441', dueDate: '2026-10-05', overdue: false },
  { id: 3, borrower: 'Carlos Herrera', itemName: 'Kit de Fútbol', itemCode: 'DP-0071', dueDate: '2026-09-20', overdue: true }
])

const overdueLoans = computed(() => operatorLoans.value.filter(l => l.overdue))
const visibleOperatorLoans = computed(() => operatorTab.value === 'overdue' ? overdueLoans.value : operatorLoans.value)

const checklistParts = computed<string[]>(() => {
  if (!selectedLoan.value) return []
  const found = allCatalogItems.value.find(i => i.code === selectedLoan.value!.itemCode)
  return found ? found.parts : []
})

const loanCategory = computed<CatalogItem['category']>(() => {
  const found = allCatalogItems.value.find(i => i.code === selectedLoan.value?.itemCode)
  return found ? found.category : 'electricos'
})

const loanCategoryLabel = computed(() => categoryLabels[loanCategory.value])
const currentSanction = computed(() => sanctionRules[loanCategory.value])
const isOperator = computed(() => role.value === 'operator')
const isAdmin = computed(() => role.value === 'admin')

// Panel Admin
const historyUser = ref<AppUser | null>(null)
const users = ref<AppUser[]>([
  {
    id: 1, name: 'Mauricio Farfán', email: 'estudiante@unsa.edu.pe', phone: '987654321',
    role: 'Estudiante', suspended: false,
    loans: [
      { item: 'Laptop Dell XPS 13', code: 'EL-2041', category: 'Electrónica', date: '2026-09-25', daysLeft: 3, status: 'LOANED' }
    ],
    sanctions: []
  },
  {
    id: 2, name: 'Carlos Mendoza', email: 'operador@unsa.edu.pe', phone: '987654322',
    role: 'Operador', suspended: false, loans: [], sanctions: []
  },
  {
    id: 3, name: 'Dr. Jorge Ramirez', email: 'admin@unsa.edu.pe', phone: '987654323',
    role: 'Admin', suspended: false, loans: [], sanctions: []
  },
  {
    id: 4, name: 'Carlos Herrera', email: 'cherrera@unsa.edu.pe', phone: '987654324',
    role: 'Estudiante', suspended: true,
    loans: [
      { item: 'Kit de Fútbol', code: 'DP-0071', category: 'Deporte', date: '2026-09-20', daysLeft: -3, status: 'LOANED' },
      { item: 'Laptop Dell XPS 13', code: 'EL-2041', category: 'Electrónica', date: '2026-08-10', status: 'RETURNED' }
    ],
    sanctions: [
      { id: 101, rule: 'RN-11: Devolución oportuna', reason: 'Devolución con retraso', item: 'Kit de Fútbol', itemCode: 'DP-0071', level: 'GRAVE', days: 30, date: '2026-09-20', until: '2026-10-20' }
    ]
  },
  {
    id: 5, name: 'Lucía Méndez', email: 'lmendez@unsa.edu.pe', phone: '987654325',
    role: 'Estudiante', suspended: true,
    loans: [
      { item: 'Proyector Epson EB-X51', code: 'EL-1032', category: 'Electrónica', date: '2026-09-12', status: 'RETURNED' }
    ],
    sanctions: [
      { id: 102, rule: 'RN-11: Devolución oportuna', reason: 'Devolución con retraso', item: 'Proyector Epson EB-X51', itemCode: 'EL-1032', level: 'GRAVE', days: 30, date: '2026-09-18', until: '2026-10-18' }
    ]
  }
])

const appeals = ref<Appeal[]>([
  {
    id: 1, userId: 5, sanctionId: 102, studentName: 'Lucía Méndez', email: 'lmendez@unsa.edu.pe', itemName: 'Proyector Epson EB-X51', itemCode: 'EL-1032', sanctionLevel: 'GRAVE', sanctionDays: 30, date: '2026-09-28', reason: 'Llegué al módulo de préstamos a las 5:10 p. m. y estaba cerrado por un corte de luz en la facultad. Devolví el proyector completo al día siguiente a primera hora. Solicito que se revise la sanción.', status: 'PENDIENTE'
  }
])

const pendingAppealsCount = computed(() => appeals.value.filter(a => a.status === 'PENDIENTE').length)
const sortedAppeals = computed(() => [...appeals.value].sort((a, b) => Number(b.status === 'PENDIENTE') - Number(a.status === 'PENDIENTE')))

const userSearch = ref<string>('')
const normalizeText = (value: string): string => value.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase()

const filteredUsers = computed(() => {
  const query = normalizeText(userSearch.value.trim())
  if (!query) return users.value
  return users.value.filter(u => normalizeText([u.name, u.email, u.phone, u.role, u.suspended ? 'suspendido' : 'activo'].join(' ')).includes(query))
})

// Estudiante
const currentUser = ref<AppUser | null>(null)
const showAppealModal = ref<boolean>(false)
const appealText = ref<string>('')

const isSuspended = computed(() => !!currentUser.value?.suspended)
const activeSanction = computed<SanctionRecord | null>(() => currentUser.value?.sanctions[0] ?? null)
const myAppeal = computed<Appeal | null>(() => {
  if (!currentUser.value || !activeSanction.value) return null
  return appeals.value.find(a => a.userId === currentUser.value!.id && a.sanctionId === activeSanction.value!.id) ?? null
})

const myActiveLoans = computed<LoanRecord[]>(() => currentUser.value?.loans.filter(l => l.status === 'LOANED') ?? [])
const isOverdue = (loan: LoanRecord): boolean => (loan.daysLeft ?? 0) < 0

const availableByCategory = computed(() => {
  const totals = { electricos: 0, libros: 0, deportes: 0 }
  for (const item of allCatalogItems.value) totals[item.category] += item.availableCount
  return totals
})

const canReserve = computed(() => !!selectedItem.value && selectedItem.value.availableCount > 0 && !isSuspended.value)

// Métodos Estudiante
const openAppealModal = (): void => { appealText.value = ''; showAppealModal.value = true }
const closeAppealModal = (): void => { showAppealModal.value = false }
const submitAppeal = (): void => {
  const user = currentUser.value
  const sanction = activeSanction.value
  const text = appealText.value.trim()
  if (!user || !sanction || !text) return

  appeals.value.push({
    id: Math.max(0, ...appeals.value.map(a => a.id)) + 1,
    userId: user.id, sanctionId: sanction.id, studentName: user.name, email: user.email, itemName: sanction.item, itemCode: sanction.itemCode, sanctionLevel: sanction.level, sanctionDays: sanction.days, date: new Date().toLocaleDateString('sv-SE'), reason: text, status: 'PENDIENTE'
  })
  closeAppealModal()
  showToast('Apelación enviada. Un administrador la revisará.')
}

// Globales
const showToast = (message: string): void => {
  toast.value = message
  setTimeout(() => { toast.value = '' }, 4000)
}

const toggleSuspension = (user: AppUser): void => {
  user.suspended = !user.suspended
  showToast(user.suspended ? `Cuenta de ${user.name} suspendida.` : `Suspensión de ${user.name} levantada.`)
}

const onRoleChange = (user: AppUser): void => {
  showToast(`${user.name} ahora es ${user.role}.`)
}

const resolveAppeal = (appeal: Appeal, approve: boolean): void => {
  appeal.status = approve ? 'APROBADA' : 'RECHAZADA'
  if (approve) {
    const user = users.value.find(u => u.id === appeal.userId)
    if (user) {
      user.sanctions = user.sanctions.filter(sc => sc.id !== appeal.sanctionId)
      user.suspended = false
    }
  }
  showToast(approve ? `Apelación aprobada. Sanción anulada para ${appeal.studentName}.` : `Apelación rechazada. La sanción de ${appeal.studentName} se mantiene.`)
}

const openUserHistory = (user: AppUser): void => { historyUser.value = user }
const closeUserHistory = (): void => { historyUser.value = null }

// Catálogo (Datos y Filtros)
const allCatalogItems = ref<CatalogItem[]>([
  { category: 'electricos', categoryName: 'Electrónico', code: 'EL-2041', name: 'Laptop Dell XPS 13', description: 'Intel Core i7, 16GB RAM, 512GB SSD. Ideal para presentaciones y trabajo de campo.', stockText: '2 disp.', availableCount: 2, totalCount: 5, maxTime: 'Máx. 7 días', parts: ['Laptop', 'Cargador', 'Funda', 'Mouse'], history: [{ user: 'Mauricio Farfán', date: '2026-09-25', status: 'LOANED' }, { user: 'Carlos Herrera', date: '2026-08-10', status: 'RETURNED' }] },
  { category: 'electricos', categoryName: 'Electrónico', code: 'EL-1032', name: 'Proyector Epson EB-X51', description: 'Proyector 3LCD, 3600 lúmenes, resolución XGA. Incluye cable HDMI.', stockText: '3 disp.', availableCount: 3, totalCount: 4, maxTime: 'Máx. 3 días', parts: ['Proyector', 'Cable HDMI', 'Control', 'Maletín'], history: [{ user: 'Lucía Méndez', date: '2026-09-12', status: 'RETURNED' }] },
  { category: 'electricos', categoryName: 'Electrónico', code: 'EL-3009', name: 'Tablet Samsung Tab S9', description: 'Android 14, 12.4" AMOLED, lápiz S Pen. Para laboratorios digitales.', stockText: '0 disp.', availableCount: 0, totalCount: 3, maxTime: 'Máx. 5 días', parts: ['Tablet', 'S Pen', 'Funda', 'Cargador'], history: [] },
  { category: 'libros', categoryName: 'Libro', code: 'LB-0441', name: 'Algoritmos — Cormen', description: 'Cormen, Leiserson, Rivest. Referencia obligatoria.', stockText: '1 disp.', availableCount: 1, totalCount: 2, maxTime: 'Máx. 14 días', parts: ['Libro físico', 'Protector'], history: [{ user: 'Ana Torres', date: '2026-09-01', status: 'RETURNED' }] },
  { category: 'libros', categoryName: 'Libro', code: 'LB-0890', name: 'Clean Code — Robert Martin', description: 'Guía para el desarrollo ágil de software.', stockText: '0 disp.', availableCount: 0, totalCount: 1, maxTime: 'Máx. 14 días', parts: ['Libro físico'], history: [{ user: 'Pedro Gómez', date: '2026-08-20', status: 'RETURNED' }] },
  { category: 'deportes', categoryName: 'Deportes', code: 'DP-0071', name: 'Kit de Fútbol', description: 'Balón oficial FIFA, 4 conos de entrenamiento y 2 chalecos de equipo.', stockText: '4 disp.', availableCount: 4, totalCount: 4, maxTime: 'Máx. 2 días', parts: ['Balón', '4 Conos', '2 Chalecos'], history: [] }
])

const filteredItems = computed(() => {
  return allCatalogItems.value.filter(item => {
    const matchesSearch = item.name.toLowerCase().includes(searchQuery.value.toLowerCase()) || item.description.toLowerCase().includes(searchQuery.value.toLowerCase()) || item.code.toLowerCase().includes(searchQuery.value.toLowerCase())
    const matchesAvailability = (view.value === 'admin-catalog') ? true : (!onlyAvailable.value || item.availableCount > 0)
    return matchesSearch && matchesAvailability
  })
})

const electricosItems = computed(() => filteredItems.value.filter(i => i.category === 'electricos'))
const librosItems = computed(() => filteredItems.value.filter(i => i.category === 'libros'))
const deportesItems = computed(() => filteredItems.value.filter(i => i.category === 'deportes'))

const openItemDetail = (item: CatalogItem): void => {
  selectedItem.value = item
  view.value = 'item-detail'
}

// LÓGICA DEL MODAL DE PRODUCTO (ADMIN)
const showProductModal = ref(false)
const isEditingProduct = ref(false)
const productForm = ref({
  category: 'electricos',
  code: '',
  name: '',
  description: '',
  totalCount: 1,
  maxTime: 'Máx. 7 días',
  partsString: ''
})

const isProductFormValid = computed(() => {
  return productForm.value.code.trim() !== '' && 
         productForm.value.name.trim() !== '' && 
         productForm.value.totalCount > 0
})

const openAddProduct = () => {
  isEditingProduct.value = false
  productForm.value = {
    category: 'electricos',
    code: '',
    name: '',
    description: '',
    totalCount: 1,
    maxTime: 'Máx. 7 días',
    partsString: ''
  }
  showProductModal.value = true
}

const openEditProduct = (item: CatalogItem) => {
  isEditingProduct.value = true
  productForm.value = {
    category: item.category,
    code: item.code,
    name: item.name,
    description: item.description,
    totalCount: item.totalCount,
    maxTime: item.maxTime,
    partsString: item.parts.join(', ')
  }
  showProductModal.value = true
}

const closeProductModal = () => {
  showProductModal.value = false
}

const saveProduct = () => {
  const partsArray = productForm.value.partsString.split(',').map(p => p.trim()).filter(p => p !== '')
  const catName = categoryLabels[productForm.value.category as keyof typeof categoryLabels]

  if (isEditingProduct.value) {
    const idx = allCatalogItems.value.findIndex(i => i.code === productForm.value.code)
    if (idx !== -1) {
      const oldItem = allCatalogItems.value[idx]
      const countDiff = productForm.value.totalCount - oldItem.totalCount
      const newAvailable = Math.max(0, oldItem.availableCount + countDiff)

      allCatalogItems.value[idx] = {
        ...oldItem,
        category: productForm.value.category as CatalogItem['category'],
        categoryName: catName,
        name: productForm.value.name,
        description: productForm.value.description,
        totalCount: productForm.value.totalCount,
        availableCount: newAvailable,
        stockText: newAvailable > 0 ? `${newAvailable} disp.` : 'Agotado (0 disp.)',
        maxTime: productForm.value.maxTime,
        parts: partsArray
      }
      showToast('Artículo modificado correctamente.')
    }
  } else {
    const exists = allCatalogItems.value.some(i => i.code === productForm.value.code)
    if (exists) {
      alert('Ya existe un artículo con este código.')
      return
    }

    allCatalogItems.value.push({
      category: productForm.value.category as CatalogItem['category'],
      categoryName: catName,
      code: productForm.value.code,
      name: productForm.value.name,
      description: productForm.value.description,
      totalCount: productForm.value.totalCount,
      availableCount: productForm.value.totalCount,
      stockText: `${productForm.value.totalCount} disp.`,
      maxTime: productForm.value.maxTime,
      parts: partsArray,
      history: []
    })
    showToast('Artículo añadido correctamente.')
  }
  closeProductModal()
}

// Navegación principal / Roles
const enterApp = (fullEmail: string): void => {
  const found = users.value.find(u => u.email.toLowerCase() === fullEmail.toLowerCase())
  currentUser.value = found ?? { id: 0, name: fullEmail.split('@')[0], email: fullEmail.toLowerCase(), phone: '', role: 'Estudiante', suspended: false, loans: [], sanctions: [] }
  
  if (found?.role === 'Admin') { role.value = 'admin'; view.value = 'admin-appeals' } 
  else if (found?.role === 'Operador') { role.value = 'operator'; operatorTab.value = 'active'; view.value = 'operator-home' } 
  else { role.value = 'student'; view.value = 'student-home' }
}

const handleLogin = (): void => {
  if (!emailInput.value || !emailInput.value.endsWith('@unsa.edu.pe')) { alert('Solo correos @unsa.edu.pe'); return }
  loggingIn.value = true
  setTimeout(() => { loggingIn.value = false; enterApp(emailInput.value.trim()) }, 500)
}

const showMainView = (): void => {
  view.value = 'main'
  loggingIn.value = false
  role.value = 'student'
  currentUser.value = null
}

const showGoogleView = (): void => { view.value = 'google'; googleEmailLocal.value = ''; googleError.value = null }
const stripGoogleDomain = (value: string): string => { const domain = '@unsa.edu.pe'; return value.toLowerCase().endsWith(domain) ? value.slice(0, value.length - domain.length) : value }
const onGoogleEmailInput = (): void => { googleError.value = null; googleEmailLocal.value = stripGoogleDomain(googleEmailLocal.value) }

const handleGoogleContinue = (): void => {
  const local = stripGoogleDomain(googleEmailLocal.value.trim())
  if (!local || /[\s@]/.test(local)) { googleError.value = 'Solo correos @unsa.edu.pe'; return }
  const fullEmail = local.toLowerCase() + '@unsa.edu.pe'
  if (!registeredEmails.value.includes(fullEmail)) { googleError.value = 'Correo no registrado.'; return }
  googleError.value = null; enterApp(fullEmail)
}

const showRegisterView = (): void => {
  view.value = 'register'
  canCheckRegister.value = false
  registerChecked.value = false
  nextTick(() => { if (registerScroll.value) registerScroll.value.scrollTop = 0 })
}

const checkRegisterScroll = (): void => {
  const el = registerScroll.value
  if (el && el.scrollTop + el.clientHeight >= el.scrollHeight - 20) canCheckRegister.value = true
}

const scrollToCategory = (categoryKey: string): void => {
  view.value = 'catalog'
  searchQuery.value = ''
  nextTick(() => {
    if (!catalogContainer.value) return
    if (categoryKey === 'all') { catalogContainer.value.scrollTop = 0; return }
    const targetEl = document.getElementById(`section-${categoryKey}`)
    if (targetEl) targetEl.scrollIntoView({ behavior: 'smooth', block: 'start' })
  })
}

// Operador
const openChecklist = (loan: OperatorLoan): void => {
  selectedLoan.value = loan
  checkedParts.value = [...checklistParts.value]
  onTime.value = !loan.overdue
  showReturnModal.value = true
}

const closeReturnModal = (): void => { showReturnModal.value = false; selectedLoan.value = null }

const confirmReceive = (): void => {
  if (!selectedLoan.value) return
  const loan = selectedLoan.value
  toast.value = onTime.value ? `Equipo recibido de ${loan.borrower}.` : `Sanción ${currentSanction.value.level} aplicada a ${loan.borrower}.`
  setTimeout(() => { toast.value = '' }, 4000)
  operatorLoans.value = operatorLoans.value.filter(l => l.id !== loan.id)
  closeReturnModal()
}
</script>