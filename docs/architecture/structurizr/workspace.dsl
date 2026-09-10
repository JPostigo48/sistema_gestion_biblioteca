workspace "Préstamos universitarios" "Organización inicial propuesta del dominio; no representa una implementación." {
    model {
        users = element "Usuarios (users)" "Módulo propuesto" "Registra y consulta usuarios e identifica su tipo. Concepto: Usuario."
        inventory = element "Inventario (inventory)" "Módulo propuesto" "Registra, consulta y clasifica recursos; mantiene su disponibilidad. Concepto: Recurso."
        loans = element "Préstamos (loans)" "Módulo propuesto" "Registra préstamos y devoluciones, valida disponibilidad y conserva el historial. Concepto central: Préstamo." {
            tags "Central"
        }
        auth = element "Autenticación (auth)" "Módulo propuesto" "Autenticación y control básico de acceso según el tipo de usuario."

        loans -> users "Cada préstamo se asocia a un usuario registrado"
        loans -> inventory "Cada préstamo se asocia a un recurso; solo uno activo por recurso"
    }

    views {
        custom "DominioInicial" {
            title "Préstamos universitarios — organización inicial propuesta"
            description "Módulos propuestos y relaciones conceptuales del dominio."
            include *
            autoLayout lr
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
            relationship "Relationship" {
                color #475569
            }
        }
    }
}
