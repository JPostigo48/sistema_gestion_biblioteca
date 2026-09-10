# Modelo de dominio en Structurizr

`workspace.dsl` contiene tres vistas propuestas, basadas en el informe de análisis, el [README del proyecto](../../../README.md) y la distinción entre recurso de catálogo y unidad física aclarada durante el modelado. No representan funcionalidades implementadas ni servicios desplegados.

## Vistas

| Vista | Contenido |
| --- | --- |
| `DominioInicial` | Vista general de los módulos `users`, `inventory`, `loans` y `auth`. |
| `MapaContextos` | Contextos delimitados, responsabilidades y dependencias de dominio. |
| `DominioInterno` | Límites de contexto y módulo, agregados, raíces y referencias por identificador. |

Se usan elementos personalizados, no contenedores C4. En la vista interna, cada caja delimita un bounded context y enumera su módulo y sus agregados, cada uno formado inicialmente por una única entidad raíz. Structurizr no anida elementos personalizados; convertir los contextos en contenedores C4 solo para dibujar cajas implicaría una arquitectura inexistente. Los atributos completos y las multiplicidades se detallan en el modelo UML.

## Mapa de contextos

La clasificación es una propuesta inicial de subdominios asociada a estos contextos; no implica que un contexto delimitado sea un subdominio o un microservicio.

- **Préstamos — central (azul):** registra entregas y devoluciones, valida las condiciones del préstamo y conserva el historial.
- **Usuarios — soporte (verde):** registra y consulta personas y proporciona su identidad.
- **Inventario — soporte (verde):** registra y clasifica recursos, identifica unidades físicas y mantiene su disponibilidad.
- **Autenticación — genérico de apoyo (violeta):** autentica a los usuarios y proporciona su rol de acceso.

Las flechas del mapa van del consumidor al proveedor de una capacidad o información:

- Préstamos necesita Usuarios para comprobar la existencia de `usuarioId`.
- Préstamos necesita Inventario para buscar un ejemplar disponible de `recursoId` y coordinar el cambio de disponibilidad de `ejemplarId` al prestar o devolver.
- Autenticación necesita Usuarios para vincular cada cuenta a la persona correspondiente mediante `usuarioId`.

El control de acceso se aplicará en presentación/aplicación de los módulos consumidores, no dentro de sus entidades de dominio. Por eso no se dibujan dependencias de esas entidades hacia Autenticación. Las relaciones no fijan protocolos, llamadas HTTP, eventos ni un mecanismo de integración ya implementado.

## Agregados y referencias

| Contexto / módulo | Agregado y raíz | Identidad y referencias |
| --- | --- | --- |
| Usuarios / `users` | Usuario | `usuarioId` |
| Inventario / `inventory` | Recurso | `recursoId` |
| Inventario / `inventory` | Ejemplar | `ejemplarId`; referencia a Recurso por `recursoId` |
| Préstamos / `loans` | Préstamo | `prestamoId`; referencias `usuarioId` y `ejemplarId` |
| Autenticación / `auth` | CuentaAcceso | `usuarioId` identifica la cuenta y referencia a Usuario |

**Recurso** describe una entrada del catálogo: un libro, equipo u otro recurso. Puede tener cero o más **Ejemplares**, cada uno de los cuales representa una unidad física identificable. Son agregados distintos porque cada unidad puede prestarse independientemente; no se necesita cargar ni modificar todos los ejemplares para prestar uno. No se modela una jerarquía de clases por tipo de recurso.

La disponibilidad pertenece a **Ejemplar** (`DISPONIBLE` o `PRESTADO`), no a Recurso. Un recurso puede prestarse cuando existe al menos un ejemplar disponible. Cada préstamo corresponde a una sola unidad; un mismo recurso puede tener varios ejemplares prestados simultáneamente. El informe no establece un límite de préstamos por usuario.

**Préstamo** conserva las fechas de préstamo y devolución. Sin fecha de devolución está `ACTIVO`; con ella está `FINALIZADO`. La devolución no puede ser anterior al préstamo. Su estado es derivado, no una segunda fuente de verdad.

**CuentaAcceso** representa únicamente la vinculación de acceso con Usuario y su rol (`USUARIO` u `OPERADOR`, que agrupa al administrador u operador del informe). Se propone una relación conceptual 1:1 con Usuario. No se seleccionan credenciales, proveedor de identidad ni categorías académicas; estas últimas no deben confundirse con los roles de acceso.

Las asociaciones entre agregados se expresan mediante identificadores, no mediante propiedad o carga de objetos de otros contextos. Los identificadores y fechas no se convierten en clases Value Object sin comportamiento que lo justifique.

## Consistencia del préstamo

Registrar el préstamo y ocupar el ejemplar deben constituir una operación consistente: ante solicitudes concurrentes, solo una puede adquirir la misma unidad. Finalizar el préstamo y liberar su ejemplar requieren la misma garantía. La coordinación corresponde a aplicación, utilizando los contratos de Inventario y Préstamos, sin trasladar reglas de negocio a controladores.

Separar agregados no elimina esta invariante entre ellos. La implementación deberá concretar la transacción y la protección contra concurrencia en PostgreSQL; una consulta de disponibilidad seguida de escrituras independientes no basta. No se introducen consistencia eventual, sagas ni servicios distribuidos para esta primera versión.

## Ejecución local

Requisito: Docker instalado y en ejecución, con soporte para contenedores Linux. Desde la raíz del repositorio, en PowerShell:

```powershell
$workspace = (Resolve-Path .\docs\architecture\structurizr).Path
docker run -it --rm -p 127.0.0.1:8080:8080 --mount "type=bind,source=$workspace,target=/usr/local/structurizr" structurizr/structurizr local
```

Abrir <http://localhost:8080> y seleccionar la vista deseada. Para detener el proceso, usar `Ctrl+C`. El comando descarga la imagen si no está disponible; no compila el proyecto ni requiere ejecutar frontend, backend o PostgreSQL.

Editar `workspace.dsl` como fuente del modelo y recargar el navegador para ver los cambios. El JSON y los archivos de ejecución local no sustituyen al DSL como fuente versionada.

Referencias: [ejecución local](https://docs.structurizr.com/local/quickstart) y [vistas personalizadas](https://docs.structurizr.com/dsl/cookbook/custom-view/).
