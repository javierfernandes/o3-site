[[_TOC_]]


## []()Introducción

Queremos hacer un DSL que permita planificar una conferencia. 



El programa tiene tres objetivos:

* Poder describir toda esta información de la forma más sencilla posible.
* Validar que la planificación cumple con todas las restricciones (se detallan más abajo).



El enunciado pide una gran cantidad de validaciones. Estas validaciones pueden hacerse en el propio editor (vía @Check) o pueden hacerse en el *runtime*, es decir, ejecutar un intérprete que recorra el modelo semántico informando en caso de errores o warnings.


 * Lo obligatorio es que al menos una de las validaciones se haga en el editor, las demás quedan a su criterio.
 * Lo ideal sería que el propio editor tenga la mayor cantidad de validaciones posibles, así a medida que uno escribe le va informando de los problemas. 

## []()Descripción de las actividades

La conferencia tiene diferentes actividades:

* Charlas de las que queremos saber su título, duración y los oradores, que pueden ser uno o más.
* Mesa de debate, que también definen un título, duración y los oradores deben ser al menos dos.
* Talleres en los que se enseña una herramienta. Se deben hacer en aulas con computadoras.

De cada orador se sabe su nombre y la organización a la que pertenece. En caso de una mesa debate los oradores deben ser cada uno de una organización distinta.
De cada actividad se sabe también la cantidad de asistentes esperada.


La conferencia tiene varios "tracks" cada uno orientado a una temática dinstinta, como ser: docencia, arquitectura de software, herramientas y frameworks, metodología, etc. De cada charla se debe saber a qué track corresponde.
## []()Schedule

El siguiente paso para organizar la conferencia es definir los horarios de cada actividad. Para ello se le debe asignar un horario a cada charla y un espacio. 
De los espacios se sabe su nombre y la cantidad de asientos que tienen. Las aulas con computadoras también deben estar definidas como espacios y sólo se pueden usar para los talleres.


Además de las actividades específicas de la conferencia, hay que planificar otras actividades accesorias:

* Break, para desayuno o almuerzo.
* Registración
* Eventos de inauguración y cierre.



Las actividades que se realizan en el mismo espacio entre dos breaks se consideran un "bloque". Todas las actividades en un bloque deben corresponder al mismo track. Los bloques no pueden durar más de 2 horas.



Una conferencia puede durar varios días. De cada día, las actividades planificadas deben ser continuas, no pueden quedar huecos.




Reglas y checkeos




* Se debe validar que un orador no esté participando en dos actividades al mismo tiempo. Adicionalmente, si un orador tiene dos actividades adyacentes (una empieza justo a la hora que termina la otra) se debe generar un *warning*.
* También se genera un warning si en un mismo bloque hay más de una charla de la misma organización.
* Todas las actividades definidas deben estar incluidas en el schedule.
* Verificar la cantidad de asistentes esperada vs. el espacio asignado. Dado que la cantidad esperada es sólo una estimación, lo que se espera es que eso ocupe entre el 50 y el 90% de la capacidad del espacio asignado. Por fuera de ese rango se produce un warning. Si la cantidad esperada supera el 100% de la capacidad entonces es un error.
* La duración mínima de una charla es de 30 minutos y de una mesa de debate de 1 hora. Los breaks tienen una duración mínima de 15 minutos y el horario de almuerzo de 45 minutos.
* Algunas charlas pueden estar definidas como "keynote". En el momento que se realiza una keynote no puede haber otras charlas al mismo tiempo.


## []()Generación de Código

El objetivo final de este DSL es generar una página HTML que muestre el schedule de la conferencia, mostrando las charlas con sus oradores y tracks. A continuación se presenta un ejemplo del resultado esperado.






Untitled spreadsheet