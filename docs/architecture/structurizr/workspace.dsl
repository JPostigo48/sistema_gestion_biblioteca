workspace "Préstamos universitarios" "Mapa de contextos DDD del sistema de gestión de préstamos universitarios; no representa una implementación ni un despliegue." {
    model {
        prestamos = element "Préstamos (loans)" "Bounded Context · central" "Registra préstamos y devoluciones; coordina las condiciones para ocupar un ejemplar." {
            tags "Central"
        }

        inventario = element "Inventario (inventory)" "Bounded Context · soporte" "Gestiona recursos, ejemplares físicos y disponibilidad." {
            tags "Soporte"
        }

        usuarios = element "Usuarios (users)" "Bounded Context · soporte" "Gestiona solicitudes, vinculación institucional y estado del usuario." {
            tags "Soporte"
        }

        confianza = element "Confianza" "Bounded Context · soporte" "Mantiene porcentaje, nivel, sanciones y restricciones asociadas al usuario." {
            tags "Soporte"
        }

        reglas = element "Reglas y Términos" "Bounded Context · soporte" "Administra reglas vigentes, versiones, incumplimientos y términos aceptados." {
            tags "Soporte"
        }

        autenticacion = element "Autenticación (auth)" "Bounded Context · genérico de apoyo" "Proporciona identidad autenticada, rol y control de acceso." {
            tags "Generico"
        }

        prestamos -> usuarios "verifica usuario habilitado"
        prestamos -> inventario "consulta y ocupa ejemplares"
        prestamos -> confianza "considera restricciones"
        prestamos -> autenticacion "requiere identidad y permisos"
        reglas -> confianza "incumplimientos reducen confianza"
        confianza -> usuarios "asocia confianza al usuario"
        autenticacion -> usuarios "vincula cuenta con usuario"
    }

    views {
        custom "MapaContextosDDD" {
            title "Mapa de contextos DDD — préstamos universitarios"
            description "División estratégica actual del dominio. Flechas consumidor → proveedor, salvo Reglas y Términos → Confianza, que representa el efecto del incumplimiento sobre la confianza. No muestra entidades ni clases internas."
            include prestamos inventario usuarios confianza reglas autenticacion
            autoLayout lr 360 240
        }

        styles {
            element "Element" {
                shape RoundedBox
                background #334155
                color #ffffff
                fontSize 28
                width 420
                height 180
            }
            element "Central" {
                background #075985
                stroke #082f49
                strokeWidth 4
            }
            element "Soporte" {
                background #166534
                stroke #14532d
            }
            element "Generico" {
                background #6b21a8
                stroke #581c87
            }
            relationship "Relationship" {
                color #475569
                fontSize 22
                thickness 3
            }
        }
    }
}
