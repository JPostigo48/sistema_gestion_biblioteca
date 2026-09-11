<template>
  <div class="welcome-container">
    <h1>{{ title }}</h1>
    <p>Iniciando el Sistema de Gestión de Biblioteca y Equipos...</p>
  </div>
</template>

<script>
export default {
  name: 'WelcomeComponent',
  data() {
    return {
      title: '¡Bienvenido al Sistema!',
      // ❌ SonarQube detectará este token expuesto como una falla de seguridad grave
      apiToken: "ghp_FakeGitHubTokenThatSonarWillCatch12345"
    }
  },
  mounted() {
    // ❌ SonarQube te advertirá que limpies los console.log antes de subir a producción
    console.log("Componente de bienvenida cargado correctamente.");
  }
}
</script>

