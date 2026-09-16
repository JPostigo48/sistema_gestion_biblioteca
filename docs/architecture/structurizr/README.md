# Diseño DDD en Structurizr

[`workspace.dsl`](workspace.dsl) contiene las vistas estratégicas y de colaboración del dominio para el sistema de gestión de préstamos universitarios. Las vistas se basan en el [README del proyecto](../../../README.md), el [análisis de requisitos](../../requirements/README.md) y el [modelo UML conceptual](../uml/README.md). No representan funcionalidades implementadas, servicios desplegados, tablas, clases ni contratos de API.

## Vistas disponibles

| Vista | Propósito |
| --- | --- |
| `MapaContextosDDD` | Mapa de bounded contexts y dependencias principales del dominio. |
| `VistaInternaDDD` | Organización conceptual interna por bounded context, agregados, raíces y conceptos de soporte. |
| `CicloCompletoPrestamo` | Vista dinámica del ciclo de solicitud, registro y devolución de un préstamo, incluyendo rechazos relevantes. |

## Mapa de contextos DDD

El mapa conserva seis contextos principales:

- **Préstamos (loans) — central:** registra préstamos y devoluciones; coordina las condiciones para ocupar un ejemplar.
- **Inventario (inventory) — soporte:** gestiona recursos, ejemplares físicos y disponibilidad.
- **Usuarios (users) — soporte:** gestiona solicitudes, vinculación institucional y estado del usuario.
- **Confianza — soporte:** evalúa porcentaje, nivel, sanciones y restricciones. El estado histórico de confianza se mantiene asociado al usuario.
- **Reglas y Términos — soporte:** administra reglas vigentes, versiones, incumplimientos y términos aceptados.
- **Autenticación (auth) — genérico de apoyo:** proporciona identidad autenticada, rol y control de acceso.

Esta clasificación orienta responsabilidades del dominio. No define microservicios, bases de datos separadas ni mecanismos de integración.

## Vista interna DDD

La vista interna muestra bounded contexts, agregados, aggregate roots y conceptos necesarios para explicar los límites de consistencia. No reemplaza al UML: evita atributos de clase y se concentra en responsabilidades, composición conceptual y referencias por identificador.

Puntos principales:

- **Usuarios** conserva `Usuario`, solicitud de registro, evidencias, confianza del usuario y sanciones históricas.
- **Confianza** no duplica entidades de Usuarios; representa evaluación, restricciones y cambios derivados de incumplimientos usando `usuarioId` y referencias históricas.
- **Inventario** separa categoría, recurso y ejemplar físico. La disponibilidad del recurso se deriva de sus ejemplares.
- **Préstamos** contiene el agregado `Préstamo`, su intervalo, estado, devolución e invariantes de habilitación y no superposición.
- **Reglas y Términos** conserva reglas, versiones, incumplimientos, versiones de términos y aceptaciones históricas.
- **Autenticación** mantiene cuenta de acceso y roles, sin confundir rol de acceso con tipo institucional de usuario.

## Vista dinámica del préstamo

`CicloCompletoPrestamo` muestra la colaboración conceptual entre contextos cuando un usuario intenta obtener un ejemplar y luego lo devuelve. Incluye caminos de rechazo para usuario no autenticado, usuario no habilitado, sanción activa, restricción por confianza, ejemplar no disponible e intervalo superpuesto.

La vista no define endpoints, mensajes técnicos, eventos, controladores ni protocolos. Cada paso indica qué contexto participa o toma una decisión del dominio.

## Ejecución local

Requisito: Java disponible. Desde la raíz del repositorio, en PowerShell:

```powershell
java -jar .\docs\architecture\structurizr\structurizr.war validate -workspace .\docs\architecture\structurizr\workspace.dsl
java -jar .\docs\architecture\structurizr\structurizr.war local .\docs\architecture\structurizr
```

Abrir <http://localhost:8080> y seleccionar la vista requerida. Para detener el proceso, usar `Ctrl+C`.

`workspace.dsl` es la fuente versionada. Los archivos generados por Structurizr Local, como `workspace.json`, no sustituyen al DSL.
