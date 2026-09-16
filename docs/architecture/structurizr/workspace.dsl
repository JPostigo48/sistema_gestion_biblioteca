workspace "Préstamos universitarios" "Modelo estratégico DDD del sistema de gestión de préstamos universitarios; no representa una implementación ni un despliegue." {
    model {
        solicitante = person "Usuario solicitante" "Estudiante, docente o personal administrativo que intenta obtener un ejemplar." {
            tags "Actor"
        }

        prestamos = element "Préstamos (loans)" "Bounded Context · central" "Registra préstamos y devoluciones; coordina las condiciones para ocupar un ejemplar." {
            tags "BoundedContext,Central"
        }

        inventario = element "Inventario (inventory)" "Bounded Context · soporte" "Gestiona recursos, ejemplares físicos y disponibilidad." {
            tags "BoundedContext,Soporte"
        }

        usuarios = element "Usuarios (users)" "Bounded Context · soporte" "Gestiona solicitudes, vinculación institucional y estado del usuario." {
            tags "BoundedContext,Soporte"
        }

        confianza = element "Confianza" "Bounded Context · soporte" "Evalúa porcentaje, nivel, sanciones y restricciones. El estado histórico se conserva asociado al usuario." {
            tags "BoundedContext,Soporte"
        }

        reglas = element "Reglas y Términos" "Bounded Context · soporte" "Administra reglas vigentes, versiones, incumplimientos y términos aceptados." {
            tags "BoundedContext,Soporte"
        }

        autenticacion = element "Autenticación (auth)" "Bounded Context · genérico de apoyo" "Proporciona identidad autenticada, rol y control de acceso." {
            tags "BoundedContext,Generico"
        }

        // Elementos internos: Usuarios
        aggUsuario = element "Agregado Usuario" "Aggregate" "Límite de consistencia de la identidad institucional y su estado de confianza." {
            tags "Aggregate"
        }
        rootUsuario = element "Usuario" "Aggregate Root" "Raíz del agregado; identifica usuarioId, tipo de usuario, vinculación vigente y habilitación para préstamos." {
            tags "AggregateRoot"
        }
        confianzaUsuario = element "Confianza del usuario" "Concepto interno" "Porcentaje 0..100 y nivel derivado. Los umbrales y valor inicial siguen pendientes." {
            tags "Concepto"
        }
        sancionesUsuario = element "Sanciones e historial" "Entidad interna" "Sanciones activas o finalizadas. Cada registro conserva el cambio de confianza aplicado." {
            tags "Concepto"
        }
        aggSolicitudRegistro = element "Agregado Solicitud de Registro" "Aggregate" "Gestiona la solicitud antes de habilitar una cuenta." {
            tags "Aggregate"
        }
        rootSolicitudRegistro = element "Solicitud de registro" "Aggregate Root" "Solicitud pendiente, aprobada o rechazada." {
            tags "AggregateRoot"
        }
        evidenciasVinculacion = element "Evidencias de vinculación" "Value Object" "Información necesaria para verificar la vinculación vigente con la EPCC." {
            tags "Concepto"
        }

        // Elementos internos: Inventario
        aggCategoria = element "Agregado Categoría de Recurso" "Aggregate" "Define la categoría y el tiempo máximo de préstamo asociado." {
            tags "Aggregate"
        }
        rootCategoria = element "Categoría de recurso" "Aggregate Root" "Clasificación usada por los recursos." {
            tags "AggregateRoot"
        }
        aggRecurso = element "Agregado Recurso" "Aggregate" "Entrada del catálogo; su disponibilidad se deriva de sus ejemplares." {
            tags "Aggregate"
        }
        rootRecurso = element "Recurso" "Aggregate Root" "Libro, equipo u otro recurso académico registrado." {
            tags "AggregateRoot"
        }
        invRecursoDisponible = element "Invariante: recurso disponible" "Regla de dominio" "Un recurso está disponible si existe al menos un ejemplar disponible." {
            tags "Invariante"
        }
        aggEjemplar = element "Agregado Ejemplar" "Aggregate" "Unidad física prestable de un recurso." {
            tags "Aggregate"
        }
        rootEjemplar = element "Ejemplar" "Aggregate Root" "Unidad física identificable mediante ejemplarId." {
            tags "AggregateRoot"
        }
        estadoEjemplar = element "Estado del ejemplar" "Concepto interno" "Disponible, prestado o no disponible." {
            tags "Concepto"
        }
        observacionesEjemplar = element "Observaciones" "Entidad interna" "Registra incidencias o notas sobre el estado del ejemplar." {
            tags "Concepto"
        }

        // Elementos internos: Préstamos
        aggPrestamo = element "Agregado Préstamo" "Aggregate" "Límite de consistencia del préstamo y su devolución." {
            tags "Aggregate,Central"
        }
        rootPrestamo = element "Préstamo" "Aggregate Root" "Raíz del agregado; referencia usuarioId y ejemplarId." {
            tags "AggregateRoot,Central"
        }
        intervaloPrestamo = element "Intervalo fechaInicio-fechaFin" "Concepto interno" "Rango temporal en el que el ejemplar queda ocupado." {
            tags "Concepto"
        }
        estadoPrestamo = element "Estado del préstamo" "Concepto interno" "Planificado, activo o finalizado." {
            tags "Concepto"
        }
        devolucionPrestamo = element "Devolución" "Value Object" "Finaliza el préstamo y puede registrar observación de devolución." {
            tags "Concepto"
        }
        invIntervaloEjemplar = element "Invariante: sin superposición" "Regla de dominio" "Un ejemplar no puede tener préstamos activos o planificados con intervalos superpuestos." {
            tags "Invariante"
        }
        invUsuarioHabilitado = element "Invariante: usuario habilitado" "Regla de dominio" "Antes de prestar se verifica vinculación vigente, confianza, sanciones y restricciones." {
            tags "Invariante"
        }

        // Elementos internos: Reglas y Términos
        aggReglaUso = element "Agregado Regla de Uso" "Aggregate" "Identidad estable de una regla administrable." {
            tags "Aggregate"
        }
        rootReglaUso = element "Regla de uso" "Aggregate Root" "Regla vigente o inactiva con consecuencia asociada." {
            tags "AggregateRoot"
        }
        versionRegla = element "Versionado de reglas" "Aggregate" "Versiones históricas de reglas; conservan penalización y contenido aplicado." {
            tags "Aggregate"
        }
        incumplimientos = element "Incumplimientos" "Aggregate" "Registro histórico de la regla vulnerada y penalización realmente aplicada." {
            tags "Aggregate"
        }
        versionesTerminos = element "Versiones de términos" "Aggregate" "Versiones aceptables de términos y condiciones." {
            tags "Aggregate"
        }
        aceptacionesTerminos = element "Aceptaciones de términos" "Aggregate" "Registra qué versión aceptó cada usuario." {
            tags "Aggregate"
        }
        invHistorialReglas = element "Invariante: historial estable" "Regla de dominio" "Cambios posteriores de una regla no alteran incumplimientos ni sanciones históricas." {
            tags "Invariante"
        }

        // Elementos internos: Autenticación
        aggCuentaAcceso = element "Agregado Cuenta de Acceso" "Aggregate" "Vincula una cuenta con el usuario institucional." {
            tags "Aggregate"
        }
        rootCuentaAcceso = element "Cuenta de acceso" "Aggregate Root" "Identidad de acceso asociada a usuarioId." {
            tags "AggregateRoot"
        }
        rolesAcceso = element "Roles de acceso" "Concepto interno" "Usuario, operador o administrador. No equivale al tipo institucional." {
            tags "Concepto"
        }

        // Elementos internos: Confianza
        modeloConfianza = element "Evaluación de confianza" "Política de dominio" "Evalúa porcentaje, nivel, sanciones activas y restricciones vigentes por usuarioId." {
            tags "Aggregate"
        }
        nivelConfianza = element "Nivel de confianza" "Concepto de dominio" "Cuatro niveles derivados del porcentaje. Límites pendientes." {
            tags "Concepto"
        }
        restriccionesConfianza = element "Restricciones por confianza" "Política de dominio" "Condiciones de préstamo derivadas del nivel o sanciones vigentes; detalle pendiente." {
            tags "Concepto"
        }
        cambioPorIncumplimiento = element "Cambio por incumplimiento" "Política de dominio" "Aplica el descuento configurado en la regla incumplida y conserva el cambio histórico." {
            tags "Concepto"
        }

        // Mapa de contextos
        prestamos -> usuarios "verifica usuario habilitado"
        prestamos -> inventario "consulta y ocupa ejemplares"
        prestamos -> confianza "considera restricciones"
        prestamos -> autenticacion "requiere identidad y permisos"
        reglas -> confianza "incumplimientos reducen confianza"
        confianza -> usuarios "asocia confianza al usuario"
        autenticacion -> usuarios "vincula cuenta con usuario"

        // Relación usuario-sistema para vista dinámica
        solicitante -> autenticacion "inicia solicitud de préstamo"
        autenticacion -> solicitante "rechazo: no autenticado"
        usuarios -> solicitante "rechazo: usuario no habilitado"
        confianza -> solicitante "rechazo: sanción o restricción"
        prestamos -> solicitante "rechazo: intervalo superpuesto"
        inventario -> solicitante "rechazo: ejemplar no disponible"

        // Relaciones internas: Usuarios
        usuarios -> aggUsuario "contiene"
        usuarios -> aggSolicitudRegistro "contiene"
        aggUsuario -> rootUsuario "raíz"
        aggUsuario -> confianzaUsuario "incluye"
        aggUsuario -> sancionesUsuario "incluye"
        aggSolicitudRegistro -> rootSolicitudRegistro "raíz"
        aggSolicitudRegistro -> evidenciasVinculacion "incluye"
        rootSolicitudRegistro -> rootUsuario "origina usuario aprobado"

        // Relaciones internas: Inventario
        inventario -> aggCategoria "contiene"
        inventario -> aggRecurso "contiene"
        inventario -> aggEjemplar "contiene"
        aggCategoria -> rootCategoria "raíz"
        aggRecurso -> rootRecurso "raíz"
        aggEjemplar -> rootEjemplar "raíz"
        aggEjemplar -> estadoEjemplar "incluye"
        aggEjemplar -> observacionesEjemplar "incluye"
        rootRecurso -> rootCategoria "categoriaId"
        rootEjemplar -> rootRecurso "recursoId"
        rootRecurso -> invRecursoDisponible "cumple"

        // Relaciones internas: Préstamos
        prestamos -> aggPrestamo "contiene"
        aggPrestamo -> rootPrestamo "raíz"
        aggPrestamo -> intervaloPrestamo "incluye"
        aggPrestamo -> estadoPrestamo "incluye"
        aggPrestamo -> devolucionPrestamo "incluye"
        rootPrestamo -> invIntervaloEjemplar "cumple"
        rootPrestamo -> invUsuarioHabilitado "cumple"

        // Relaciones internas: Reglas y Términos
        reglas -> aggReglaUso "contiene"
        reglas -> versionRegla "contiene"
        reglas -> incumplimientos "contiene"
        reglas -> versionesTerminos "contiene"
        reglas -> aceptacionesTerminos "contiene"
        aggReglaUso -> rootReglaUso "raíz"
        rootReglaUso -> versionRegla "versionReglaId"
        incumplimientos -> versionRegla "versionReglaId"
        incumplimientos -> invHistorialReglas "cumple"
        versionRegla -> invHistorialReglas "cumple"
        aceptacionesTerminos -> versionesTerminos "versionTerminosId"

        // Relaciones internas: Autenticación
        autenticacion -> aggCuentaAcceso "contiene"
        aggCuentaAcceso -> rootCuentaAcceso "raíz"
        aggCuentaAcceso -> rolesAcceso "incluye"
        rootCuentaAcceso -> rootUsuario "usuarioId"

        // Relaciones internas: Confianza, sin duplicar entidades de Usuarios
        confianza -> modeloConfianza "contiene"
        modeloConfianza -> confianzaUsuario "usuarioId"
        modeloConfianza -> nivelConfianza "deriva nivel"
        modeloConfianza -> sancionesUsuario "consulta sanciones"
        modeloConfianza -> restriccionesConfianza "aplica restricciones"
        cambioPorIncumplimiento -> sancionesUsuario "registra sanción"
        cambioPorIncumplimiento -> confianzaUsuario "actualiza porcentaje"

        // Referencias entre agregados y contextos
        rootPrestamo -> rootUsuario "usuarioId"
        rootPrestamo -> rootEjemplar "ejemplarId"
        rootPrestamo -> modeloConfianza "verifica restricciones"
        rootPrestamo -> intervaloPrestamo "verifica intervalo"
        sancionesUsuario -> incumplimientos "incumplimientoId"
        sancionesUsuario -> versionRegla "versionReglaId"
        incumplimientos -> rootUsuario "usuarioId"
        cambioPorIncumplimiento -> incumplimientos "penalización aplicada"
        restriccionesConfianza -> versionRegla "reglas vigentes"

        // Relaciones del flujo dinámico
        autenticacion -> usuarios "identifica usuario"
        usuarios -> confianza "solicita habilitación"
        confianza -> reglas "consulta reglas vigentes"
        reglas -> confianza "devuelve restricciones"
        confianza -> prestamos "autoriza evaluación del préstamo"
        prestamos -> inventario "solicita ejemplar disponible"
        inventario -> prestamos "informa disponibilidad"
        prestamos -> prestamos "valida intervalo del ejemplar"
        prestamos -> inventario "ocupa ejemplar"
        prestamos -> inventario "libera ejemplar si procede"
        prestamos -> solicitante "confirma préstamo o devolución"
    }

    views {
        custom "MapaContextosDDD" {
            title "Mapa de contextos DDD — préstamos universitarios"
            description "División estratégica actual del dominio. Flechas consumidor → proveedor, salvo Reglas y Términos → Confianza, que representa el efecto del incumplimiento sobre la confianza. No muestra entidades ni clases internas."
            include prestamos inventario usuarios confianza reglas autenticacion
            autoLayout lr 360 240
        }

        custom "VistaInternaDDD" {
            title "Vista interna DDD — módulos y agregados"
            description "Organización conceptual por bounded context. Las relaciones entre agregados o contextos representan referencias por identificador y no carga directa de objetos. No muestra atributos de clase."
            include usuarios aggUsuario rootUsuario confianzaUsuario sancionesUsuario aggSolicitudRegistro rootSolicitudRegistro evidenciasVinculacion
            include inventario aggCategoria rootCategoria aggRecurso rootRecurso invRecursoDisponible aggEjemplar rootEjemplar estadoEjemplar observacionesEjemplar
            include prestamos aggPrestamo rootPrestamo intervaloPrestamo estadoPrestamo devolucionPrestamo invIntervaloEjemplar invUsuarioHabilitado
            include reglas aggReglaUso rootReglaUso versionRegla incumplimientos versionesTerminos aceptacionesTerminos invHistorialReglas
            include autenticacion aggCuentaAcceso rootCuentaAcceso rolesAcceso
            include confianza modeloConfianza nivelConfianza restriccionesConfianza cambioPorIncumplimiento
            autoLayout lr 420 260
        }

        dynamic * "CicloCompletoPrestamo" {
            title "Vista dinámica — ciclo completo de un préstamo"
            description "Colaboración conceptual entre bounded contexts para solicitar, registrar y devolver un préstamo. Los rechazos se muestran como caminos alternos; no representan APIs ni tecnología de transporte."
            solicitante -> autenticacion "inicia solicitud de préstamo"
            autenticacion -> solicitante "rechaza si no está autenticado"
            autenticacion -> usuarios "valida identidad y permisos"
            usuarios -> solicitante "rechaza si no está habilitado"
            usuarios -> confianza "consulta confianza, sanciones y restricciones"
            confianza -> reglas "consulta reglas y términos vigentes"
            reglas -> confianza "informa restricciones aplicables"
            confianza -> solicitante "rechaza por sanción activa o restricción de confianza"
            confianza -> prestamos "autoriza continuar con la evaluación"
            prestamos -> inventario "consulta recurso y ejemplares"
            inventario -> prestamos "identifica recurso, estado y disponibilidad"
            inventario -> solicitante "rechaza si no hay ejemplar disponible"
            prestamos -> prestamos "verifica superposición de [fechaInicio, fechaFin]"
            prestamos -> solicitante "rechaza si el intervalo se superpone"
            prestamos -> inventario "ocupa el ejemplar para el intervalo"
            prestamos -> solicitante "registra préstamo"
            solicitante -> prestamos "registra devolución posterior"
            prestamos -> inventario "libera ejemplar si su condición lo permite"
            prestamos -> solicitante "finaliza préstamo"
            autoLayout lr 360 220
        }

        styles {
            element "Element" {
                shape RoundedBox
                background #334155
                color #ffffff
                fontSize 24
                width 400
                height 170
            }
            element "Actor" {
                shape Person
                background #0f172a
                color #ffffff
            }
            element "BoundedContext" {
                shape RoundedBox
                background #334155
                color #ffffff
                fontSize 28
                width 430
                height 180
                stroke #0f172a
                strokeWidth 3
            }
            element "Central" {
                background #075985
                stroke #082f49
                strokeWidth 5
            }
            element "Soporte" {
                background #166534
                stroke #14532d
            }
            element "Generico" {
                background #6b21a8
                stroke #581c87
            }
            element "Aggregate" {
                background #fef3c7
                color #422006
                stroke #ca8a04
                strokeWidth 3
                width 390
                height 155
            }
            element "AggregateRoot" {
                background #f97316
                color #ffffff
                stroke #9a3412
                strokeWidth 4
                width 360
                height 145
            }
            element "Concepto" {
                background #e2e8f0
                color #0f172a
                stroke #64748b
                width 360
                height 130
            }
            element "Invariante" {
                shape Hexagon
                background #fef9c3
                color #422006
                stroke #a16207
                strokeWidth 3
                width 420
                height 150
            }
            relationship "Relationship" {
                color #475569
                fontSize 20
                thickness 2
            }
        }
    }
}
