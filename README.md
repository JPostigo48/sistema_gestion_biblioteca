# Sistema de gestión de préstamos universitarios

Sistema en planificación para registrar y controlar préstamos de libros, equipos y otros recursos académicos de una institución universitaria. Busca centralizar la información de usuarios, recursos y préstamos para consultar ejemplares disponibles de cada recurso y conocer quién tiene prestada cada unidad física.

## Estado actual

El repositorio se encuentra en etapa de documentación inicial. El [análisis de requisitos](docs/requirements/README.md) es la fuente principal de la planificación actual. El [modelo de dominio UML en PlantUML](docs/architecture/uml/README.md) ya refleja esta ampliación; las [vistas DDD en Structurizr](docs/architecture/structurizr/README.md) representan la división estratégica, la interacción entre contextos y las vistas internas por contexto. **No hay funcionalidades implementadas**, configuración de ejecución de la aplicación ni esquema de base de datos.

## Alcance inicial planificado

- Solicitud, verificación y aprobación de cuentas para usuarios vinculados con la EPCC.
- Registro y consulta de recursos, sus ejemplares físicos y su disponibilidad.
- Registro de préstamos y devoluciones, considerando disponibilidad, habilitación del usuario y restricciones vigentes.
- Consulta de préstamos activos, vencimientos e historial por usuario.
- Autenticación y control de acceso según permisos.
- Gestión del porcentaje y nivel de confianza del usuario.
- Gestión dinámica de reglas, incumplimientos, consecuencias y versiones de términos y condiciones.

La planificación contempla estudiantes, docentes y personal administrativo, así como tiempos de préstamo por categoría de recurso y restricciones configurables. Permanecen pendientes, entre otros valores, los umbrales y porcentaje inicial de confianza, las restricciones concretas por nivel y el posible límite de préstamos activos para estudiantes. El detalle y estado de cada definición se mantiene en [`docs/requirements/`](docs/requirements/README.md).

## Tecnologías seleccionadas

| Área | Tecnología |
| --- | --- |
| Frontend | Vue.js con TypeScript |
| Backend | Node.js con TypeScript |
| Base de datos | PostgreSQL |
| Comunicación | API entre frontend y backend |
| Modelado y documentación | DDD, UML, Structurizr y PlantUML |

Estas tecnologías están seleccionadas. Structurizr cuenta con vistas DDD de contexto, interacción e internas por contexto; PlantUML contiene el modelo de clases conceptual. Las herramientas de la aplicación aún están pendientes.

## Organización actual

```text
.
├── backend/
├── frontend/
├── docs/
│   ├── architecture/
│   │   ├── structurizr/
│   │   │   ├── README.md
│   │   │   └── workspace.dsl
│   │   └── uml/
│   │       ├── README.md
│   │       └── modelo-dominio.puml
│   └── requirements/
│       ├── README.md
│       ├── functional.md
│       ├── non-functional.md
│       ├── business-rules.md
│       ├── trust-model.md
│       └── terms-and-conditions.md
├── .gitignore
└── README.md
```

`docs/requirements/` contiene el análisis vigente. `docs/architecture/uml/` contiene el modelo conceptual de clases alineado con ese análisis y `docs/architecture/structurizr/` contiene vistas DDD de contexto, interacción e internas por contexto. `backend/` y `frontend/` siguen vacíos y solo existen localmente; Git no los versiona mientras no contengan archivos.

## Arquitectura planteada

La arquitectura inicial propone los módulos `users`, `inventory`, `loans` y `auth`, responsables de usuarios, recursos, préstamos y control de acceso. El mapa Structurizr separa además Confianza y Reglas y Términos como contextos estratégicos de soporte para reflejar la planificación vigente. Esta división está propuesta, no implementada.

Dentro de cada módulo se separarán las responsabilidades que resulten necesarias:

- **Dominio:** entidades y reglas de negocio, independientes de frameworks y persistencia.
- **Aplicación:** casos de uso que coordinan las operaciones del dominio.
- **Infraestructura:** acceso a PostgreSQL y adaptadores técnicos.
- **Presentación:** controladores y puntos de entrada de la API.

Vue.js presentará la información y enviará solicitudes a la API. Los casos de uso aplicarán las reglas del dominio y coordinarán la persistencia mediante contratos implementados en infraestructura. El dominio no dependerá directamente de PostgreSQL ni de los controladores HTTP.

Se tomará Clean Architecture como referencia, con separación de responsabilidades proporcional al proyecto, sin introducir capas, patrones o dependencias que aún no sean necesarios.

## Dominio y enfoque DDD

El modelo distingue **Usuario**, **Recurso**, **Ejemplar** y **Préstamo**. Recurso describe una entrada del catálogo y Ejemplar una unidad física de ese recurso. El préstamo es el concepto central: vincula temporalmente a un usuario con un ejemplar y registra sus fechas; su estado se deriva de la existencia de fecha de devolución.

Los contextos delimitados actuales son **Préstamos** (central), **Usuarios**, **Inventario**, **Confianza** y **Reglas y Términos** (soporte), además de **Autenticación** como genérico de apoyo. Esta clasificación orienta las responsabilidades y no define microservicios.

El [modelo UML vigente](docs/architecture/uml/README.md) detalla los agregados, entidades, Value Objects y enumeraciones derivados de los requisitos actuales. Recurso y Ejemplar se mantienen separados para gestionar cada unidad de forma independiente, y las referencias entre agregados usan identificadores.

Reglas iniciales:

- Cada préstamo identifica a un usuario registrado y a un ejemplar de un recurso registrado.
- Un recurso puede prestarse si tiene al menos un ejemplar disponible; cada préstamo corresponde a una unidad física.
- Un ejemplar no puede participar en más de un préstamo activo, incluso ante solicitudes concurrentes. Sí pueden prestarse otros ejemplares del mismo recurso.
- Registrar un préstamo y pasar su ejemplar a prestado deben ser una operación consistente.
- Registrar la devolución finaliza el préstamo y vuelve a dejar disponible su ejemplar cuando su estado permite continuar prestándolo; el historial se conserva.
- La fecha de devolución no puede ser anterior al préstamo; sin devolución el préstamo está activo.

## Objetivos y definiciones pendientes

El informe plantea respuestas de aproximadamente 2 segundos como máximo en condiciones normales, al menos 50 usuarios simultáneos y capacidad inicial para 300 usuarios registrados. Son objetivos **no verificados**; falta concretar las condiciones y pruebas de aceptación.

Antes de implementar se deben definir el modelo de datos y el formato de los identificadores, el detalle de permisos por rol, el mecanismo de autenticación, los contratos de la API, el tratamiento de fechas, los valores pendientes del modelo de confianza y la estrategia transaccional para evitar préstamos activos duplicados. También quedan pendientes la actualización de Structurizr, las herramientas de ejecución, persistencia, migraciones y pruebas.
