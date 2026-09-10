workspace "Préstamos universitarios" "Modelo de dominio propuesto; no representa una implementación ni un despliegue." {
    model {
        properties {
            "structurizr.groupSeparator" "/"
        }
        users = element "Usuarios (users)" "Módulo propuesto" "Registra y consulta usuarios. Concepto: Usuario."
        inventory = element "Inventario (inventory)" "Módulo propuesto" "Registra recursos y unidades físicas; consulta ejemplares disponibles."
        loans = element "Préstamos (loans)" "Módulo propuesto" "Registra préstamos y devoluciones, valida disponibilidad y conserva el historial." {
            tags "Central"
        }
        auth = element "Autenticación (auth)" "Módulo propuesto" "Autentica usuarios y controla el acceso según su rol."
        loans -> users "Cada préstamo identifica a un usuario registrado"
        loans -> inventory "Presta un ejemplar físico; nunca dos préstamos activos de la misma unidad"

        bcUsers = element "Usuarios" "Bounded context · soporte" "Registro y consulta de personas; proporciona la identidad de usuario." {
            tags "Soporte"
        }
        bcInventory = element "Inventario" "Bounded context · soporte" "Catálogo de recursos, identificación de ejemplares y disponibilidad por unidad física." {
            tags "Soporte"
        }
        bcLoans = element "Préstamos" "Bounded context · central" "Entrega, devolución e historial. Coordina la exclusividad del préstamo por ejemplar." {
            tags "Central"
        }
        bcAuth = element "Autenticación" "Bounded context · genérico de apoyo" "Identidad de acceso y rol USUARIO u OPERADOR; protege los casos de uso." {
            tags "Generico"
        }
        bcLoans -> bcUsers "Requiere verificar el usuario registrado mediante usuarioId"
        bcLoans -> bcInventory "Requiere seleccionar un ejemplar libre por recursoId y ocupar/liberar su disponibilidad por ejemplarId"
        bcAuth -> bcUsers "Vincula la cuenta de acceso a una persona mediante usuarioId"

        internalUsers = element "Usuarios · módulo users" "Bounded context · soporte" "[AR] Usuario: usuarioId, nombre." {
            tags "Soporte"
        }
        internalInventory = element "Inventario · módulo inventory" "Bounded context · soporte" "[AR] Recurso: recursoId, nombre, tipo | [AR] Ejemplar: ejemplarId, recursoId, estado. Recurso 1 → 0..* Ejemplares." {
            tags "Soporte"
        }
        internalLoans = element "Préstamos · módulo loans" "Bounded context · central" "[AR] Préstamo: prestamoId, usuarioId, ejemplarId, fechaPrestamo, fechaDevolucion opcional; estado derivado." {
            tags "Central"
        }
        internalAuth = element "Autenticación · módulo auth" "Bounded context · genérico de apoyo" "[AR] CuentaAcceso: usuarioId, rol USUARIO/OPERADOR. Sin definir credenciales ni proveedor." {
            tags "Generico"
        }
        internalLoans -> internalUsers "Préstamo.usuarioId → Usuario.usuarioId; un usuario por préstamo"
        internalLoans -> internalInventory "Préstamo.ejemplarId → Ejemplar.ejemplarId; máximo un préstamo activo por unidad"
        internalAuth -> internalUsers "CuentaAcceso.usuarioId → Usuario.usuarioId; relación 1:1 conceptual"
    }
    views {
        custom "DominioInicial" {
            title "Préstamos universitarios — organización inicial propuesta"
            description "Vista general de módulos; disponibilidad y préstamo por ejemplar físico."
            include users inventory loans auth
            autoLayout lr
        }
        custom "MapaContextos" {
            title "Mapa de contextos DDD — propuesta inicial"
            description "Flechas consumidor → proveedor de información o capacidad de dominio. Clasificación de subdominios propuesta; no son servicios desplegados."
            include bcUsers bcInventory bcLoans bcAuth
            autoLayout lr 400 250
        }
        custom "DominioInterno" {
            title "Dominio interno — módulos y agregados propuestos"
            description "Cada caja delimita un bounded context y enumera su módulo y raíces de agregado. Las referencias entre contextos usan identificadores."
            include internalUsers internalInventory internalLoans internalAuth
            autoLayout lr 400 300
        }
        styles {
            element "Element" {
                shape RoundedBox
                background #334155
                color #ffffff
            }
            element "Central" {
                background #075985
            }
            element "Soporte" {
                background #166534
            }
            element "Generico" {
                background #6b21a8
            }
            element "Group" {
                color #334155
                stroke #64748b
            }
            relationship "Relationship" {
                color #475569
                fontSize 22
            }
        }
    }
}
