# Sistema de gestión de préstamos universitarios

Sistema en planificación para registrar y controlar préstamos de libros, equipos y otros recursos académicos de una institución universitaria. Busca centralizar la información de usuarios, recursos y préstamos para conocer la disponibilidad de cada recurso y quién lo tiene asignado.

## Estado actual

El repositorio se encuentra en etapa de documentación inicial. Cuenta con este README y un [primer diagrama de organización del dominio en Structurizr](docs/architecture/structurizr/README.md), con instrucciones de ejecución local. **No hay funcionalidades implementadas**, configuración de ejecución de la aplicación ni esquema de base de datos.

## Alcance inicial planificado

- Gestión de usuarios y su tipo.
- Registro y consulta de recursos y su disponibilidad.
- Registro de préstamos y devoluciones.
- Consulta de préstamos activos y conservación del historial de préstamos finalizados.
- Autenticación y control básico de acceso: el usuario consulta recursos y sus propios préstamos; el administrador u operador gestiona recursos y registra préstamos y devoluciones.

Las categorías de estudiante, docente y personal administrativo, así como límites de préstamos, plazos diferenciados y sanciones, quedan para una definición posterior; no forman parte de las reglas iniciales.

## Tecnologías seleccionadas

| Área | Tecnología |
| --- | --- |
| Frontend | Vue.js con TypeScript |
| Backend | Node.js con TypeScript |
| Base de datos | PostgreSQL |
| Comunicación | API entre frontend y backend |
| Modelado y documentación | DDD, UML, Structurizr y PlantUML |

Estas tecnologías están seleccionadas. Solo Structurizr cuenta con un modelo inicial y documentación de ejecución; las herramientas de la aplicación y los diagramas UML aún están pendientes.

## Organización actual

```text
.
├── backend/
├── frontend/
├── docs/
│   └── architecture/
│       ├── structurizr/
│       │   ├── README.md
│       │   └── workspace.dsl
│       └── uml/
├── .gitignore
└── README.md
```

`docs/architecture/structurizr/` contiene el primer modelo de arquitectura y sus instrucciones de uso. `backend/`, `frontend/` y `docs/architecture/uml/` siguen vacíos y solo existen localmente; Git no los versiona mientras no contengan archivos.

## Arquitectura planteada

El backend se organizará en módulos `users`, `inventory`, `loans` y `auth`, responsables de usuarios, recursos, préstamos y control de acceso. Esta división está propuesta, no implementada.

Dentro de cada módulo se separarán las responsabilidades que resulten necesarias:

- **Dominio:** entidades y reglas de negocio, independientes de frameworks y persistencia.
- **Aplicación:** casos de uso que coordinan las operaciones del dominio.
- **Infraestructura:** acceso a PostgreSQL y adaptadores técnicos.
- **Presentación:** controladores y puntos de entrada de la API.

Vue.js presentará la información y enviará solicitudes a la API. Los casos de uso aplicarán las reglas del dominio y coordinarán la persistencia mediante contratos implementados en infraestructura. El dominio no dependerá directamente de PostgreSQL ni de los controladores HTTP.

Se tomará Clean Architecture como referencia, con separación de responsabilidades proporcional al proyecto, sin introducir capas, patrones o dependencias que aún no sean necesarios.

## Dominio y enfoque DDD

El modelo inicial distingue **Usuario**, **Recurso** y **Préstamo**. El préstamo es el concepto central: vincula temporalmente a un usuario con un recurso y registra sus fechas y estado.

DDD orientará el vocabulario y la distribución de responsabilidades en las áreas de Usuarios, Inventario y Préstamos, sin asumir todavía límites de agregados ni aplicar todos sus patrones.

Reglas iniciales:

- Cada préstamo debe asociarse a un usuario y un recurso registrados.
- Solo puede prestarse un recurso disponible.
- Un recurso no puede participar en más de un préstamo activo, incluso ante solicitudes concurrentes.
- Al registrar el préstamo, el recurso pasa a prestado.
- Al registrar la devolución, el préstamo finaliza y el recurso vuelve a estar disponible; el historial se conserva.

## Objetivos y definiciones pendientes

El informe plantea respuestas de aproximadamente 2 segundos como máximo en condiciones normales, al menos 50 usuarios simultáneos y capacidad inicial para 300 usuarios registrados. Son objetivos **no verificados**; falta concretar las condiciones y pruebas de aceptación.

Antes de implementar se deben definir el modelo de datos y los identificadores de recursos, los roles y permisos, el mecanismo de autenticación, los contratos de la API, las fechas y estados del préstamo y la estrategia transaccional para evitar préstamos activos duplicados. También quedan pendientes las herramientas de ejecución, persistencia, migraciones y pruebas.
