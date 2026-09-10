# Sistema de gestión de préstamos universitarios

Sistema en planificación para registrar y controlar préstamos de libros, equipos y otros recursos académicos de una institución universitaria. Busca centralizar la información de usuarios, recursos y préstamos para consultar ejemplares disponibles de cada recurso y conocer quién tiene prestada cada unidad física.

## Estado actual

El repositorio se encuentra en etapa de documentación inicial. Cuenta con tres [diagramas del dominio en Structurizr](docs/architecture/structurizr/README.md) y un [modelo de dominio UML en PlantUML](docs/architecture/uml/README.md), con instrucciones de ejecución local. **No hay funcionalidades implementadas**, configuración de ejecución de la aplicación ni esquema de base de datos.

## Alcance inicial planificado

- Gestión de usuarios y su tipo.
- Registro y consulta de recursos, sus ejemplares físicos y su disponibilidad.
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

Estas tecnologías están seleccionadas. Structurizr cuenta con vistas de organización, contextos y agregados; PlantUML contiene el modelo de clases conceptual. Las herramientas de la aplicación aún están pendientes.

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
│           ├── README.md
│           └── modelo-dominio.puml
├── .gitignore
└── README.md
```

`docs/architecture/structurizr/` contiene las tres vistas DDD y `docs/architecture/uml/` el modelo conceptual de clases, junto con sus instrucciones de uso. `backend/` y `frontend/` siguen vacíos y solo existen localmente; Git no los versiona mientras no contengan archivos.

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

El modelo distingue **Usuario**, **Recurso**, **Ejemplar** y **Préstamo**. Recurso describe una entrada del catálogo y Ejemplar una unidad física de ese recurso. El préstamo es el concepto central: vincula temporalmente a un usuario con un ejemplar y registra sus fechas; su estado se deriva de la existencia de fecha de devolución.

Los contextos delimitados propuestos son **Préstamos** (central), **Usuarios** e **Inventario** (soporte) y **Autenticación** (genérico de apoyo). Esta clasificación orienta las responsabilidades; no define microservicios. Los módulos se corresponden inicialmente con estos contextos.

Los agregados iniciales, cada uno con una única entidad raíz, son Usuario, Recurso, Ejemplar, Préstamo y CuentaAcceso. Recurso y Ejemplar se separan para gestionar cada unidad de forma independiente. Las referencias entre agregados usan identificadores. CuentaAcceso vincula al usuario con su rol, sin seleccionar aún credenciales ni proveedor de autenticación.

Reglas iniciales:

- Cada préstamo identifica a un usuario registrado y a un ejemplar de un recurso registrado.
- Un recurso puede prestarse si tiene al menos un ejemplar disponible; cada préstamo corresponde a una unidad física.
- Un ejemplar no puede participar en más de un préstamo activo, incluso ante solicitudes concurrentes. Sí pueden prestarse otros ejemplares del mismo recurso.
- Registrar un préstamo y pasar su ejemplar a prestado deben ser una operación consistente.
- Registrar la devolución finaliza el préstamo y vuelve a dejar disponible su ejemplar; el historial se conserva.
- La fecha de devolución no puede ser anterior al préstamo; sin devolución el préstamo está activo.

## Objetivos y definiciones pendientes

El informe plantea respuestas de aproximadamente 2 segundos como máximo en condiciones normales, al menos 50 usuarios simultáneos y capacidad inicial para 300 usuarios registrados. Son objetivos **no verificados**; falta concretar las condiciones y pruebas de aceptación.

Antes de implementar se deben definir el modelo de datos y el formato de los identificadores, el detalle de permisos por rol, el mecanismo de autenticación, los contratos de la API, el tratamiento de fechas y la estrategia transaccional para evitar préstamos activos duplicados. También quedan pendientes las herramientas de ejecución, persistencia, migraciones y pruebas.
