# Modelo de dominio UML

[`modelo-dominio.puml`](modelo-dominio.puml) es el diagrama de clases conceptual del sistema. Está alineado con el [análisis de requisitos](../../requirements/README.md) vigente; no representa clases implementadas, tablas de PostgreSQL, DTO ni contratos de API. Las [vistas de Structurizr](../structurizr/README.md) todavía describen el modelo estratégico inicial y deberán actualizarse por separado.

## Límites y agregados

| Contexto o área | Agregados y raíces | Responsabilidad representada |
| --- | --- | --- |
| Usuarios / `users` — soporte | `SolicitudRegistro`; `Usuario` | Separa la solicitud y sus evidencias de la identidad aprobada. Mantiene tipo institucional, vinculación, confianza, sanciones e habilitación para préstamos. |
| Inventario / `inventory` — soporte | `CategoriaRecurso`; `Recurso`; `Ejemplar` | Define el plazo por categoría, el catálogo de recursos y cada unidad física prestable con sus observaciones. |
| Préstamos / `loans` — central | `Prestamo` | Registra el intervalo temporal en el que un ejemplar queda ocupado por un usuario, incluyendo préstamos inmediatos o planificados. |
| Autenticación / `auth` — genérico de apoyo | `CuentaAcceso` | Vincula una identidad de usuario con su rol de acceso sin mezclar permisos con la clasificación institucional. |
| Reglas y términos — límite por validar | `ReglaUso`; `VersionRegla`; `Incumplimiento`; `VersionTerminos`; `AceptacionTerminos` | Modela reglas versionadas, penalizaciones históricas y aceptación de términos. No se afirma todavía que esta área sea un bounded context independiente. |

Los agregados se mantienen pequeños y las relaciones entre ellos se expresan mediante identificadores. Las composiciones solo aparecen donde un objeto forma parte del ciclo de vida de su agregado: evidencias de una solicitud, porcentaje de confianza del usuario como valor, sanciones históricas del usuario, observaciones de un ejemplar y devolución de un préstamo.

## Usuarios, confianza y acceso

- `SolicitudRegistro` conserva el tipo de usuario, el identificador institucional cuando corresponda, la fecha, el estado y cero o más evidencias de vinculación. La dependencia punteada indica que una solicitud aprobada puede originar un usuario; no representa una asociación persistente entre ambos agregados. El procedimiento de verificación sigue pendiente.
- `Usuario` es la raíz que conserva la identidad institucional ya habilitada. `TipoUsuario` distingue `ESTUDIANTE`, `DOCENTE` y `ADMINISTRATIVO`.
- `PorcentajeConfianza` es un Value Object del agregado `Usuario` porque protege la invariante del intervalo cerrado de 0 a 100. El nivel se deriva del porcentaje y solo se representan cuatro identificadores provisionales (`NIVEL_1` a `NIVEL_4`); sus nombres y umbrales definitivos no están definidos.
- `Sancion` es una entidad del agregado `Usuario`. Conserva si la penalización está activa o finalizada, sus fechas de inicio y fin, la referencia opcional al incumplimiento, la regla y la versión de regla que la originaron, y el cambio de confianza mediante `confianzaAnterior` y `confianzaPosterior`. La colección de sanciones funciona como historial; no se define un modelo separado `HistorialSanciones` ni se sobrescriben sanciones finalizadas.
- `/penalizadoActualmente` y `/habilitadoParaPrestamos` son valores derivados. La habilitación considera vinculación vigente, confianza, sanciones activas y restricciones o consecuencias aplicables. El modelo no inventa una fórmula ni restricciones concretas.
- `CuentaAcceso` mantiene una correspondencia conceptual uno a uno con `Usuario`. Su estado `/habilitada` requiere una solicitud aprobada y vinculación vigente con la EPCC; no sustituye `/habilitadoParaPrestamos`, que además considera confianza y restricciones del dominio. `TipoUsuario.ADMINISTRATIVO` describe la relación de una persona con la EPCC; `RolAcceso.ADMINISTRADOR` concede permisos dentro del sistema. Son conceptos distintos. La fórmula de habilitación, las credenciales y el proveedor de autenticación permanecen pendientes.

## Inventario y préstamos

