# Organización inicial del dominio

`workspace.dsl` contiene un único diagrama: **DominioInicial**. Se basa en el informe de análisis de requisitos y diseño del dominio y en el [README del proyecto](../../../README.md).

## Lectura del diagrama

- **Usuarios (`users`):** registro, consulta y tipo de usuario.
- **Inventario (`inventory`):** registro, consulta, clasificación y disponibilidad de recursos.
- **Préstamos (`loans`):** préstamos, devoluciones, validación de disponibilidad e historial; contiene el concepto central del dominio.
- **Autenticación (`auth`):** autenticación y control básico de acceso.

Las flechas expresan asociaciones conceptuales del préstamo con el usuario y el recurso; no representan llamadas HTTP, dependencias de código ni un orden de ejecución. `auth` se muestra sin relaciones porque su integración todavía no está definida.

Se utiliza una vista personalizada de Structurizr para representar módulos propuestos, no contenedores C4 ni servicios desplegados. Esta organización orienta el trabajo con DDD, pero aún no define contextos delimitados definitivos, categorías de subdominios ni límites de agregados. Las funcionalidades mostradas están planificadas, no implementadas. PlantUML se reserva para los diagramas UML del curso; no se incluyen en esta entrega.

## Ejecución local

Requisito: Docker instalado y en ejecución, con soporte para contenedores Linux. Desde la raíz del repositorio, en PowerShell:

```powershell
$workspace = (Resolve-Path .\docs\architecture\structurizr).Path
docker run -it --rm -p 127.0.0.1:8080:8080 --mount "type=bind,source=$workspace,target=/usr/local/structurizr" structurizr/structurizr local
```

Abrir <http://localhost:8080> y seleccionar **DominioInicial**. Para detener el proceso, usar `Ctrl+C`. El comando descarga la imagen si no está disponible; no compila el proyecto ni requiere ejecutar el frontend, backend o PostgreSQL.

Editar `workspace.dsl` como fuente del modelo y recargar el navegador para ver los cambios. No se ha comprobado la ejecución del contenedor en el entorno de desarrollo actual, donde Docker no está disponible.

Referencias: [ejecución local](https://docs.structurizr.com/local/quickstart) y [vistas personalizadas](https://docs.structurizr.com/dsl/cookbook/custom-view/).
