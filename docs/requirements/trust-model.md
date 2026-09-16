# Modelo de confianza

El modelo de confianza permite representar el cumplimiento de las reglas por parte de cada usuario y aplicar las condiciones de préstamo que correspondan. Esta definición es conceptual; los valores marcados como pendientes no deben asumirse durante la implementación.

## Porcentaje y niveles

- Cada usuario tendrá un porcentaje de confianza dentro del intervalo cerrado de **0 a 100**.
- El porcentaje determinará uno de **cuatro niveles de confianza**.
- Los límites exactos de los cuatro niveles están **pendientes de definición**.
- El porcentaje inicial asignado a un usuario está **pendiente de definición**.
- Los usuarios con niveles bajos podrán tener restricciones de préstamo, pero los niveles afectados y las restricciones concretas están **pendientes de definición**.
- El sistema deberá impedir que el porcentaje tome valores fuera del intervalo permitido. El mecanismo para mantener esa invariante todavía no está definido.

## Incumplimientos y penalizaciones

Cada incumplimiento puede reducir la confianza en un porcentaje diferente. La penalización:

- pertenece a la regla incumplida;
- representa la gravedad de esa regla;
- se obtiene de su configuración persistida, no de una constante en el código;
- puede ser definida y modificada por administradores;
- debe registrarse con el incumplimiento para conservar cuánto se descontó realmente.

Los cambios posteriores en una regla no deben alterar la penalización que quedó registrada en incumplimientos anteriores. Esta conservación histórica se detalla en [términos y condiciones](terms-and-conditions.md).

Porcentajes como **5 %**, **10 %** o **12 %** son únicamente ejemplos ilustrativos. No representan valores aprobados ni deben utilizarse como configuración predeterminada.

## Definiciones pendientes

| Aspecto | Estado actual |
| --- | --- |
| Porcentaje inicial | Pendiente de definición. |
| Límites de los cuatro niveles | Pendientes de definición. |
| Restricciones por nivel | Pendientes de definición. |
| Mecanismos para aumentar la confianza | No definidos; no deben incorporarse todavía. |

Las reglas generales que sustentan este modelo se encuentran en [reglas de negocio](business-rules.md).
