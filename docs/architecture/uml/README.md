# Modelo de dominio UML

[`modelo-dominio.puml`](modelo-dominio.puml) es un diagrama de clases conceptual en PlantUML. Detalla el modelo propuesto en las [vistas DDD de Structurizr](../structurizr/README.md); no representa clases implementadas ni tablas de PostgreSQL.

## Límites y responsabilidades

| Contexto / módulo | Agregados y raíces | Justificación |
| --- | --- | --- |
| Usuarios / `users` | Usuario | Identidad y datos de la persona registrada. |
| Inventario / `inventory` | Recurso; Ejemplar | Recurso describe una entrada del catálogo. Ejemplar identifica una unidad física y controla su estado de disponibilidad. Son agregados independientes para no modificar todo el catálogo o sus ejemplares al prestar una unidad. |
| Préstamos / `loans` | Préstamo | Registra la relación temporal entre una persona y una unidad física, sus fechas y finalización. Es el contexto central. |
| Autenticación / `auth` | CuentaAcceso | Asocia una identidad de usuario con su rol de acceso, sin mezclar los permisos con los datos personales. Es un contexto genérico de apoyo. |

Usuarios e Inventario son contextos de soporte. Cada agregado contiene únicamente su raíz, que es una entidad: no se necesitan entidades internas artificiales. Las enumeraciones describen valores permitidos, no agregados adicionales. No se introducen Value Objects porque todavía no existen reglas de valor o comportamientos que justifiquen clases específicas. Los tipos `UsuarioId`, `RecursoId`, `EjemplarId` y `PrestamoId` expresan identidades conceptuales; su representación técnica está pendiente.

## Catálogo, unidades y préstamos

- Un Recurso puede tener cero o más Ejemplares. Cada Ejemplar pertenece a un único Recurso mediante `recursoId`. Un registro de catálogo sin unidades no está disponible para préstamo.
- Al solicitar un libro se consulta si existe algún Ejemplar `DISPONIBLE` del Recurso. El préstamo se registra sobre el `ejemplarId` seleccionado, no sobre el libro del catálogo en general. El mismo criterio permite representar equipos y otros recursos sin añadir jerarquías por tipo.
- Cada Préstamo referencia exactamente un Usuario y un Ejemplar mediante sus identificadores. Las multiplicidades `0..*` representan el historial; solo puede existir un préstamo activo por unidad física.
- La disponibilidad del Recurso se obtiene de sus ejemplares; no se duplica como atributo independiente. Un Ejemplar pasa a `PRESTADO` con el préstamo y a `DISPONIBLE` con su devolución.
- `/estado` de Préstamo es derivado: sin `fechaDevolucion` es `ACTIVO`; con ella es `FINALIZADO`. La devolución no puede ser anterior al préstamo. `FechaHora` expresa un instante conceptual; formato y zona horaria se definirán antes de implementar. No se añaden vencimientos, reservas ni sanciones.

Los límites de agregado NO garantizan por sí solos la consistencia entre Inventario y Préstamos. Registrar el préstamo y cambiar la disponibilidad deben coordinarse de forma atómica, también frente a concurrencia; igual ocurre al devolver. Consultar disponibilidad antes de escribir no basta. La estrategia transaccional y las restricciones de persistencia se definirán al diseñar la implementación.

## Acceso y aspectos pendientes

Se propone una CuentaAcceso por Usuario, identificada con el mismo `usuarioId`, y un único rol inicial: `USUARIO` u `OPERADOR`. Este último agrupa al administrador u operador del informe; no se inventan permisos distintos para ambos. La relación uno a uno es una decisión inicial de modelado, no una exigencia técnica de autenticación. Credenciales, proveedor y mecanismo de autenticación quedan pendientes.

El rol determina acceso, no categorías académicas. Estudiante, docente y personal administrativo siguen fuera de esta versión del modelo, al igual que reglas diferenciadas por categoría. Tampoco se especifican todavía políticas de eliminación o cambios de clasificación de ejemplares con historial.

## Renderizado local

Se requiere Java y un [JAR de PlantUML](https://plantuml.com/download). El archivo usa el motor Smetana incluido en PlantUML para no depender de una instalación separada de Graphviz.

Validado con Java 21 y PlantUML 1.2026.6: comprobación de sintaxis y generación SVG/PNG sin errores, con revisión visual del PNG.

Desde la raíz del repositorio, en PowerShell:

```powershell
$env:PLANTUML_JAR = 'C:\herramientas\plantuml.jar'
$salida = Join-Path $env:TEMP 'prestamos-uml'
New-Item -ItemType Directory -Force -Path $salida | Out-Null
java -jar $env:PLANTUML_JAR -charset UTF-8 --check-syntax docs/architecture/uml/modelo-dominio.puml
java -jar $env:PLANTUML_JAR -charset UTF-8 --format svg --output-dir $salida docs/architecture/uml/modelo-dominio.puml
```

Sustituir la ruta del JAR por su ubicación local. La salida será `$salida/ModeloDominio.svg`, que puede abrirse en el navegador. Para PNG, sustituir `svg` por `png`. Los binarios y renderizados se mantienen fuera del repositorio; el archivo `.puml` es la fuente versionada.

Referencias de sintaxis y ejecución: [diagrama de clases](https://plantuml.com/class-diagram) y [línea de comandos de PlantUML](https://plantuml.com/command-line).
