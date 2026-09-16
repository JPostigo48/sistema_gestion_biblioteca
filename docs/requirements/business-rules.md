# Reglas de negocio

Este documento reúne las reglas que delimitan el comportamiento actual del dominio. Su implementación deberá mantenerse coherente con los [requisitos funcionales](functional.md), el [modelo de confianza](trust-model.md) y la gestión de [términos y condiciones](terms-and-conditions.md).

## Usuarios y acceso

| ID | Regla |
| --- | --- |
| RN-01 | Solo podrán utilizar el sistema estudiantes, docentes y personal administrativo vinculados actualmente con la EPCC. |
| RN-02 | La cuenta asignada a un usuario es personal e intransferible. |

## Inventario y préstamos

| ID | Regla |
| --- | --- |
| RN-03 | Todo préstamo está sujeto a la disponibilidad de ejemplares del inventario. |
| RN-04 | Un ejemplar solo puede estar asociado a un préstamo activo a la vez. |
| RN-05 | Un recurso puede continuar apareciendo disponible mientras exista al menos uno de sus ejemplares disponible. |
| RN-06 | Cada categoría de recurso puede tener un tiempo máximo de préstamo diferente. |
| RN-07 | Antes de realizar un préstamo debe verificarse que el usuario se encuentre habilitado. |
| RN-08 | El usuario se compromete al buen uso de los recursos prestados. |
| RN-09 | Los recursos prestados no pueden utilizarse con fines de lucro. |
| RN-10 | El usuario es responsable por pérdida, robo o daño ocurrido mientras tenga asignado un ejemplar. |
| RN-11 | Todo ejemplar debe devolverse dentro de la fecha u hora establecida. |
| RN-12 | Los retrasos pueden generar restricciones o consecuencias según las reglas vigentes. |
| RN-13 | Las restricciones de préstamo pueden variar según el tipo de usuario. |

## Confianza e incumplimientos

| ID | Regla |
| --- | --- |
| RN-14 | Todo usuario posee un porcentaje de confianza. |
| RN-15 | El porcentaje de confianza determina uno de cuatro niveles de confianza. |
| RN-16 | Las condiciones y restricciones de préstamo pueden variar según el nivel de confianza. |
| RN-17 | Cada regla puede reducir la confianza del usuario en un porcentaje configurable según su gravedad. |
| RN-18 | Los porcentajes de penalización no deben estar codificados como constantes del sistema; deben provenir de la configuración persistida de cada regla. |
| RN-19 | Los cambios futuros en una regla no deben modificar retroactivamente el porcentaje aplicado en incumplimientos anteriores. |

Los valores y restricciones todavía no definidos se detallan en el [modelo de confianza](trust-model.md).

## Administración de reglas y términos

| ID | Regla |
| --- | --- |
| RN-20 | Las reglas y términos deben poder modificarse dinámicamente por administradores sin requerir cambios de código. |

La información mínima de las reglas, su vigencia y su historial se describen en [términos y condiciones](terms-and-conditions.md).
