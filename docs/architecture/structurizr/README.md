# Mapa de contextos DDD en Structurizr

[`workspace.dsl`](workspace.dsl) contiene una única vista estratégica del dominio: `MapaContextosDDD`. La vista se basa en el [README del proyecto](../../../README.md) y en el [análisis de requisitos](../../requirements/README.md). No representa funcionalidades implementadas, servicios desplegados, tablas, clases ni contratos de API.

## Vista disponible

| Vista | Contenido |
| --- | --- |
| `MapaContextosDDD` | Mapa de contextos delimitados DDD del sistema de préstamos universitarios. |

La vista busca explicar la división estratégica del dominio en pocos segundos. Por eso muestra solo bounded contexts y dependencias principales; los agregados, entidades, atributos y multiplicidades pertenecen al [modelo UML en PlantUML](../uml/README.md).

## Contextos representados

- **Préstamos (loans) — central:** registra préstamos y devoluciones; coordina las condiciones para ocupar un ejemplar.
- **Inventario (inventory) — soporte:** gestiona recursos, ejemplares físicos y disponibilidad.
- **Usuarios (users) — soporte:** gestiona solicitudes, vinculación institucional y estado del usuario.
- **Confianza — soporte:** mantiene porcentaje, nivel, sanciones y restricciones asociadas al usuario.
- **Reglas y Términos — soporte:** administra reglas vigentes, versiones, incumplimientos y términos aceptados.
- **Autenticación (auth) — genérico de apoyo:** proporciona identidad autenticada, rol y control de acceso.

Esta clasificación orienta responsabilidades del dominio. No define microservicios, bases de datos separadas ni mecanismos de integración.

## Relaciones principales

Las flechas se mantienen breves para priorizar legibilidad:

- **Préstamos → Usuarios:** verifica que el usuario exista y esté habilitado.
- **Préstamos → Inventario:** consulta disponibilidad y ocupa/libera ejemplares.
- **Préstamos → Confianza:** considera restricciones derivadas del nivel o sanciones vigentes.
- **Préstamos → Autenticación:** requiere identidad autenticada y permisos.
- **Reglas y Términos → Confianza:** los incumplimientos reducen confianza según reglas vigentes.
- **Confianza → Usuarios:** asocia porcentaje, nivel y sanciones al usuario.
- **Autenticación → Usuarios:** vincula la cuenta de acceso con el usuario institucional.

No se agregan funcionalidades fuera de los requisitos actuales. Los valores pendientes, como umbrales de confianza, restricciones concretas o consecuencias ejecutables, siguen sin definirse.

## Ejecución local

Requisito: Java disponible. Desde la raíz del repositorio, en PowerShell:

```powershell
java -jar .\docs\architecture\structurizr\structurizr.war validate -workspace .\docs\architecture\structurizr\workspace.dsl
java -jar .\docs\architecture\structurizr\structurizr.war local .\docs\architecture\structurizr
```

Abrir <http://localhost:8080> y seleccionar la vista `MapaContextosDDD`. Para detener el proceso, usar `Ctrl+C`.

`workspace.dsl` es la fuente versionada. Los archivos generados por Structurizr Local, como `workspace.json`, no sustituyen al DSL.
