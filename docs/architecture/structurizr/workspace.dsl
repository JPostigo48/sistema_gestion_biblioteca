workspace "Préstamos universitarios" "Modelo estratégico DDD del sistema de gestión de préstamos universitarios; no representa una implementación ni un despliegue." {
    model {
        prestamos = element "Préstamos (loans)" "Bounded Context · central" "Registra préstamos y devoluciones; coordina las condiciones para ocupar un ejemplar." {
            tags "BoundedContext,Central"
        }

        inventario = element "Inventario (inventory)" "Bounded Context · soporte" "Gestiona recursos, ejemplares físicos y disponibilidad." {
            tags "BoundedContext,Soporte"
        }

        usuarios = element "Usuarios (users)" "Bounded Context · soporte" "Gestiona solicitudes, vinculación institucional y estado del usuario." {
            tags "BoundedContext,Soporte"
        }

        confianza = element "Confianza" "Responsabilidad de dominio · soporte" "Evalúa porcentaje, nivel, sanciones y restricciones. Su límite queda pendiente de consolidación con Usuarios." {
            tags "BoundedContext,Soporte,Pendiente"
        }

        reglas = element "Reglas y Términos" "Bounded Context · soporte" "Administra reglas vigentes, versiones, incumplimientos y términos aceptados." {
            tags "BoundedContext,Soporte"
        }

        autenticacion = element "Autenticación (auth)" "Bounded Context · genérico de apoyo" "Proporciona identidad autenticada, rol y control de acceso." {
            tags "BoundedContext,Generico"
        }

        // Elementos internos: Préstamos
        aggPrestamo = element "Agregado Préstamo" "Aggregate" "Límite de consistencia del préstamo y su devolución." {
            tags "Aggregate,Central"
        }
        rootPrestamo = element "Préstamo" "Aggregate Root" "Referencia usuarioId y ejemplarId. Controla el intervalo del préstamo." {
            tags "AggregateRoot,Central"
        }
        estadoPrestamo = element "EstadoPrestamo" "Enumeración" "PLANIFICADO, ACTIVO o FINALIZADO." {
            tags "Concepto"
        }
        devolucionPrestamo = element "Devolución" "Value Object" "Pertenece al agregado Préstamo y finaliza el préstamo." {
            tags "Concepto"
        }
        intervaloPrestamo = element "fechaInicio - fechaFin" "Concepto" "Intervalo temporal en el que el ejemplar queda ocupado." {
            tags "Concepto"
        }
        refUsuarioPrestamo = element "usuarioId (préstamo)" "Referencia externa" "Referencia a Usuario; no carga el agregado Usuarios." {
            tags "ExternalRef"
        }
        refEjemplarPrestamo = element "ejemplarId (préstamo)" "Referencia externa" "Referencia a Ejemplar; no carga el agregado Inventario." {
            tags "ExternalRef"
        }
        invIntervaloEjemplar = element "Invariante: sin superposición" "Regla de dominio" "Un ejemplar no puede tener intervalos activos o planificados superpuestos." {
            tags "Invariante"
        }

        // Elementos internos: Inventario
        aggCategoria = element "Agregado Categoría de Recurso" "Aggregate" "Clasifica recursos y define el tiempo máximo de préstamo." {
            tags "Aggregate"
        }
        rootCategoria = element "CategoriaRecurso" "Aggregate Root" "Categoría del recurso." {
            tags "AggregateRoot"
        }
        tiempoMaximoPrestamo = element "Tiempo máximo de préstamo" "Concepto" "Plazo máximo asociado a la categoría." {
            tags "Concepto"
        }
        aggRecurso = element "Agregado Recurso" "Aggregate" "Entrada del catálogo; agrupa la disponibilidad conceptual del recurso." {
            tags "Aggregate"
        }
        rootRecurso = element "Recurso" "Aggregate Root" "Libro, equipo u otro recurso académico registrado." {
            tags "AggregateRoot"
        }
        refCategoriaRecurso = element "categoriaId" "Referencia interna" "Referencia del recurso a su categoría." {
            tags "ExternalRef"
        }
        disponibilidadRecurso = element "Disponibilidad derivada" "Concepto" "Existe al menos un ejemplar disponible." {
            tags "Invariante"
        }
        aggEjemplar = element "Agregado Ejemplar" "Aggregate" "Unidad física prestable de un recurso." {
            tags "Aggregate"
        }
        rootEjemplar = element "Ejemplar" "Aggregate Root" "Unidad física identificable." {
            tags "AggregateRoot"
        }
        estadoEjemplar = element "EstadoEjemplar" "Enumeración" "DISPONIBLE, PRESTADO o NO_DISPONIBLE." {
            tags "Concepto"
        }
        observacionesEjemplar = element "ObservacionEjemplar" "Entidad interna" "Registra observaciones o incidencias del ejemplar." {
            tags "Concepto"
        }

        // Elementos internos: Usuarios
        aggSolicitudRegistro = element "Agregado Solicitud de Registro" "Aggregate" "Gestiona la solicitud antes de habilitar una cuenta." {
            tags "Aggregate"
        }
        rootSolicitudRegistro = element "SolicitudRegistro" "Aggregate Root" "Solicitud pendiente, aprobada o rechazada." {
            tags "AggregateRoot"
        }
        evidenciasVinculacion = element "EvidenciaVinculacion" "Value Object" "Información para verificar vinculación vigente con la EPCC." {
            tags "Concepto"
        }
        estadoSolicitud = element "EstadoSolicitud" "Enumeración" "PENDIENTE, APROBADA o RECHAZADA." {
            tags "Concepto"
        }
        tipoUsuario = element "TipoUsuario" "Enumeración" "ESTUDIANTE, DOCENTE o ADMINISTRATIVO." {
            tags "Concepto"
        }
        aggUsuario = element "Agregado Usuario" "Aggregate" "Identidad institucional, vinculación, confianza y sanciones." {
            tags "Aggregate"
        }
        rootUsuario = element "Usuario" "Aggregate Root" "Raíz del usuario institucional." {
            tags "AggregateRoot"
        }
        porcentajeConfianza = element "PorcentajeConfianza" "Value Object" "Valor entre 0 y 100 asociado al usuario." {
            tags "Concepto"
        }
        nivelConfianza = element "NivelConfianza" "Concepto derivado" "Nivel derivado del porcentaje. Umbrales pendientes." {
            tags "Concepto"
        }
        sancionesUsuario = element "Sanciones" "Entidad interna" "Historial de penalizaciones. Conserva confianzaAnterior y confianzaPosterior." {
            tags "Concepto"
        }
        estadoSancion = element "EstadoSancion" "Enumeración" "ACTIVA o FINALIZADA." {
            tags "Concepto"
        }

        // Elementos internos: Reglas y Términos
        rootReglaUso = element "ReglaUso" "Aggregate Root" "Identidad estable de una regla de uso." {
            tags "AggregateRoot"
        }
        versionRegla = element "VersionRegla" "Aggregate" "Versión histórica de una regla; conserva contenido y penalización." {
            tags "Aggregate"
        }
        versionVigente = element "versionVigenteId" "Referencia" "Identifica la versión actualmente vigente de una regla." {
            tags "ExternalRef"
        }
        estadoRegla = element "EstadoRegla" "Enumeración" "ACTIVA o INACTIVA." {
            tags "Concepto"
        }
        incumplimientos = element "Incumplimiento" "Aggregate" "Conserva la versión infringida y la penalización aplicada." {
            tags "Aggregate"
        }
        versionesTerminos = element "VersionTerminos" "Aggregate" "Versión concreta de términos y condiciones." {
            tags "Aggregate"
        }
        aceptacionesTerminos = element "AceptacionTerminos" "Aggregate" "Aceptación de una versión concreta por usuarioId." {
            tags "Aggregate"
        }
        invHistorialReglas = element "Invariante: historial estable" "Regla de dominio" "Cambios posteriores de reglas no alteran incumplimientos históricos." {
            tags "Invariante"
        }
        refUsuarioReglas = element "usuarioId (reglas)" "Referencia externa" "Referencia al usuario asociado al incumplimiento o aceptación." {
            tags "ExternalRef"
        }

        // Elementos internos: Autenticación
        rootCuentaAcceso = element "CuentaAcceso" "Aggregate Root" "Cuenta asociada a usuarioId." {
            tags "AggregateRoot"
        }
        rolesAcceso = element "RolAcceso" "Enumeración" "USUARIO, OPERADOR o ADMINISTRADOR." {
            tags "Concepto"
        }
        refUsuarioAuth = element "usuarioId (autenticación)" "Referencia externa" "Vincula la cuenta con Usuario." {
            tags "ExternalRef"
        }
        tipoUsuarioReferencia = element "TipoUsuario pertenece a Usuarios" "Aclaración" "Estudiante, docente o administrativo describe la vinculación institucional, no permisos." {
            tags "ExternalRef"
        }
        rolNoTipo = element "RolAcceso no es TipoUsuario" "Invariante conceptual" "Administrador es un rol de acceso; administrativo es un tipo institucional." {
            tags "Invariante"
        }

        // Elementos internos: Confianza
        evaluacionConfianza = element "Evaluación de confianza" "Política de dominio" "Evalúa el estado de confianza por usuarioId." {
            tags "Aggregate"
        }
        refUsuarioConfianza = element "Usuario (usuarioId)" "Referencia externa" "La confianza se asocia al usuario sin duplicar el agregado Usuario." {
            tags "ExternalRef"
        }
        porcentajeConfianzaCtx = element "Porcentaje de confianza" "Concepto" "Valor 0..100. Porcentaje inicial pendiente." {
            tags "Concepto"
        }
        nivelConfianzaCtx = element "Nivel de confianza" "Concepto derivado" "Cuatro niveles derivados; límites pendientes." {
            tags "Concepto"
        }
        sancionesActivas = element "Sanciones activas" "Concepto" "Penalizaciones vigentes que pueden impedir operaciones." {
            tags "Concepto"
        }
        restriccionesConfianza = element "Restricciones derivadas" "Política de dominio" "Condiciones aplicables por nivel o sanción; detalle pendiente." {
            tags "Concepto"
        }
        cambioPorIncumplimiento = element "Cambio por incumplimiento" "Política de dominio" "Aplica el descuento configurado y conserva el cambio histórico." {
            tags "Concepto"
        }
        refReglasConfianza = element "Reglas e incumplimientos" "Referencia externa" "Fuente de penalizaciones y restricciones vigentes." {
            tags "ExternalRef"
        }
        limiteConfianza = element "Límite pendiente" "Aclaración" "Confianza se separa en Structurizr para explicar responsabilidades; su consolidación con Usuarios sigue pendiente." {
            tags "Invariante,Pendiente"
        }

        // Relaciones entre contextos
        prestamos -> usuarios "verifica estado del usuario"
        prestamos -> inventario "consulta disponibilidad y ocupa ejemplares"
        prestamos -> confianza "consulta restricciones de confianza"
        prestamos -> autenticacion "requiere identidad y permisos"
        reglas -> confianza "incumplimientos afectan confianza"
        confianza -> usuarios "se asocia por usuarioId"
        autenticacion -> usuarios "vincula cuenta con usuario"
        usuarios -> confianza "solicita evaluación de habilitación"
        confianza -> reglas "consulta reglas vigentes"

        // Préstamos
        prestamos -> aggPrestamo "contiene"
        aggPrestamo -> rootPrestamo "raíz"
        rootPrestamo -> estadoPrestamo "estado"
        rootPrestamo -> intervaloPrestamo "usa"
        rootPrestamo -> refUsuarioPrestamo "usuarioId"
        rootPrestamo -> refEjemplarPrestamo "ejemplarId"
        rootPrestamo -> invIntervaloEjemplar "cumple"
        rootPrestamo -> devolucionPrestamo "contiene 0..1"

        // Inventario
        inventario -> aggCategoria "contiene"
        inventario -> aggRecurso "contiene"
        inventario -> aggEjemplar "contiene"
        aggCategoria -> rootCategoria "raíz"
        rootCategoria -> tiempoMaximoPrestamo "define"
        aggRecurso -> rootRecurso "raíz"
        rootRecurso -> refCategoriaRecurso "referencia"
        rootCategoria -> rootRecurso "1 a muchos"
        rootRecurso -> disponibilidadRecurso "deriva"
        aggEjemplar -> rootEjemplar "raíz"
        rootRecurso -> rootEjemplar "1 a muchos"
        rootEjemplar -> rootRecurso "pertenece a"
        rootEjemplar -> estadoEjemplar "estado"
        rootEjemplar -> observacionesEjemplar "observaciones"
        estadoEjemplar -> disponibilidadRecurso "al menos uno DISPONIBLE"

        // Usuarios
        usuarios -> aggSolicitudRegistro "contiene"
        usuarios -> aggUsuario "contiene"
        aggSolicitudRegistro -> rootSolicitudRegistro "raíz"
        rootSolicitudRegistro -> evidenciasVinculacion "incluye"
        rootSolicitudRegistro -> estadoSolicitud "estado"
        rootSolicitudRegistro -> tipoUsuario "tipoUsuario"
        rootSolicitudRegistro -> rootUsuario "aprobada origina"
        aggUsuario -> rootUsuario "raíz"
        rootUsuario -> tipoUsuario "tipoUsuario"
        rootUsuario -> porcentajeConfianza "posee"
        porcentajeConfianza -> nivelConfianza "deriva"
        rootUsuario -> sancionesUsuario "0..*"
        sancionesUsuario -> estadoSancion "estado"

        // Reglas y términos
        reglas -> rootReglaUso "contiene"
        reglas -> versionRegla "contiene"
        reglas -> incumplimientos "contiene"
        reglas -> versionesTerminos "contiene"
        reglas -> aceptacionesTerminos "contiene"
        rootReglaUso -> versionRegla "posee versiones"
        rootReglaUso -> versionVigente "versión vigente"
        versionRegla -> estadoRegla "estado"
        incumplimientos -> versionRegla "versionReglaId"
        incumplimientos -> invHistorialReglas "cumple"
        versionRegla -> invHistorialReglas "histórica"
        incumplimientos -> refUsuarioReglas "usuarioId"
        aceptacionesTerminos -> versionesTerminos "versionTerminosId"
        aceptacionesTerminos -> refUsuarioReglas "usuarioId"

        // Autenticación
        autenticacion -> rootCuentaAcceso "contiene"
        rootCuentaAcceso -> rolesAcceso "rol"
        rootCuentaAcceso -> refUsuarioAuth "usuarioId"
        rolesAcceso -> rolNoTipo "no equivale"
        tipoUsuarioReferencia -> rolNoTipo "contrasta"

        // Confianza
        confianza -> evaluacionConfianza "contiene"
        evaluacionConfianza -> refUsuarioConfianza "usuarioId"
        evaluacionConfianza -> porcentajeConfianzaCtx "lee"
        porcentajeConfianzaCtx -> nivelConfianzaCtx "deriva"
        evaluacionConfianza -> sancionesActivas "consulta"
        evaluacionConfianza -> restriccionesConfianza "aplica"
        cambioPorIncumplimiento -> porcentajeConfianzaCtx "actualiza"
        cambioPorIncumplimiento -> sancionesActivas "puede generar"
        cambioPorIncumplimiento -> refReglasConfianza "usa penalización"
        restriccionesConfianza -> refReglasConfianza "usa reglas vigentes"
        confianza -> limiteConfianza "aclaración"
    }

    views {
        custom "MapaContextosDDD" {
            title "Mapa general de contextos DDD — préstamos universitarios"
            description "Vista estratégica principal del dominio. Muestra solo bounded contexts y dependencias principales."
            include prestamos inventario usuarios confianza reglas autenticacion
            autoLayout lr 360 240
        }

        custom "InteraccionContextosDDD" {
            title "Interacción entre contextos — préstamos universitarios"
            description "Colaboración conceptual entre bounded contexts. No muestra agregados ni entidades internas."
            include prestamos inventario usuarios confianza reglas autenticacion
            autoLayout lr 360 260
        }

        custom "InternaPrestamos" {
            title "Préstamos — vista interna"
            description "Límite interno del contexto Préstamos: agregado, raíz, estado, intervalo, devolución y referencias externas por ID."
            include prestamos aggPrestamo rootPrestamo estadoPrestamo devolucionPrestamo intervaloPrestamo refUsuarioPrestamo refEjemplarPrestamo invIntervaloEjemplar
            autoLayout lr 320 220
        }

        custom "InternaInventario" {
            title "Inventario — vista interna"
            description "Categorías, recursos y ejemplares físicos. La disponibilidad del recurso se deriva de sus ejemplares."
            include inventario aggCategoria rootCategoria tiempoMaximoPrestamo aggRecurso rootRecurso refCategoriaRecurso disponibilidadRecurso aggEjemplar rootEjemplar estadoEjemplar observacionesEjemplar
            autoLayout lr 320 220
        }

        custom "InternaUsuarios" {
            title "Usuarios — vista interna"
            description "Solicitudes, evidencias, usuario institucional, confianza asociada y sanciones como historial de penalizaciones."
            include usuarios aggSolicitudRegistro rootSolicitudRegistro evidenciasVinculacion estadoSolicitud tipoUsuario aggUsuario rootUsuario porcentajeConfianza nivelConfianza sancionesUsuario estadoSancion
            autoLayout lr 320 220
        }

        custom "InternaReglasTerminos" {
            title "Reglas y Términos — vista interna"
            description "Reglas versionadas, incumplimientos históricos, términos y aceptaciones por versión concreta."
            include reglas rootReglaUso versionRegla versionVigente estadoRegla incumplimientos versionesTerminos aceptacionesTerminos invHistorialReglas refUsuarioReglas
            autoLayout lr 320 220
        }

        custom "InternaAutenticacion" {
            title "Autenticación — vista interna"
            description "Cuenta de acceso, rol y referencia a usuarioId. RolAcceso no equivale a TipoUsuario."
            include autenticacion rootCuentaAcceso rolesAcceso refUsuarioAuth tipoUsuarioReferencia rolNoTipo
            autoLayout lr 320 220
        }

        custom "InternaConfianza" {
            title "Confianza — vista interna"
            description "Responsabilidad conceptual de evaluación de confianza, restricciones y cambios por incumplimientos sin duplicar entidades de Usuarios."
            include confianza evaluacionConfianza refUsuarioConfianza porcentajeConfianzaCtx nivelConfianzaCtx sancionesActivas restriccionesConfianza cambioPorIncumplimiento refReglasConfianza limiteConfianza
            autoLayout lr 320 220
        }

        styles {
            element "Element" {
                shape RoundedBox
                background #334155
                color #ffffff
                fontSize 24
                width 360
                height 150
            }
            element "BoundedContext" {
                shape RoundedBox
                background #334155
                color #ffffff
                fontSize 28
                width 420
                height 170
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
                width 360
                height 145
            }
            element "AggregateRoot" {
                background #f97316
                color #ffffff
                stroke #9a3412
                strokeWidth 4
                width 340
                height 135
            }
            element "Concepto" {
                background #e2e8f0
                color #0f172a
                stroke #64748b
                width 340
                height 125
            }
            element "ExternalRef" {
                shape Box
                background #f8fafc
                color #334155
                stroke #94a3b8
                width 330
                height 120
            }
            element "Invariante" {
                shape Hexagon
                background #fef9c3
                color #422006
                stroke #a16207
                strokeWidth 3
                width 380
                height 140
            }
            element "Pendiente" {
                stroke #f59e0b
            }
            relationship "Relationship" {
                color #475569
                fontSize 20
                thickness 2
            }
        }
    }
}