- `CategoriaRecurso` define el tiempo máximo de préstamo. `Recurso` referencia su categoría y representa una entrada del catálogo. `Ejemplar` referencia el recurso y representa una unidad física. Cada recurso tiene uno o varios ejemplares registrados.
- `/disponible` de `Recurso` se deriva de que exista al menos un ejemplar `DISPONIBLE`; no se almacena como una fuente de verdad adicional.
- `EstadoEjemplar.NO_DISPONIBLE` permite conservar una unidad que, después de una devolución o incidencia, no puede seguir prestándose. Las observaciones pertenecen al agregado `Ejemplar` y registran el estado detectado sin inventar categorías de daño.
- Cada `Prestamo` referencia exactamente un usuario y un ejemplar. `fechaInicio` y `fechaFin` representan el intervalo en el que el ejemplar está ocupado, tanto para préstamos inmediatos como para préstamos planificados.
- Un ejemplar no puede tener préstamos activos o planificados con intervalos superpuestos. Las multiplicidades `0..*` representan el historial por ejemplar, no autorización para solapar ocupaciones.
- `fechaFin` queda fijada al crear o planificar el préstamo a partir del tiempo de la categoría. Es una instantánea del plazo aplicado: modificar después una categoría no cambia préstamos existentes.
- La devolución es un Value Object opcional del préstamo y su fecha no puede ser anterior a `fechaInicio`. El estado derivado puede ser `PLANIFICADO`, `ACTIVO` o `FINALIZADO`; `/vencido` indica que un préstamo no finalizado superó `fechaFin`.
- Registrar un préstamo y cambiar el ejemplar a `PRESTADO` deben coordinarse de forma atómica, también ante concurrencia. Al devolver, el ejemplar solo pasa a `DISPONIBLE` si puede seguir prestándose; de lo contrario queda `NO_DISPONIBLE` y se conserva la observación correspondiente.

## Reglas, incumplimientos y términos

- `ReglaUso` se asocia por identificador con una o más raíces `VersionRegla` y conserva `versionVigenteId`. Cada versión registra `reglaId`, título, descripción, porcentaje de penalización, consecuencia y estado, y es inmutable una vez histórica. `VersionRegla` es un agregado independiente porque otros agregados, en particular `Incumplimiento`, deben referenciar directamente la versión histórica sin atravesar ni cargar `ReglaUso`. Modificar una regla genera una versión que no altera las anteriores.
- `Incumplimiento` referencia al usuario, la regla y la versión exacta infringida. También conserva `penalizacionAplicada`, por lo que una modificación posterior no cambia el descuento histórico.
- `Sancion` representa la penalización aplicada al usuario y su duración. Cuando proviene de una regla incumplida, conserva referencias por identificador al incumplimiento, la regla y la versión usada para no depender de cambios posteriores.
- Registrar el incumplimiento, aplicar la sanción y actualizar el porcentaje de confianza debe ser una operación consistente. El mecanismo técnico de coordinación se definirá durante el diseño de implementación.
- `VersionTerminos` y `AceptacionTerminos` permiten saber qué versión aceptó cada usuario y cuándo. No se relaciona una versión de términos con versiones de reglas porque la composición de los términos sigue pendiente.
- La consecuencia se conserva como información conceptual de la regla. Su representación y ejecución automática aún no están definidas.

## Decisiones deliberadamente pendientes

El diagrama NO define todavía:

- porcentaje inicial de confianza;
- nombres y umbrales definitivos de los cuatro niveles;
- restricciones concretas por nivel de confianza o tipo de usuario;
- límite de préstamos simultáneos para estudiantes;
- mecanismos para aumentar la confianza;
- procedimiento de verificación de la vinculación con la EPCC;
- credenciales o proveedor de autenticación;
- consecuencias ejecutables y restricciones concretas asociadas a una sanción activa;
- composición de una versión de términos;
- estrategia transaccional, restricciones de persistencia o esquema de base de datos.

Tampoco introduce subclases por tipo de usuario o recurso, un motor de reglas, eventos de dominio, sagas ni otros patrones que los requisitos actuales no justifican.

## Renderizado local

Se requiere Java y un [JAR de PlantUML](https://plantuml.com/download). El archivo usa el motor Smetana incluido en PlantUML para no depender de una instalación separada de Graphviz.

Validado con Java 21 y PlantUML 1.2026.6 mediante comprobación de sintaxis, generación SVG/PNG y revisión visual del PNG.

Desde la raíz del repositorio, en PowerShell:

```powershell
$env:PLANTUML_JAR = 'C:\herramientas\plantuml.jar'
$salida = Join-Path $env:TEMP 'prestamos-uml'
New-Item -ItemType Directory -Force -Path $salida | Out-Null
java -jar $env:PLANTUML_JAR -charset UTF-8 --check-syntax docs/architecture/uml/modelo-dominio.puml
java -jar $env:PLANTUML_JAR -charset UTF-8 --format svg --output-dir $salida docs/architecture/uml/modelo-dominio.puml
java -jar $env:PLANTUML_JAR -charset UTF-8 --format png --output-dir $salida docs/architecture/uml/modelo-dominio.puml
```

Sustituir la ruta del JAR por su ubicación local. Los renderizados se mantienen fuera del repositorio; el archivo `.puml` es la fuente versionada.

Referencias de sintaxis y ejecución: [diagrama de clases](https://plantuml.com/class-diagram) y [línea de comandos de PlantUML](https://plantuml.com/command-line).
